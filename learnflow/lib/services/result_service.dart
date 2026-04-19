// lib/services/result_service.dart  [UPDATED — เพิ่ม hasAttempted()]

import 'api_service.dart';

class ResultService {
  static Future<Map<String, dynamic>> getResult(int attemptId) async {
    return await ApiService.get('/api/result/$attemptId');
  }

  static Future<List<Map<String, dynamic>>> getReview(int attemptId) async {
    final data = await ApiService.get('/api/review/$attemptId');
    return List<Map<String, dynamic>>.from(data['answers']);
  }

  static Future<bool> hasAttempted(int quizId) async {
    try {
      final data = await ApiService.get('/api/quiz/$quizId/attempted');
      return data['has_attempted'] == true;
    } catch (_) {
      return false;
    }
  }
}
