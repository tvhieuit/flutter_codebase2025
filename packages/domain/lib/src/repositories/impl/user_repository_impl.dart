import 'dart:convert';

import 'package:app_core/app_core.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../domain.dart';

/// Implementation of [UserRepository] using Dio for remote data and SharedPreferences for local cache.
@Injectable(as: UserRepository)
class UserRepositoryImpl implements UserRepository {
  final Dio _dio;
  final SharedPreferencesAsync _prefs;

  static const String _keyUser = 'user';
  static const String _keyUserList = 'user_list';

  UserRepositoryImpl(this._dio, this._prefs);

  @override
  Future<Result<UserEntity>> getUserById(int id) async {
    try {
      final response = await _dio.get('/users/$id');
      final user = UserEntity.fromJson(response.data);

      // Update cache
      await cacheUser(user);

      return Result.success(user);
    } on DioException catch (e) {
      // Try to get from cache as fallback
      final cached = await getCachedUser();
      if (cached is ResultSuccess<UserEntity?> && cached.data != null && cached.data!.id == id) {
        return Result.success(cached.data!);
      }
      return Result.failure(_handleDioError(e));
    } catch (e) {
      return Result.failure(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Result<List<UserEntity>>> getUsers({int? page, int? limit}) async {
    try {
      final queryParameters = <String, dynamic>{};
      if (page != null) queryParameters['page'] = page;
      if (limit != null) queryParameters['limit'] = limit;

      final response = await _dio.get(
        '/users',
        queryParameters: queryParameters,
      );
      final List<dynamic> data = response.data;
      final users = data.map((json) => UserEntity.fromJson(json)).toList();

      // Update cache
      await cacheUserList(users);

      return Result.success(users);
    } on DioException catch (e) {
      // Try to get from cache as fallback
      final cached = await getCachedUserList();
      if (cached is ResultSuccess<List<UserEntity>> && cached.data.isNotEmpty) {
        return Result.success(cached.data);
      }
      return Result.failure(_handleDioError(e));
    } catch (e) {
      return Result.failure(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Result<UserEntity>> createUser({
    required String name,
    required String email,
    String? phone,
  }) async {
    try {
      final data = {
        'name': name,
        'email': email,
        if (phone != null) 'phone': phone,
      };

      final response = await _dio.post('/users', data: data);
      final user = UserEntity.fromJson(response.data);

      // Update cache
      await cacheUser(user);

      return Result.success(user);
    } on DioException catch (e) {
      return Result.failure(_handleDioError(e));
    } catch (e) {
      return Result.failure(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Result<UserEntity>> updateUser({
    required int id,
    String? name,
    String? email,
    String? phone,
  }) async {
    try {
      final data = <String, dynamic>{};
      if (name != null) data['name'] = name;
      if (email != null) data['email'] = email;
      if (phone != null) data['phone'] = phone;

      final response = await _dio.put('/users/$id', data: data);
      final user = UserEntity.fromJson(response.data);

      // Update cache
      await cacheUser(user);

      return Result.success(user);
    } on DioException catch (e) {
      return Result.failure(_handleDioError(e));
    } catch (e) {
      return Result.failure(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Result<List<UserEntity>>> searchUsers(String query) async {
    try {
      final response = await _dio.get(
        '/users/search',
        queryParameters: {'q': query},
      );
      final List<dynamic> data = response.data;
      final users = data.map((json) => UserEntity.fromJson(json)).toList();

      return Result.success(users);
    } on DioException catch (e) {
      return Result.failure(_handleDioError(e));
    } catch (e) {
      return Result.failure(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> deleteUser(int id) async {
    try {
      await _dio.delete('/users/$id');
      await clearCachedUser();
      return const Result.success(null);
    } on DioException catch (e) {
      return Result.failure(_handleDioError(e));
    } catch (e) {
      return Result.failure(Failure.unknown(message: e.toString()));
    }
  }

  // --- Local Cache ---

  @override
  Future<Result<UserEntity?>> getCachedUser() async {
    try {
      final json = await _prefs.getString(_keyUser);
      if (json == null) return const Result.success(null);

      final Map<String, dynamic> data = jsonDecode(json);
      return Result.success(UserEntity.fromJson(data));
    } catch (e) {
      return Result.failure(Failure.cache(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> cacheUser(UserEntity user) async {
    try {
      final json = jsonEncode(user.toJson());
      await _prefs.setString(_keyUser, json);
      return const Result.success(null);
    } catch (e) {
      return Result.failure(Failure.cache(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> clearCachedUser() async {
    try {
      await _prefs.remove(_keyUser);
      return const Result.success(null);
    } catch (e) {
      return Result.failure(Failure.cache(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> cacheUserList(List<UserEntity> users) async {
    try {
      final jsonList = users.map((user) => user.toJson()).toList();
      final json = jsonEncode(jsonList);
      await _prefs.setString(_keyUserList, json);
      return const Result.success(null);
    } catch (e) {
      return Result.failure(Failure.cache(message: e.toString()));
    }
  }

  @override
  Future<Result<List<UserEntity>>> getCachedUserList() async {
    try {
      final json = await _prefs.getString(_keyUserList);
      if (json == null) return const Result.success([]);

      final List<dynamic> data = jsonDecode(json);
      final users = data.map((item) => UserEntity.fromJson(item)).toList();
      return Result.success(users);
    } catch (e) {
      return Result.failure(Failure.cache(message: e.toString()));
    }
  }

  // Helpers

  Failure _handleDioError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.connectionError) {
      return Failure.network(message: e.message ?? 'Network error');
    }

    if (e.response != null) {
      final statusCode = e.response!.statusCode;
      if (statusCode == 401) return const Failure.auth(message: 'Unauthorized');
      if (statusCode == 404) return const Failure.server(message: 'Not found', statusCode: 404);
      return Failure.server(
        message: e.message ?? 'Server error',
        statusCode: statusCode,
      );
    }

    return Failure.unknown(message: e.message ?? 'Unknown error');
  }
}
