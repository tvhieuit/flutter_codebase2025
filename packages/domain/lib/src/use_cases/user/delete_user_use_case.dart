import '../../failures/failure.dart';
import '../../repositories/user_repository.dart';
import '../../result/result.dart';
import '../base_use_case.dart';

/// Use case for deleting a user.
class DeleteUserUseCase implements UseCaseWithParams<void, int> {
  final UserRepository _repository;

  DeleteUserUseCase(this._repository);

  @override
  Future<Result<void>> call(int userId) async {
    // Validation
    if (userId <= 0) {
      return const Result.failure(
        Failure.validation(message: 'Invalid user ID', code: 'INVALID_USER_ID'),
      );
    }

    // First, verify the user exists
    final userResult = await _repository.getUserById(userId);

    return userResult.when(
      success: (user) async {
        // User exists, proceed with deletion
        final deleteResult = await _repository.deleteUser(userId);

        // Also clear from cache if deletion successful
        deleteResult.whenOrNull(success: (_) => _repository.clearCachedUser());

        return deleteResult;
      },
      failure: (failure) => Result.failure(failure),
    );
  }
}
