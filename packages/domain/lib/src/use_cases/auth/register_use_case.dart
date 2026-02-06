import 'package:app_core/app_core.dart';
import 'package:injectable/injectable.dart';

import '../../../domain.dart';

/// Use case for registering a new user.
@injectable
class RegisterUseCase implements UseCaseWithParams<AuthToken, RegisterCredentials> {
  final AuthRepository _repository;

  RegisterUseCase(this._repository);

  @override
  Future<Result<AuthToken>> call(RegisterCredentials credentials) async {
    // Validate name
    final nameValidation = AuthInputValidators.validateName(credentials.name);
    if (nameValidation != null) return Result.failure(nameValidation);

    // Validate email
    final emailValidation = AuthInputValidators.validateEmail(credentials.email);
    if (emailValidation != null) return Result.failure(emailValidation);

    // Validate password
    final passwordValidation = AuthInputValidators.validatePassword(credentials.password);
    if (passwordValidation != null) return Result.failure(passwordValidation);

    // Validate confirm password
    final confirmValidation = AuthInputValidators.validateConfirmPassword(
      credentials.password,
      credentials.confirmPassword,
    );
    if (confirmValidation != null) return Result.failure(confirmValidation);

    return await _repository.register(credentials);
  }
}
