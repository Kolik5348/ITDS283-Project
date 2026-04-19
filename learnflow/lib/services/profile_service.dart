/// lib/services/profile_service.dart

import 'api_service.dart';
import 'cache_service.dart';

class ProfileService {
  static const String _cacheKey = 'profile';

  static Future<Map<String, dynamic>> getProfile({bool forceRefresh = false}) async {
    if (forceRefresh) {
      CacheService.invalidate(_cacheKey);
    }
    
    return await CacheService.getCached(
      _cacheKey,
      () => ApiService.get('/api/profile'),
      ttl: const Duration(minutes: 10),
    );
  }

  static void invalidateCache() {
    CacheService.invalidate(_cacheKey);
  }
}
