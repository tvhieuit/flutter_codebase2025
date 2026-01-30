import 'package:app_core/app_core.dart';
import 'package:domain/domain.dart';
import 'package:injectable/injectable.dart';

import '../repository/auth_repository.dart';

/// Use case for user logout.
///
/// Clears tokens and user data from local storage.
@injectable
class LogoutUseCase implements UseCase<void> {
  final AuthRepository _authRepository;
  final UserLocalRepository _userLocalRepository;

  LogoutUseCase(this._authRepository, this._userLocalRepository);

  @override
  Future<Result<void>> call() async {
    // Call API logout (optional, may fail if offline)
    await _authRepository.logout();

    // Always clear local data
    await _userLocalRepository.clearAllUserData();

    return const Result.success(null);
  }
}
