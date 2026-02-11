import 'package:app_core/app_core.dart';
import 'package:injectable/injectable.dart';

import 'package:domain/domain.dart';
import '../base_use_case.dart';
import 'auth_input_validators.dart';

/// Use case for registering a new user.
@injectable
class RegisterUseCase implements UseCaseWithParams<AuthToken, RegisterCredentials> {
  final AuthRepository _repository;

  RegisterUseCase(this._repository);

  @override
  Future<Result<AuthToken>> call(RegisterCredentials credentials) async {
    final nameValidation = AuthInputValidators.validateName(credentials.name);
    if (nameValidation != null) return Result.failure(nameValidation);

    final emailValidation = AuthInputValidators.validateEmail(credentials.email);
    if (emailValidation != null) return Result.failure(emailValidation);

    final passwordValidation = AuthInputValidators.validatePassword(credentials.password);
    if (passwordValidation != null) return Result.failure(passwordValidation);

    final confirmValidation = AuthInputValidators.validateConfirmPassword(
      credentials.password,
      credentials.confirmPassword,
    );
    if (confirmValidation != null) return Result.failure(confirmValidation);

    return await _repository.register(credentials);
  }
}
