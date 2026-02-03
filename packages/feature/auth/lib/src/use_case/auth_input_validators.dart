import 'package:app_core/app_core.dart';

class AuthInputValidators {
  AuthInputValidators._();

  static Failure? validateEmail(String email) {
    final trimmed = email.trim();

    if (trimmed.isEmpty) {
      return Failure.required('Email');
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(trimmed.toLowerCase())) {
      return Failure.invalidEmail();
    }

    return null;
  }
}
