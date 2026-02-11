import 'package:app_core/app_core.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import 'package:domain/domain.dart';
import '../base_use_case.dart';
import 'user_input_validators.dart';

part 'update_user_use_case.freezed.dart';

/// Parameters for updating a user.
@paramsFreezed
sealed class UpdateUserParams with _$UpdateUserParams {
  const UpdateUserParams._();

  const factory UpdateUserParams({
    required int id,
    String? name,
    String? email,
    String? phone,
  }) = _UpdateUserParams;

  /// Returns true if at least one field is being updated
  bool get hasUpdates => name != null || email != null || phone != null;
}

/// Use case for updating an existing user.
@injectable
class UpdateUserUseCase implements UseCaseWithParams<UserEntity, UpdateUserParams> {
  final UserRepository _repository;

  UpdateUserUseCase(this._repository);

  @override
  Future<Result<UserEntity>> call(UpdateUserParams params) async {
    // Validate ID
    if (params.id <= 0) {
      return const Result.failure(
        Failure.validation(message: 'Invalid user ID', code: 'INVALID_USER_ID'),
      );
    }

    // Check if there are any updates
    if (!params.hasUpdates) {
      return const Result.failure(
        Failure.validation(message: 'No fields to update', code: 'NO_UPDATES'),
      );
    }

    // Validate name if provided
    if (params.name != null) {
      final nameValidation = UserInputValidators.validateName(params.name!);
      if (nameValidation != null) return Result.failure(nameValidation);
    }

    // Validate email if provided
    if (params.email != null) {
      final emailValidation = UserInputValidators.validateEmail(params.email!);
      if (emailValidation != null) return Result.failure(emailValidation);
    }

    // Validate phone if provided
    if (params.phone != null) {
      final phoneValidation = UserInputValidators.validatePhone(params.phone!);
      if (phoneValidation != null) return Result.failure(phoneValidation);
    }

    final result = await _repository.updateUser(
      id: params.id,
      name: params.name?.trim(),
      email: params.email?.trim().toLowerCase(),
      phone: params.phone?.trim(),
    );
    return result;
  }
}
