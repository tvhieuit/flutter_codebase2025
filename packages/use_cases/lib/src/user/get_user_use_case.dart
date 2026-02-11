import 'package:app_core/app_core.dart';
import 'package:injectable/injectable.dart';

import 'package:domain/domain.dart';
import '../base_use_case.dart';

/// Use case for getting a user by ID.
@injectable
class GetUserUseCase implements UseCaseWithParams<UserEntity, int> {
  final UserRepository _repository;

  GetUserUseCase(this._repository);

  @override
  Future<Result<UserEntity>> call(int userId) async {
    if (userId <= 0) {
      return const Result.failure(
        Failure.validation(message: 'Invalid user ID', code: 'INVALID_USER_ID'),
      );
    }

    return await _repository.getUserById(userId);
  }
}
