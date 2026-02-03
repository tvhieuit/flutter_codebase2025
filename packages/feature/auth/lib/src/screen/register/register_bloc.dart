import 'package:app_core/app_core.dart';
import 'package:auto_route/auto_route.dart';
import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:app_widget/app_widget.dart';

import '../../navigation/auth_navigation.dart';
import '../../use_case/use_cases.dart';

part 'register_bloc.freezed.dart';

part 'register_event.dart';

part 'register_state.dart';

/// BLoC for managing register screen state
@injectable
class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final RegisterUseCase _registerUseCase;
  final StackRouter _router;
  final AppRoute _appRoute;
  final AppToast _toast;

  RegisterBloc(
    this._registerUseCase,
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
    emit(state.copyWith(isLoading: true, error: null, fieldError: null));

    try {
      final credentials = RegisterCredentials(
        name: event.name,
        email: event.email,
        password: event.password,
        confirmPassword: event.confirmPassword,
        phone: event.phone,
      );

      final result = await _registerUseCase(credentials);
      assert(result.isFailure, result.failureOrNull);
      final token = result.dataOrThrow;
      emit(
        state.copyWith(
          isLoading: false,
          isSuccess: true,
          token: token,
          error: null,
          fieldError: null,
        ),
      );
      _router.replaceAll([_appRoute.home]);
    } on Failure catch (e) {
      emit(state.copyWith(isLoading: false, error: e.message));
      _toast.show(e.message, type: AppToastType.error);
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: 'An unexpected error occurred'));
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
