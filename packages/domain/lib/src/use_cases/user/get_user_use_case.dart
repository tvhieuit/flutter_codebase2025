import '../../entities/user_entity.dart';
import 'package:app_core/app_core.dart';
import '../../repositories/user_repository.dart';
import 'package:app_core/app_core.dart';
import '../base_use_case.dart';

/// Use case for getting a user by ID.
///
/// Example usage in BLoC:
/// ```dart
/// final result = await _getUserUseCase(userId);
/// result.when(
///   success: (user) => emit(state.copyWith(user: user)),
///   failure: (failure) => emit(state.copyWith(error: failure.message)),
/// );
/// ```
class GetUserUseCase implements UseCaseWithParams<UserEntity, int> {
  final UserRepository _repository;

  GetUserUseCase(this._repository);

  @override
  Future<Result<UserEntity>> call(int userId) async {
    // Validation
    if (userId <= 0) {
      return const Result.failure(
        Failure.validation(message: 'Invalid user ID', code: 'INVALID_USER_ID'),
      );
    }

    return await _repository.getUserById(userId);
  }
}

/// Use case for getting the current logged-in user.
class GetCurrentUserUseCase implements UseCase<UserEntity> {
  final UserRepository _repository;

  GetCurrentUserUseCase(this._repository);

  @override
  Future<Result<UserEntity>> call() async {
    // Try to get from cache first
    final cachedResult = await _repository.getCachedUser();

    return cachedResult.when(
      success: (cachedUser) async {
        if (cachedUser != null) {
          return Result.success(cachedUser);
        }
        // No cached user, fetch from remote
        final remoteResult = await _repository.getCurrentUser();

        // Cache the result if successful
        remoteResult.whenOrNull(success: (user) => _repository.cacheUser(user));

        return remoteResult;
      },
      failure: (failure) async {
        // Cache failed, try remote
        return await _repository.getCurrentUser();
      },
    );
  }
}
