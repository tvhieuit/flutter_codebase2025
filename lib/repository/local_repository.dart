import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../entities/user_model.dart';

/// Local repository interface for local storage
abstract class LocalRepository {
  Future<void> saveUser(UserModel user);
  Future<UserModel?> getUser();
  Future<void> saveUserList(List<UserModel> users);
  Future<List<UserModel>> getUserList();
  Future<void> clearUser();
  Future<void> saveToken(String token);
  Future<String?> getToken();
  Future<void> clearToken();
}

/// Implementation of local repository
@Injectable(as: LocalRepository)
class LocalRepositoryImpl implements LocalRepository {
  final SharedPreferencesAsync _prefs;

  static const String _keyUser = 'user';
  static const String _keyUserList = 'user_list';
  static const String _keyToken = 'token';

  LocalRepositoryImpl(this._prefs);

  @override
  Future<void> saveUser(UserModel user) async {
    final json = jsonEncode(user.toJson());
    await _prefs.setString(_keyUser, json);
  }

  @override
  Future<UserModel?> getUser() async {
    final json = await _prefs.getString(_keyUser);
    if (json == null) return null;

    final Map<String, dynamic> data = jsonDecode(json);
    return UserModel.fromJson(data);
  }

  @override
  Future<void> saveUserList(List<UserModel> users) async {
    final jsonList = users.map((user) => user.toJson()).toList();
    final json = jsonEncode(jsonList);
    await _prefs.setString(_keyUserList, json);
  }

  @override
  Future<List<UserModel>> getUserList() async {
    final json = await _prefs.getString(_keyUserList);
    if (json == null) return [];

    final List<dynamic> data = jsonDecode(json);
    return data.map((item) => UserModel.fromJson(item)).toList();
  }

  @override
  Future<void> clearUser() async {
    await _prefs.remove(_keyUser);
  }

  @override
  Future<void> saveToken(String token) async {
    await _prefs.setString(_keyToken, token);
  }

  @override
  Future<String?> getToken() async {
    return await _prefs.getString(_keyToken);
  }

  @override
  Future<void> clearToken() async {
    await _prefs.remove(_keyToken);
  }
}
