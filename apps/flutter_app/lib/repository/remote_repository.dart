import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../entities/user_model.dart';

/// Remote repository interface for API calls
abstract class RemoteRepository {
  Future<UserModel> getUserProfile(int userId);
  Future<List<UserModel>> getUsers();
  Future<UserModel> updateUserProfile(int userId, Map<String, dynamic> data);
  Future<void> deleteUser(int userId);
}

/// Implementation of remote repository
@Injectable(as: RemoteRepository)
class RemoteRepositoryImpl implements RemoteRepository {
  final Dio _dio;

  RemoteRepositoryImpl(this._dio);

  @override
  Future<UserModel> getUserProfile(int userId) async {
    final response = await _dio.get('/users/$userId');
    return UserModel.fromJson(response.data);
  }

  @override
  Future<List<UserModel>> getUsers() async {
    final response = await _dio.get('/users');
    final List<dynamic> data = response.data;
    return data.map((json) => UserModel.fromJson(json)).toList();
  }

  @override
  Future<UserModel> updateUserProfile(int userId, Map<String, dynamic> data) async {
    final response = await _dio.put('/users/$userId', data: data);
    return UserModel.fromJson(response.data);
  }

  @override
  Future<void> deleteUser(int userId) async {
    await _dio.delete('/users/$userId');
  }
}
