import 'package:app_core/app_core.dart';
import 'package:injectable/injectable.dart';

import 'package:domain/domain.dart';
import '../base_use_case.dart';

/// Use case for logging out the current user.
///
/// Clears tokens and user data from both remote and local storage.
@injectable
class LogoutUseCase implements UseCase<void> {
  final AuthRepository _authRepository;
  final UserLocalRepository _userLocalRepo;

  LogoutUseCase(this._authRepository, this._userLocalRepo);

  @override
  Future<Result<void>> call() async {
    // Logout from server (clear server session)
    await _authRepository.logout();

    // Clear all local user data
    await _userLocalRepo.clearAllUserData();

    return const Result.success(null);
  }
}
