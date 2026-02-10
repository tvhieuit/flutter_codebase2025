import 'package:app_core/app_core.dart';
import 'package:injectable/injectable.dart';

import '../../repositories/local/user_local_repository.dart';
import '../../repositories/user_repository.dart';
import '../base_use_case.dart';

/// Use case for deleting a user.
@injectable
class DeleteUserUseCase implements UseCaseWithParams<void, int> {
  final UserRepository _repository;
  final UserLocalRepository _userLocalRepository;

  DeleteUserUseCase(this._repository, this._userLocalRepository);

  @override
  Future<Result<void>> call(int userId) async {
    if (userId <= 0) {
      return const Result.failure(
        Failure.validation(message: 'Invalid user ID', code: 'INVALID_USER_ID'),
      );
    }

    final deleteResult = await _repository.deleteUser(userId);

    // Clear from local cache if deletion successful
    deleteResult.whenOrNull(
      success: (_) => _userLocalRepository.clearCurrentUser(),
    );

    return deleteResult;
  }
}
