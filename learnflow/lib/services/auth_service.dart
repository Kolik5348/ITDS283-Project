// lib/services/auth_service.dart
import 'api_service.dart';

class AuthService {
  static Future<Map<String, dynamic>> syncGoogleLogin(String name) async {
    return await ApiService.post('/api/auth/login', {
      'name': name,
      'auth_provider': 'google',
    });
  }

  static Future<Map<String, dynamic>> registerUser({
    required String firstName,
    required String lastName,
    required String phone,
    String? birthDate,
  }) async {
    return await ApiService.post('/api/auth/register', {
      'first_name': firstName,
      'last_name':  lastName,
      'phone':      phone,
      if (birthDate != null) 'birth_date': birthDate,
    });
  }
}
