import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../models/auth_credentials.dart';
import '../models/auth_token.dart';
import '../repository/auth_repository.dart';

part 'register_bloc.freezed.dart';

part 'register_event.dart';

part 'register_state.dart';

/// BLoC for managing register screen state
@injectable
class RegisterBloc extends Bloc<RegisterEvent, RegisterState>
    with SafetyNetworkMixin {
  final AuthRepository _authRepository;
  final UserLocalRepository _userLocalRepository;

  RegisterBloc(this._authRepository, this._userLocalRepository)
    : super(RegisterState.initial()) {
    on(_onRegister);
    on(_onClearError);
  }

  /// Handles register event
  Future<void> _onRegister(RegisterEventSubmit event, emit) async {
    // Validate
    if (event.name.isEmpty) {
      emit(state.copyWith(error: 'Name is required', fieldError: 'name'));
      return;
    }

    if (event.email.isEmpty) {
      emit(state.copyWith(error: 'Email is required', fieldError: 'email'));
      return;
    }

    if (!_isValidEmail(event.email)) {
      emit(
        state.copyWith(
          error: 'Please enter a valid email',
          fieldError: 'email',
        ),
      );
      return;
    }

    if (event.password.isEmpty) {
      emit(
        state.copyWith(error: 'Password is required', fieldError: 'password'),
      );
      return;
    }

    if (event.password.length < 8) {
      emit(
        state.copyWith(
          error: 'Password must be at least 8 characters',
          fieldError: 'password',
        ),
      );
      return;
    }

    if (event.password != event.confirmPassword) {
      emit(
        state.copyWith(
          error: 'Passwords do not match',
          fieldError: 'confirmPassword',
        ),
      );
      return;
    }

    emit(state.copyWith(isLoading: true, error: null, fieldError: null));

    await safeNetworkCall(
      () async {
        final credentials = RegisterCredentials(
          name: event.name,
          email: event.email,
          password: event.password,
          confirmPassword: event.confirmPassword,
          phone: event.phone,
        );

        final result = await _authRepository.register(credentials);

        result.when(
          success: (token) async {
            await _userLocalRepository.saveAccessToken(token.accessToken);

            emit(
              state.copyWith(isLoading: false, isSuccess: true, token: token),
            );
          },
          failure: (failure) {
            final (message, field) = _mapFailureToMessage(failure);
            emit(
              state.copyWith(
                isLoading: false,
                error: message,
                fieldError: field,
              ),
            );
          },
        );
      },
      onError: (error) {
        emit(
          state.copyWith(
            isLoading: false,
            error: 'An unexpected error occurred',
          ),
        );
      },
    );
  }

  /// Handles clear error event
  Future<void> _onClearError(RegisterEventClearError event, emit) async {
    emit(state.copyWith(error: null, fieldError: null));
  }

  /// Validates email format
  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  /// Maps failure to user-friendly message
  (String, String?) _mapFailureToMessage(Failure failure) {
    return failure.when(
      network: (message, _) => (message, null),
      server: (message, _, __) => (message, null),
      cache: (message, _) => (message, null),
      validation: (message, _, field) => (message, field),
      auth: (message, _) => (message, null),
      unknown: (message, _, __) => (message, null),
    );
  }
}
