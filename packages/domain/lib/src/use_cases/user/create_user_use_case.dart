import 'package:app_core/app_core.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../entities/user_entity.dart';
import '../../repositories/user_repository.dart';
import '../base_use_case.dart';

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
class CreateUserUseCase
    implements UseCaseWithParams<UserEntity, CreateUserParams> {
  final UserRepository _repository;

  CreateUserUseCase(this._repository);

  @override
  Future<Result<UserEntity>> call(CreateUserParams params) async {
    // Validate name
    final nameValidation = _validateName(params.name);
    if (nameValidation != null) return Result.failure(nameValidation);

    // Validate email
    final emailValidation = _validateEmail(params.email);
    if (emailValidation != null) return Result.failure(emailValidation);

    // Validate phone (if provided)
    if (params.phone != null) {
      final phoneValidation = _validatePhone(params.phone!);
      if (phoneValidation != null) return Result.failure(phoneValidation);
    }

    final result = await _repository.createUser(
      name: params.name.trim(),
      email: params.email.trim().toLowerCase(),
      phone: params.phone?.trim(),
    );
    return result;
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

    // Simple email regex validation
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(trimmedEmail)) {
      return Failure.invalidEmail();
    }

    return null;
  }

  Failure? _validatePhone(String phone) {
    final trimmedPhone = phone.trim();

    if (trimmedPhone.isEmpty) {
      return null; // Phone is optional, empty is valid
    }

    // Remove common formatting characters for validation
    final digitsOnly = trimmedPhone.replaceAll(RegExp(r'[\s\-\(\)\+]'), '');

    if (digitsOnly.length < 10 || digitsOnly.length > 15) {
      return const Failure.validation(
        message: 'Phone number must be 10-15 digits',
        code: 'INVALID_PHONE',
        field: 'phone',
      );
    }

    if (!RegExp(r'^\d+$').hasMatch(digitsOnly)) {
      return const Failure.validation(
        message: 'Phone number must contain only digits',
        code: 'INVALID_PHONE_FORMAT',
        field: 'phone',
      );
    }

    return null;
  }
}
