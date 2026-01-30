import 'package:app_core/app_core.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../entities/user_entity.dart';
import 'package:app_core/app_core.dart';
import '../../repositories/user_repository.dart';
import 'package:app_core/app_core.dart';
import '../base_use_case.dart';

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
class UpdateUserUseCase
    implements UseCaseWithParams<UserEntity, UpdateUserParams> {
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
      final nameValidation = _validateName(params.name!);
      if (nameValidation != null) return Result.failure(nameValidation);
    }

    // Validate email if provided
    if (params.email != null) {
      final emailValidation = _validateEmail(params.email!);
      if (emailValidation != null) return Result.failure(emailValidation);
    }

    return await _repository.updateUser(
      id: params.id,
      name: params.name?.trim(),
      email: params.email?.trim().toLowerCase(),
      phone: params.phone?.trim(),
    );
  }

  Failure? _validateName(String name) {
    final trimmedName = name.trim();

    if (trimmedName.isEmpty) {
      return Failure.required('Name');
    }

    if (trimmedName.length < 2) {
      return const Failure.validation(
        message: 'Name must be at least 2 characters',
        code: 'NAME_TOO_SHORT',
        field: 'name',
      );
    }

    if (trimmedName.length > 100) {
      return const Failure.validation(
        message: 'Name must be at most 100 characters',
        code: 'NAME_TOO_LONG',
        field: 'name',
      );
    }

    return null;
  }

  Failure? _validateEmail(String email) {
    final trimmedEmail = email.trim().toLowerCase();

    if (trimmedEmail.isEmpty) {
      return Failure.required('Email');
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(trimmedEmail)) {
      return Failure.invalidEmail();
    }

    return null;
  }
}
