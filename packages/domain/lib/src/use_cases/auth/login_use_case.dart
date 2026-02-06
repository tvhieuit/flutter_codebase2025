import 'package:app_core/app_core.dart';
import 'package:injectable/injectable.dart';

import '../../../domain.dart';

/// Use case for logging in with email and password.
@injectable
class LoginUseCase implements UseCaseWithParams<AuthToken, LoginCredentials> {
  final AuthRepository _repository;

  LoginUseCase(this._repository);

  @override
  Future<Result<AuthToken>> call(LoginCredentials credentials) async {
    // Validate email
    final emailValidation = AuthInputValidators.validateEmail(credentials.email);
    if (emailValidation != null) return Result.failure(emailValidation);

    // Validate password
    final passwordValidation = AuthInputValidators.validatePassword(credentials.password);
    if (passwordValidation != null) return Result.failure(passwordValidation);

    return await _repository.login(credentials);
  }
}
