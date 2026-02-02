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
