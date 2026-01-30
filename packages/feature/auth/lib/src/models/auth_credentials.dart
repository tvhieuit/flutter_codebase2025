import 'package:app_core/app_core.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_credentials.freezed.dart';

/// Login credentials
@paramsFreezed
sealed class LoginCredentials with _$LoginCredentials {
  const factory LoginCredentials({
    required String email,
    required String password,
  }) = _LoginCredentials;
}

/// Register credentials
@paramsFreezed
sealed class RegisterCredentials with _$RegisterCredentials {
  const factory RegisterCredentials({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
    String? phone,
  }) = _RegisterCredentials;
}
