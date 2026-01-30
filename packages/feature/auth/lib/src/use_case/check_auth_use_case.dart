import 'package:app_core/app_core.dart';
import 'package:domain/domain.dart';
import 'package:injectable/injectable.dart';

import '../repository/auth_repository.dart';

/// Use case for checking authentication status.
///
/// Checks if user has valid token stored locally.
@injectable
class CheckAuthUseCase implements UseCase<bool> {
  final AuthRepository _authRepository;
  final UserLocalRepository _userLocalRepository;

  CheckAuthUseCase(this._authRepository, this._userLocalRepository);

  @override
  Future<Result<bool>> call() async {
    // Check for stored token
    final tokenResult = await _userLocalRepository.getAccessToken();

    return tokenResult.when(
      success: (token) async {
        if (token == null || token.isEmpty) {
          return const Result.success(false);
        }

        // Optionally verify token with server
        return await _authRepository.isAuthenticated();
      },
      failure: (failure) => const Result.success(false),
    );
  }
}
