import 'package:app_core/app_core.dart';
import 'package:injectable/injectable.dart';

import 'package:domain/domain.dart';
import '../base_use_case.dart';
import 'auth_input_validators.dart';

/// Use case for logging in with email and password.
@injectable
class LoginUseCase implements UseCaseWithParams<AuthToken, LoginCredentials> {
  final AuthRepository _repository;

  LoginUseCase(this._repository);

  @override
  Future<Result<AuthToken>> call(LoginCredentials credentials) async {
    final emailValidation = AuthInputValidators.validateEmail(credentials.email);
    if (emailValidation != null) return Result.failure(emailValidation);

    final passwordValidation = AuthInputValidators.validatePassword(credentials.password);
    if (passwordValidation != null) return Result.failure(passwordValidation);

    return await _repository.login(credentials);
  }
}
