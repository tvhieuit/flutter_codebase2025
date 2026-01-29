import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../models/auth_credentials.dart';
import '../models/auth_token.dart';
import '../repository/auth_repository.dart';

part 'login_bloc.freezed.dart';

part 'login_event.dart';

part 'login_state.dart';

/// BLoC for managing login screen state
@injectable
class LoginBloc extends Bloc<LoginEvent, LoginState> with SafetyNetworkMixin {
  final AuthRepository _authRepository;
  final UserLocalRepository _userLocalRepository;

  LoginBloc(this._authRepository, this._userLocalRepository)
    : super(LoginState.initial()) {
    on(_onLogin);
    on(_onClearError);
  }

  /// Handles login event
  Future<void> _onLogin(LoginEventSubmit event, emit) async {
    // Validate
    if (event.email.isEmpty) {
      emit(state.copyWith(error: 'Email is required', fieldError: 'email'));
      return;
    }

    if (event.password.isEmpty) {
      emit(
        state.copyWith(error: 'Password is required', fieldError: 'password'),
      );
      return;
    }

    emit(state.copyWith(isLoading: true, error: null, fieldError: null));

    await safeNetworkCall(
      () async {
        final credentials = LoginCredentials(
          email: event.email,
          password: event.password,
        );

        final result = await _authRepository.login(credentials);

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
  Future<void> _onClearError(LoginEventClearError event, emit) async {
    emit(state.copyWith(error: null, fieldError: null));
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
