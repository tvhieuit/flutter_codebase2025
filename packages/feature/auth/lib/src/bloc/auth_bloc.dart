import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../models/auth_credentials.dart';
import '../use_case/check_auth_use_case.dart';
import '../use_case/login_use_case.dart';
import '../use_case/logout_use_case.dart';
import '../use_case/register_use_case.dart';
import 'auth_event.dart';
import 'auth_state.dart';

/// Authentication BLoC
///
/// Handles all authentication related events and states.
@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final LogoutUseCase _logoutUseCase;
  final CheckAuthUseCase _checkAuthUseCase;
  final UserLocalRepository _userLocalRepository;

  AuthBloc(
    this._loginUseCase,
    this._registerUseCase,
    this._logoutUseCase,
    this._checkAuthUseCase,
    this._userLocalRepository,
  ) : super(AuthState.initial()) {
    on(_onEvent);

    // Auto check auth on creation
    add(const AuthEvent.checkAuth());
  }

  /// Handles all events using pattern matching
  Future<void> _onEvent(AuthEvent event, Emitter<AuthState> emit) async {
    await event.map(
      checkAuth: (_) => _onCheckAuth(emit),
      login: (e) => _onLogin(e.email, e.password, emit),
      register: (e) => _onRegister(
        e.name,
        e.email,
        e.password,
        e.confirmPassword,
        e.phone,
        emit,
      ),
      logout: (_) => _onLogout(emit),
      clearError: (_) => _onClearError(emit),
    );
  }

  /// Handles check auth event
  Future<void> _onCheckAuth(Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.checking));

    final result = await _checkAuthUseCase();

    result.when(
      success: (isAuthenticated) async {
        if (isAuthenticated) {
          // Load cached user
          final userResult = await _userLocalRepository.getCurrentUser();
          final user = userResult.dataOrNull;

          emit(state.copyWith(status: AuthStatus.authenticated, user: user));
        } else {
          emit(state.copyWith(status: AuthStatus.unauthenticated));
        }
      },
      failure: (_) {
        emit(state.copyWith(status: AuthStatus.unauthenticated));
      },
    );
  }

  /// Handles login event
  Future<void> _onLogin(
    String email,
    String password,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null, fieldError: null));

    final credentials = LoginCredentials(
      email: email.trim(),
      password: password,
    );

    final result = await _loginUseCase(credentials);

    result.when(
      success: (token) {
        emit(
          state.copyWith(
            status: AuthStatus.authenticated,
            accessToken: token.accessToken,
            isLoading: false,
          ),
        );
      },
      failure: (failure) {
        emit(
          state.copyWith(
            isLoading: false,
            error: failure.message,
            fieldError: failure.whenOrNull(validation: (_, __, field) => field),
          ),
        );
      },
    );
  }

  /// Handles register event
  Future<void> _onRegister(
    String name,
    String email,
    String password,
    String confirmPassword,
    String? phone,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null, fieldError: null));

    final credentials = RegisterCredentials(
      name: name.trim(),
      email: email.trim(),
      password: password,
      confirmPassword: confirmPassword,
      phone: phone?.trim(),
    );

    final result = await _registerUseCase(credentials);

    result.when(
      success: (token) {
        emit(
          state.copyWith(
            status: AuthStatus.authenticated,
            accessToken: token.accessToken,
            isLoading: false,
          ),
        );
      },
      failure: (failure) {
        emit(
          state.copyWith(
            isLoading: false,
            error: failure.message,
            fieldError: failure.whenOrNull(validation: (_, __, field) => field),
          ),
        );
      },
    );
  }

  /// Handles logout event
  Future<void> _onLogout(Emitter<AuthState> emit) async {
    emit(state.copyWith(isLoading: true));

    await _logoutUseCase();

    emit(AuthState.initial().copyWith(status: AuthStatus.unauthenticated));
  }

  /// Handles clear error event
  Future<void> _onClearError(Emitter<AuthState> emit) async {
    emit(state.copyWith(error: null, fieldError: null));
  }
}
