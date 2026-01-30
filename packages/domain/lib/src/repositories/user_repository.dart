import '../entities/user_entity.dart';
import 'package:app_core/app_core.dart';

/// User repository interface.
///
/// This abstract interface defines the contract for user data access.
/// Implementation details (API, database, etc.) are in the data layer.
abstract class UserRepository {
  /// Gets a user by their ID.
  Future<Result<UserEntity>> getUserById(int id);

  /// Gets all users with optional pagination.
  Future<Result<List<UserEntity>>> getUsers({int page = 1, int limit = 20});

  /// Creates a new user.
  Future<Result<UserEntity>> createUser({
    required String name,
    required String email,
    String? phone,
  });

  /// Updates an existing user.
  Future<Result<UserEntity>> updateUser({
    required int id,
    String? name,
    String? email,
    String? phone,
  });

  /// Deletes a user by their ID.
  Future<Result<void>> deleteUser(int id);

  /// Searches users by query string.
  Future<Result<List<UserEntity>>> searchUsers(String query);

  /// Gets the currently logged in user.
  Future<Result<UserEntity>> getCurrentUser();

  /// Gets cached user from local storage.
  Future<Result<UserEntity?>> getCachedUser();

  /// Saves user to local cache.
  Future<Result<void>> cacheUser(UserEntity user);

  /// Clears user from local cache.
  Future<Result<void>> clearCachedUser();
}
