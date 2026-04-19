/// lib/services/analytics_service.dart
import 'api_service.dart';
import 'cache_service.dart';

class AnalyticsService {
  static Future<Map<String, dynamic>> getDashboard({int days = 7, bool forceRefresh = false}) async {
    final cacheKey = 'dashboard_$days';
    if (forceRefresh) {
      CacheService.invalidate(cacheKey);
    }
    
    return await CacheService.getCached(
      cacheKey,
      () => ApiService.get('/api/dashboard?days=$days'),
      ttl: const Duration(minutes: 5),
    );
  }

  static Future<Map<String, dynamic>> getGrowth({bool forceRefresh = false}) async {
    const cacheKey = 'growth';
    if (forceRefresh) {
      CacheService.invalidate(cacheKey);
    }
    
    return await CacheService.getCached(
      cacheKey,
      () => ApiService.get('/api/growth'),
      ttl: const Duration(minutes: 10),
    );
  }

  static Future<List<Map<String, dynamic>>> getAnalysis({bool forceRefresh = false}) async {
    const cacheKey = 'analysis';
    if (forceRefresh) {
      CacheService.invalidate(cacheKey);
    }
    
    final data = await CacheService.getCached(
      cacheKey,
      () => ApiService.get('/api/analysis'),
      ttl: const Duration(minutes: 10),
    );
    return List<Map<String, dynamic>>.from(data['topics']);
  }

  static void invalidateCache() {
    CacheService.invalidate('dashboard_1');
    CacheService.invalidate('dashboard_7');
    CacheService.invalidate('dashboard_14');
    CacheService.invalidate('dashboard_30');
    CacheService.invalidate('growth');
    CacheService.invalidate('analysis');
  }
}
