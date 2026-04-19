/// lib/services/secure_local_storage_service.dart

import 'package:hive_flutter/hive_flutter.dart';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'dart:async';
import 'dart:convert';

const int _encryptionKeyLength = 32; // 256-bit

const String _encryptedCacheBoxName = 'secure_cache';
const String _submissionMetadataBoxName = 'submission_metadata';

class SecureLocalStorageService {
  static late Box<dynamic> _encryptedCacheBox;
  static late Box<dynamic> _metadataBox;
  static late Uint8List _encryptionKey;
  static late encrypt.Key _aesKey;
  static late encrypt.IV _encryptionIV;
  static late encrypt.Encrypter _encrypter;

  static Future<void> init() async {
    await Hive.initFlutter();
    
    _encryptionKey = await _getOrGenerateEncryptionKey();
    
    _aesKey = encrypt.Key(_encryptionKey);
    _encryptionIV = encrypt.IV.fromLength(16);
    _encrypter = encrypt.Encrypter(encrypt.AES(_aesKey));

    try {
      _encryptedCacheBox = await Hive.openBox(
        _encryptedCacheBoxName,
      );
      
      _metadataBox = await Hive.openBox(_submissionMetadataBoxName);
    } catch (e) {
      throw Exception('Failed to initialize secure storage: $e');
    }
  }

  static Future<Uint8List> _getOrGenerateEncryptionKey() async {
    final key = encrypt.Key.fromSecureRandom(_encryptionKeyLength);
    return key.bytes;
  }

  static Future<void> cacheQuizSubmissionMetadata({
    required int quizId,
    required int timeSpent,
  }) async {
    try {
      final timestamp = DateTime.now();
      final metadata = {
        'quiz_id': quizId,
        'time_spent': timeSpent,
        'timestamp': timestamp.toIso8601String(),
        'synced': false,
      };
      
      final key = '${quizId}_${timestamp.millisecondsSinceEpoch}';
      await _metadataBox.put(key, metadata);
    } catch (e) {
      throw Exception('Failed to cache submission metadata: $e');
    }
  }

  static Future<List<Map<String, dynamic>>> getPendingSubmissions() async {
    try {
      final pending = <Map<String, dynamic>>[];
      for (var key in _metadataBox.keys) {
        final data = _metadataBox.get(key) as Map?;
        if (data != null && data['synced'] != true) {
          pending.add(Map<String, dynamic>.from(data));
        }
      }
      return pending;
    } catch (e) {
      throw Exception('Failed to retrieve pending submissions: $e');
    }
  }

  static Future<void> markSubmissionSynced(int quizId, String timestamp) async {
    try {
      final key = '${quizId}_$timestamp';
      final data = _metadataBox.get(key) as Map?;
      if (data != null) {
        data['synced'] = true;
        await _metadataBox.put(key, data);
      }
    } catch (e) {
      throw Exception('Failed to mark submission as synced: $e');
    }
  }

  static Future<void> clearSyncedSubmissions() async {
    try {
      final keysToDelete = <dynamic>[];
      for (var key in _metadataBox.keys) {
        final data = _metadataBox.get(key) as Map?;
        if (data != null && data['synced'] == true) {
          keysToDelete.add(key);
        }
      }
      for (var key in keysToDelete) {
        await _metadataBox.delete(key);
      }
    } catch (e) {
      throw Exception('Failed to clear synced submissions: $e');
    }
  }

  static Future<void> setEncrypted(String key, dynamic value) async {
    try {
      final plaintext = jsonEncode(value);
      final encrypted = _encrypter.encrypt(plaintext, iv: _encryptionIV);
      await _encryptedCacheBox.put(key, encrypted.base64);
    } catch (e) {
      throw Exception('Failed to store encrypted data: $e');
    }
  }

  static Future<dynamic> getEncrypted(String key) async {
    try {
      final encryptedBase64 = _encryptedCacheBox.get(key);
      if (encryptedBase64 == null) return null;
      
      final decrypted = _encrypter.decrypt64(
        encryptedBase64 as String,
        iv: _encryptionIV,
      );
      return jsonDecode(decrypted);
    } catch (e) {
      throw Exception('Failed to retrieve encrypted data: $e');
    }
  }

  static Future<void> cleanupOldCache() async {
    try {
      final now = DateTime.now();
      final keysToDelete = <dynamic>[];
      
      for (var key in _metadataBox.keys) {
        final data = _metadataBox.get(key) as Map?;
        if (data != null) {
          final timestamp = DateTime.parse(data['timestamp'] as String);
          if (now.difference(timestamp).inDays > 7) {
            keysToDelete.add(key);
          }
        }
      }
      
      for (var key in keysToDelete) {
        await _metadataBox.delete(key);
      }
    } catch (e) {
      throw Exception('Failed to cleanup old cache: $e');
    }
  }
}
