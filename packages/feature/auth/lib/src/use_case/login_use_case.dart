import 'package:app_core/app_core.dart';
import 'package:domain/domain.dart'
    hide LoginUseCase, RegisterUseCase, LogoutUseCase, RefreshTokenUseCase, AuthInputValidators;
import 'package:injectable/injectable.dart';

import 'auth_input_validators.dart';

/// Use case for user login.
///
/// Validates credentials and performs login via repository.
@injectable
class LoginUseCase implements UseCaseWithParams<AuthToken, LoginCredentials> {
  final AuthRepository _authRepository;
  final UserLocalRepository _userLocalRepository;

  LoginUseCase(this._authRepository, this._userLocalRepository);

  @override
  Future<Result<AuthToken>> call(LoginCredentials credentials) async {
    // Validate email
    final emailError = AuthInputValidators.validateEmail(credentials.email);
    if (emailError != null) return Result.failure(emailError);

    // Validate password
    final passwordError = _validatePassword(credentials.password);
    if (passwordError != null) return Result.failure(passwordError);

    // Perform login
    final result = await _authRepository.login(credentials);

    // Save token on success
    result.whenOrNull(
      success: (token) async {
        await _userLocalRepository.saveAccessToken(token.accessToken);
      },
    );

    return result;
  }

  Failure? _validatePassword(String password) {
    if (password.isEmpty) {
      return Failure.required('Password');
    }

    if (password.length < 6) {
      return const Failure.validation(
        message: 'Password must be at least 6 characters',
        code: 'PASSWORD_TOO_SHORT',
        field: 'password',
      );
    }

    return null;
  }
}
