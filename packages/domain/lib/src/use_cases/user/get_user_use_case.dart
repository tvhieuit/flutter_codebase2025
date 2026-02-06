import 'package:app_core/app_core.dart';
import 'package:injectable/injectable.dart';

import '../../../domain.dart';

/// Use case for getting a user by ID.
@injectable
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

/// Use case for getting the current logged-in user from cache.
/// Note: Remote fetch requires an ID, so this primarily checks cache.
@injectable
class GetCurrentUserUseCase implements UseCase<UserEntity?> {
  final UserRepository _repository;

  GetCurrentUserUseCase(this._repository);

  @override
  Future<Result<UserEntity?>> call() async {
    return await _repository.getCachedUser();
  }
}
