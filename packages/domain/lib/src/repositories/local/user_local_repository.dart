import 'package:injectable/injectable.dart';

import '../../entities/user_entity.dart';
import 'package:app_core/app_core.dart';
import 'local_storage.dart';
import 'local_storage_keys.dart';

/// Local repository interface for user data caching.
abstract class UserLocalRepository {
  /// Gets the current cached user
  Future<Result<UserEntity?>> getCurrentUser();

  /// Saves the current user to cache
  Future<Result<void>> saveCurrentUser(UserEntity user);

  /// Clears the current user from cache
  Future<Result<void>> clearCurrentUser();

  /// Gets cached user list
  Future<Result<List<UserEntity>>> getCachedUsers();

  /// Saves user list to cache
  Future<Result<void>> cacheUsers(List<UserEntity> users);

  /// Clears cached user list
  Future<Result<void>> clearCachedUsers();

  /// Checks if user cache is valid (not expired)
  Future<bool> isUsersCacheValid({Duration maxAge = const Duration(hours: 1)});

  /// Gets access token
  Future<Result<String?>> getAccessToken();

  /// Saves access token
  Future<Result<void>> saveAccessToken(String token);

  /// Clears access token
  Future<Result<void>> clearAccessToken();

  /// Clears all user-related data (logout)
  Future<Result<void>> clearAllUserData();
}

/// Implementation of [UserLocalRepository] using [LocalStorage].
@LazySingleton(as: UserLocalRepository)
class UserLocalRepositoryImpl implements UserLocalRepository {
  final LocalStorage _storage;

  UserLocalRepositoryImpl(this._storage);

  @override
  Future<Result<UserEntity?>> getCurrentUser() async {
    try {
      final json = await _storage.getJson(StorageKeys.currentUser);
      if (json == null) return const Result.success(null);

      return Result.success(UserEntity.fromJson(json));
    } catch (e) {
      return Result.failure(
        Failure.cache(message: 'Failed to get current user: $e'),
      );
    }
  }

  @override
  Future<Result<void>> saveCurrentUser(UserEntity user) async {
    try {
      await _storage.setJson(StorageKeys.currentUser, user.toJson());
      return const Result.success(null);
    } catch (e) {
      return Result.failure(
        Failure.cache(message: 'Failed to save current user: $e'),
      );
    }
  }

  @override
  Future<Result<void>> clearCurrentUser() async {
    try {
      await _storage.remove(StorageKeys.currentUser);
      return const Result.success(null);
    } catch (e) {
      return Result.failure(
        Failure.cache(message: 'Failed to clear current user: $e'),
      );
    }
  }

  @override
  Future<Result<List<UserEntity>>> getCachedUsers() async {
    try {
      final jsonList = await _storage.getJsonList(StorageKeys.cachedUsers);
      if (jsonList == null || jsonList.isEmpty) {
        return const Result.success([]);
      }

      final users = jsonList.map((json) => UserEntity.fromJson(json)).toList();
      return Result.success(users);
    } catch (e) {
      return Result.failure(
        Failure.cache(message: 'Failed to get cached users: $e'),
      );
    }
  }

  @override
  Future<Result<void>> cacheUsers(List<UserEntity> users) async {
    try {
      final jsonList = users.map((user) => user.toJson()).toList();
      await _storage.setJsonList(StorageKeys.cachedUsers, jsonList);

      // Save cache timestamp
      await _storage.setInt(
        StorageKeys.usersCacheTimestamp,
        DateTime.now().millisecondsSinceEpoch,
      );

      return const Result.success(null);
    } catch (e) {
      return Result.failure(
        Failure.cache(message: 'Failed to cache users: $e'),
      );
    }
  }

  @override
  Future<Result<void>> clearCachedUsers() async {
    try {
      await _storage.remove(StorageKeys.cachedUsers);
      await _storage.remove(StorageKeys.usersCacheTimestamp);
      return const Result.success(null);
    } catch (e) {
      return Result.failure(
        Failure.cache(message: 'Failed to clear cached users: $e'),
      );
    }
  }

  @override
  Future<bool> isUsersCacheValid({
    Duration maxAge = const Duration(hours: 1),
  }) async {
    try {
      final timestamp = await _storage.getInt(StorageKeys.usersCacheTimestamp);
      if (timestamp == null) return false;

      final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      final now = DateTime.now();

      return now.difference(cacheTime) < maxAge;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<Result<String?>> getAccessToken() async {
    try {
      final token = await _storage.getString(StorageKeys.accessToken);
      return Result.success(token);
    } catch (e) {
      return Result.failure(
        Failure.cache(message: 'Failed to get access token: $e'),
      );
    }
  }

  @override
  Future<Result<void>> saveAccessToken(String token) async {
    try {
      await _storage.setString(StorageKeys.accessToken, token);
      return const Result.success(null);
    } catch (e) {
      return Result.failure(
        Failure.cache(message: 'Failed to save access token: $e'),
      );
    }
  }

  @override
  Future<Result<void>> clearAccessToken() async {
    try {
      await _storage.remove(StorageKeys.accessToken);
      await _storage.remove(StorageKeys.refreshToken);
      await _storage.remove(StorageKeys.tokenExpiry);
      return const Result.success(null);
    } catch (e) {
      return Result.failure(
        Failure.cache(message: 'Failed to clear access token: $e'),
      );
    }
  }

  @override
  Future<Result<void>> clearAllUserData() async {
    try {
      // Clear user data
      await clearCurrentUser();
      await clearCachedUsers();
      await clearAccessToken();

      // Clear user preferences
      await _storage.remove(StorageKeys.userPreferences);
      await _storage.remove(StorageKeys.userId);

      return const Result.success(null);
    } catch (e) {
      return Result.failure(
        Failure.cache(message: 'Failed to clear all user data: $e'),
      );
    }
  }
}
