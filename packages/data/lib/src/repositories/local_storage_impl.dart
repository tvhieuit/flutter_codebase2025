import 'dart:convert';

import 'package:domain/domain.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Implementation of [LocalStorage] using SharedPreferencesAsync.
@LazySingleton(as: LocalStorage)
class LocalStorageImpl implements LocalStorage {
  final SharedPreferencesAsync _prefs;

  LocalStorageImpl(this._prefs);

  // STRING
  @override
  Future<String?> getString(String key) async => await _prefs.getString(key);

  @override
  Future<void> setString(String key, String value) async => await _prefs.setString(key, value);

  // INT
  @override
  Future<int?> getInt(String key) async => await _prefs.getInt(key);

  @override
  Future<void> setInt(String key, int value) async => await _prefs.setInt(key, value);

  // DOUBLE
  @override
  Future<double?> getDouble(String key) async => await _prefs.getDouble(key);

  @override
  Future<void> setDouble(String key, double value) async => await _prefs.setDouble(key, value);

  // BOOL
  @override
  Future<bool?> getBool(String key) async => await _prefs.getBool(key);

  @override
  Future<void> setBool(String key, bool value) async => await _prefs.setBool(key, value);

  // STRING LIST
  @override
  Future<List<String>?> getStringList(String key) async => await _prefs.getStringList(key);

  @override
  Future<void> setStringList(String key, List<String> value) async =>
      await _prefs.setStringList(key, value);

  // JSON OBJECT
  @override
  Future<Map<String, dynamic>?> getJson(String key) async {
    final jsonString = await _prefs.getString(key);
    if (jsonString == null || jsonString.isEmpty) return null;
    try {
      return jsonDecode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> setJson(String key, Map<String, dynamic> value) async {
    final jsonString = jsonEncode(value);
    await _prefs.setString(key, jsonString);
  }

  // JSON LIST
  @override
  Future<List<Map<String, dynamic>>?> getJsonList(String key) async {
    final jsonString = await _prefs.getString(key);
    if (jsonString == null || jsonString.isEmpty) return null;
    try {
      final decoded = jsonDecode(jsonString) as List<dynamic>;
      return decoded.cast<Map<String, dynamic>>();
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> setJsonList(String key, List<Map<String, dynamic>> value) async {
    final jsonString = jsonEncode(value);
    await _prefs.setString(key, jsonString);
  }

  // UTILITIES
  @override
  Future<bool> containsKey(String key) async => await _prefs.containsKey(key);

  @override
  Future<void> remove(String key) async => await _prefs.remove(key);

  @override
  Future<void> clear() async => await _prefs.clear();

  @override
  Future<Set<String>> getKeys() async => await _prefs.getKeys();
}
