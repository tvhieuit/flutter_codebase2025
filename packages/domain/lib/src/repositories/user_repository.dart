import 'package:app_core/app_core.dart';
import '../../domain.dart';

/// User repository interface.
///
/// This abstract interface defines the contract for user data access.
/// Implementation details (API, database, etc.) are in the data layer.
abstract class UserRepository {
  /// Gets a user by their ID.
  Future<Result<UserEntity>> getUserById(int id);

  /// Gets all users with optional pagination.
  Future<Result<List<UserEntity>>> getUsers({int? page, int? limit});

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
}
