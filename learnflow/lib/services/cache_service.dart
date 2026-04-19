/// lib/services/cache_service.dart


class CachedData<T> {
  final T data;
  final DateTime timestamp;
  final Duration ttl;

  CachedData(this.data, {Duration? ttl}) 
    : timestamp = DateTime.now(),
      ttl = ttl ?? const Duration(minutes: 5);

  bool get isExpired {
    return DateTime.now().difference(timestamp) > ttl;
  }
}

class CacheService {
  static final Map<String, CachedData> _cache = {};
  static Future<T> getCached<T>(
    String key,
    Future<T> Function() fetcher, {
    Duration? ttl,
  }) async {
    if (_cache.containsKey(key)) {
      final cached = _cache[key];
      if (cached != null && !cached.isExpired && cached.data is T) {
        return cached.data as T;
      }
      _cache.remove(key);
    }

    final data = await fetcher();
    
    _cache[key] = CachedData(data, ttl: ttl);
    
    return data;
  }

  static void invalidate(String key) {
    _cache.remove(key);
  }

  static void invalidateAll() {
    _cache.clear();
  }

  static int getCacheSize() {
    return _cache.length;
  }

  static void cleanup() {
    _cache.removeWhere((_, cached) => cached.isExpired);
  }
}
