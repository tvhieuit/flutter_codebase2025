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

part 'register_bloc.freezed.dart';

part 'register_event.dart';

part 'register_state.dart';

/// BLoC for managing register screen state
@injectable
class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthRepository _authRepository;
  final UserLocalRepository _userLocalRepository;
  final StackRouter _router;
  final AppRoute _appRoute;
  final AppToast _toast;

  RegisterBloc(
    this._authRepository,
    this._userLocalRepository,
    this._router,
    this._appRoute,
    this._toast,
  ) : super(RegisterState.initial()) {
    on(_onRegister);
    on(_onLogin);
    on(_onObscurePasswordToggle);
    on(_onObscureConfirmPasswordToggle);
  }

  /// Handles register event
  Future<void> _onRegister(RegisterEventSubmit event, emit) async {
    if (event.name.isEmpty) {
      emit(state.copyWith(error: 'Name is required', fieldError: 'name'));
      return;
    }

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

    try {
      final credentials = RegisterCredentials(
        name: event.name,
        email: event.email,
        password: event.password,
        confirmPassword: event.confirmPassword,
        phone: event.phone,
      );

      final result = await _authRepository.register(credentials);
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

  Future<void> _onLogin(_RegisterEventLogin event, emit) async {
    _router.maybePop();
  }

  Future<void> _onObscurePasswordToggle(
    _RegisterEventObscurePasswordToggle event,
    emit,
  ) async {
    emit(state.copyWith(obscurePassword: !state.obscurePassword));
  }

  Future<void> _onObscureConfirmPasswordToggle(
    _RegisterEventObscureConfirmPasswordToggle event,
    emit,
  ) async {
    emit(state.copyWith(obscureConfirmPassword: !state.obscureConfirmPassword));
  }
}
