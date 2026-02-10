import 'package:app_core/app_core.dart';
import 'package:domain/domain.dart'
    hide LoginUseCase, RegisterUseCase, LogoutUseCase, RefreshTokenUseCase, AuthInputValidators;
import 'package:injectable/injectable.dart';

import 'auth_input_validators.dart';

/// Use case for user registration.
///
/// Validates all fields and performs registration via repository.
@injectable
class RegisterUseCase implements UseCaseWithParams<AuthToken, RegisterCredentials> {
  final AuthRepository _authRepository;
  final UserLocalRepository _userLocalRepository;

  RegisterUseCase(this._authRepository, this._userLocalRepository);

  @override
  Future<Result<AuthToken>> call(RegisterCredentials credentials) async {
    // Validate name
    final nameError = _validateName(credentials.name);
    if (nameError != null) return Result.failure(nameError);

    // Validate email
    final emailError = AuthInputValidators.validateEmail(credentials.email);
    if (emailError != null) return Result.failure(emailError);

    // Validate password
    final passwordError = _validatePassword(credentials.password);
    if (passwordError != null) return Result.failure(passwordError);

    // Validate confirm password
    if (credentials.password != credentials.confirmPassword) {
      return const Result.failure(
        Failure.validation(
          message: 'Passwords do not match',
          code: 'PASSWORD_MISMATCH',
          field: 'confirmPassword',
        ),
      );
    }

    // Validate phone (optional)
    if (credentials.phone != null && credentials.phone!.isNotEmpty) {
      final phoneError = _validatePhone(credentials.phone!);
      if (phoneError != null) return Result.failure(phoneError);
    }

    // Perform registration
    final result = await _authRepository.register(credentials);

    // Save token on success
    result.whenOrNull(
      success: (token) async {
        await _userLocalRepository.saveAccessToken(token.accessToken);
      },
    );

    return result;
  }

  Failure? _validateName(String name) {
    final trimmed = name.trim();

    if (trimmed.isEmpty) {
      return Failure.required('Name');
    }

    if (trimmed.length < 2) {
      return const Failure.validation(
        message: 'Name must be at least 2 characters',
        code: 'NAME_TOO_SHORT',
        field: 'name',
      );
    }

    if (trimmed.length > 100) {
      return const Failure.validation(
        message: 'Name must be at most 100 characters',
        code: 'NAME_TOO_LONG',
        field: 'name',
      );
    }

    return null;
  }

  Failure? _validatePassword(String password) {
    if (password.isEmpty) {
      return Failure.required('Password');
    }

    if (password.length < 8) {
      return const Failure.validation(
        message: 'Password must be at least 8 characters',
        code: 'PASSWORD_TOO_SHORT',
        field: 'password',
      );
    }

    // Check for at least one uppercase
    if (!password.contains(RegExp(r'[A-Z]'))) {
      return const Failure.validation(
        message: 'Password must contain at least one uppercase letter',
        code: 'PASSWORD_NO_UPPERCASE',
        field: 'password',
      );
    }

    // Check for at least one lowercase
    if (!password.contains(RegExp(r'[a-z]'))) {
      return const Failure.validation(
        message: 'Password must contain at least one lowercase letter',
        code: 'PASSWORD_NO_LOWERCASE',
        field: 'password',
      );
    }

    // Check for at least one digit
    if (!password.contains(RegExp(r'[0-9]'))) {
      return const Failure.validation(
        message: 'Password must contain at least one number',
        code: 'PASSWORD_NO_NUMBER',
        field: 'password',
      );
    }

    return null;
  }

  Failure? _validatePhone(String phone) {
    final digitsOnly = phone.replaceAll(RegExp(r'[\s\-\(\)\+]'), '');

    if (digitsOnly.length < 10 || digitsOnly.length > 15) {
      return const Failure.validation(
        message: 'Phone number must be 10-15 digits',
        code: 'INVALID_PHONE',
        field: 'phone',
      );
    }

    return null;
  }
}
