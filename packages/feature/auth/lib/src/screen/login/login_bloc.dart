import 'package:app_core/app_core.dart';
import 'package:auto_route/auto_route.dart';
import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:app_widget/app_widget.dart';

import '../../models/auth_credentials.dart';
import '../../models/auth_token.dart';
import '../../navigation/auth_navigation.dart';
import '../../repository/auth_repository.dart';

part 'login_bloc.freezed.dart';

part 'login_event.dart';

part 'login_state.dart';

/// BLoC for managing login screen state
@injectable
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository _authRepository;
  final UserLocalRepository _userLocalRepository;
  final StackRouter _router;
  final AppRoute _appRoute;
  final AppToast _toast;

  LoginBloc(
    this._authRepository,
    this._userLocalRepository,
    this._router,
    this._appRoute,
    this._toast,
  ) : super(LoginState.initial()) {
    on(_onLogin);
    on(_onRegister);
    on(_onForgotPassword);
    on(_onObscurePasswordToggle);
  }

  /// Handles login event
  Future<void> _onLogin(LoginEventSubmit event, emit) async {
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

    try {
      final credentials = LoginCredentials(
        email: event.email,
        password: event.password,
      );
      final result = await _authRepository.login(credentials);
      assert(result.failure != null, result.failure);
      final data = result.data;
      assert(data == null, 'Data should be null');
      await _userLocalRepository.saveAccessToken(data!.accessToken);
      emit(state.copyWith(isLoading: false, isSuccess: true, token: data));
      _router.replaceAll([_appRoute.home]);
    } on Failure catch (e) {
      _toast.show(e.message, type: AppToastType.error);
    } catch (e) {
      _toast.show('An unexpected error occurred', type: AppToastType.error);
    }
  }

  Future<void> _onRegister(_LoginEventRegister event, emit) async {
    _router.push(_appRoute.register);
  }

  Future<void> _onForgotPassword(_LoginEventForgotPassword event, emit) async {
    // TODO: Add forgot password route to AppRoute
  }

  Future<void> _onObscurePasswordToggle(
    _LoginEventObscurePasswordToggle event,
    emit,
  ) async {
    emit(state.copyWith(obscurePassword: !state.obscurePassword));
  }
}
