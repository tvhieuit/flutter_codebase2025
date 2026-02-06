import 'package:app_core/app_core.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../entities/user_entity.dart';
import '../../repositories/user_repository.dart';
import '../base_use_case.dart';
import 'user_input_validators.dart';

part 'create_user_use_case.freezed.dart';

/// Parameters for creating a new user.
@paramsFreezed
sealed class CreateUserParams with _$CreateUserParams {
  const factory CreateUserParams({
    required String name,
    required String email,
    String? phone,
  }) = _CreateUserParams;
}

/// Use case for creating a new user.
///
/// Includes comprehensive validation before creating.
@injectable
class CreateUserUseCase implements UseCaseWithParams<UserEntity, CreateUserParams> {
  final UserRepository _repository;

  CreateUserUseCase(this._repository);

  @override
  Future<Result<UserEntity>> call(CreateUserParams params) async {
    // Validate name
    final nameValidation = UserInputValidators.validateName(params.name);
    if (nameValidation != null) return Result.failure(nameValidation);

    // Validate email
    final emailValidation = UserInputValidators.validateEmail(params.email);
    if (emailValidation != null) return Result.failure(emailValidation);

    // Validate phone (if provided)
    if (params.phone != null) {
      final phoneValidation = UserInputValidators.validatePhone(params.phone!);
      if (phoneValidation != null) return Result.failure(phoneValidation);
    }

    final result = await _repository.createUser(
      name: params.name.trim(),
      email: params.email.trim().toLowerCase(),
      phone: params.phone?.trim(),
    );
    return result;
  }
}
