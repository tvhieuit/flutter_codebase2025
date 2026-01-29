extension IterableExtension<T> on Iterable<T> {
  /// Returns the first element matching [test], or null if none found
  T? firstWhereOrNull(bool Function(T) test) {
    for (final element in this) {
      if (test(element)) return element;
    }
    return null;
  }

  /// Returns the last element matching [test], or null if none found
  T? lastWhereOrNull(bool Function(T) test) {
    T? result;
    for (final element in this) {
      if (test(element)) result = element;
    }
    return result;
  }

  /// Groups elements by a key function
  Map<K, List<T>> groupBy<K>(K Function(T) keyFunction) {
    final map = <K, List<T>>{};
    for (final element in this) {
      final key = keyFunction(element);
      (map[key] ??= []).add(element);
    }
    return map;
  }

  /// Returns a list of distinct elements (preserving order)
  List<T> get distinct {
    final seen = <T>{};
    return where((element) => seen.add(element)).toList();
  }

  /// Returns distinct elements by a key function
  List<T> distinctBy<K>(K Function(T) keyFunction) {
    final seen = <K>{};
    return where((element) => seen.add(keyFunction(element))).toList();
  }
}
