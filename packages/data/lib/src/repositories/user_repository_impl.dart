import 'dart:convert';

import 'package:app_core/app_core.dart';
import 'package:dio/dio.dart';
import 'package:domain/domain.dart';
import 'package:injectable/injectable.dart';

/// Implementation of [UserRepository] using Dio for remote data and LocalStorage for local cache.
@Injectable(as: UserRepository)
class UserRepositoryImpl implements UserRepository {
  final Dio _dio;
  final LocalStorage _localStorage;

  UserRepositoryImpl(this._dio, this._localStorage);

  static const String _keyUser = 'user';
  static const String _keyUserList = 'user_list';

  @override
  Future<Result<UserEntity>> getUserById(int id) async {
    try {
      final response = await _dio.get('/users/$id');
      final user = UserEntity.fromJson(response.data);

      // Update cache
      await _cacheUser(user);

      return Result.success(user);
    } on DioException catch (e) {
      // Try to get from cache as fallback
      final cached = await _getCachedUser();
      if (cached != null && cached.id == id) {
        return Result.success(cached);
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
      await _cacheUserList(users);

      return Result.success(users);
    } on DioException catch (e) {
      // Try to get from cache as fallback
      final cached = await _getCachedUserList();
      if (cached.isNotEmpty) {
        return Result.success(cached);
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
      final data = <String, dynamic>{
        'name': name,
        'email': email,
        if (phone != null) 'phone': phone,
      };

      final response = await _dio.post('/users', data: data);
      final user = UserEntity.fromJson(response.data);

      // Update cache
      await _cacheUser(user);

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
      await _cacheUser(user);

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
      await _clearCachedUser();
      return const Result.success(null);
    } on DioException catch (e) {
      return Result.failure(_handleDioError(e));
    } catch (e) {
      return Result.failure(Failure.unknown(message: e.toString()));
    }
  }

  // --- Private Cache Methods ---

  Future<UserEntity?> _getCachedUser() async {
    try {
      final json = await _localStorage.getString(_keyUser);
      if (json == null) return null;
      final Map<String, dynamic> data = jsonDecode(json);
      return UserEntity.fromJson(data);
    } catch (e) {
      return null;
    }
  }

  Future<void> _cacheUser(UserEntity user) async {
    try {
      final json = jsonEncode(user.toJson());
      await _localStorage.setString(_keyUser, json);
    } catch (_) {}
  }

  Future<void> _clearCachedUser() async {
    try {
      await _localStorage.remove(_keyUser);
    } catch (_) {}
  }

  Future<void> _cacheUserList(List<UserEntity> users) async {
    try {
      final jsonList = users.map((user) => user.toJson()).toList();
      final json = jsonEncode(jsonList);
      await _localStorage.setString(_keyUserList, json);
    } catch (_) {}
  }

  Future<List<UserEntity>> _getCachedUserList() async {
    try {
      final json = await _localStorage.getString(_keyUserList);
      if (json == null) return [];
      final List<dynamic> data = jsonDecode(json);
      return data.map((item) => UserEntity.fromJson(item)).toList();
    } catch (e) {
      return [];
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
