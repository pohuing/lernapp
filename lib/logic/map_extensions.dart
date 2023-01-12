extension FallbackAccess<K, V> on Map{
  V orDefault(K key, V fallback) {
    if (containsKey(key)) {
      return this[key];
    } else {
      return fallback;
    }
  }

  T transformOrFallback<T>(K key, T Function(V value) transform, T fallback) {
    if (containsKey(key)) {
      return transform(this[key]);
    } else {
      return fallback;
    }
  }
}