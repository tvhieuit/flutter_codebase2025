/// Local storage interface for key-value persistence.
///
/// This abstract interface allows different implementations
/// (SharedPreferences, Hive, SQLite, etc.)
abstract class LocalStorage {
  // ==========================================================================
  // STRING
  // ==========================================================================

  /// Gets a string value by key
  Future<String?> getString(String key);

  /// Sets a string value
  Future<void> setString(String key, String value);

  // ==========================================================================
  // INT
  // ==========================================================================

  /// Gets an int value by key
  Future<int?> getInt(String key);

  /// Sets an int value
  Future<void> setInt(String key, int value);

  // ==========================================================================
  // DOUBLE
  // ==========================================================================

  /// Gets a double value by key
  Future<double?> getDouble(String key);

  /// Sets a double value
  Future<void> setDouble(String key, double value);

  // ==========================================================================
  // BOOL
  // ==========================================================================

  /// Gets a bool value by key
  Future<bool?> getBool(String key);

  /// Sets a bool value
  Future<void> setBool(String key, bool value);

  // ==========================================================================
  // STRING LIST
  // ==========================================================================

  /// Gets a string list value by key
  Future<List<String>?> getStringList(String key);

  /// Sets a string list value
  Future<void> setStringList(String key, List<String> value);

  // ==========================================================================
  // JSON OBJECT
  // ==========================================================================

  /// Gets a JSON object by key
  Future<Map<String, dynamic>?> getJson(String key);

  /// Sets a JSON object
  Future<void> setJson(String key, Map<String, dynamic> value);

  // ==========================================================================
  // JSON LIST
  // ==========================================================================

  /// Gets a JSON list by key
  Future<List<Map<String, dynamic>>?> getJsonList(String key);

  /// Sets a JSON list
  Future<void> setJsonList(String key, List<Map<String, dynamic>> value);

  // ==========================================================================
  // UTILITIES
  // ==========================================================================

  /// Checks if a key exists
  Future<bool> containsKey(String key);

  /// Removes a value by key
  Future<void> remove(String key);

  /// Clears all stored data
  Future<void> clear();

  /// Gets all keys
  Future<Set<String>> getKeys();
}
