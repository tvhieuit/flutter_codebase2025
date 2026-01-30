import 'package:app_core/app_core.dart';
import 'package:auto_route/auto_route.dart';
import 'package:domain/domain.dart';
import 'package:feature_auth/auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'splash_bloc.freezed.dart';

part 'splash_event.dart';

part 'splash_state.dart';

/// BLoC for managing splash screen state and initialization
@injectable
class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final StackRouter _router;
  final AppRoute _appRoute;

  SplashBloc(
    this._router,
    this._appRoute,
  ) : super(SplashState.initial()) {
    on(_onStart);
    on(_onCheckAuth);
    on(_onNavigate);

    // Auto-start initialization when BLoC is created
    add(const SplashEvent.start());
  }

  /// Handles splash screen start event
  Future<void> _onStart(SplashEventStart event, emit) async {
    emit(state.copyWith(isLoading: true));

    // Simulate initialization delay
    await Future.delayed(const Duration(seconds: 2));

    emit(
      state.copyWith(
        isLoading: false,
        isInitialized: true,
      ),
    );

    // Automatically check auth after initialization
    add(const SplashEvent.checkAuth());
  }

  /// Handles authentication check event
  Future<void> _onCheckAuth(SplashEventCheckAuth event, emit) async {
    await Future.delayed(const Duration(milliseconds: 500));

    // Simulate auth check (replace with actual auth logic)
    final isAuthenticated = false;

    emit(
      state.copyWith(
        isAuthenticated: isAuthenticated,
      ),
    );

    // Navigate after auth check
    add(const SplashEvent.navigate());
  }

  /// Handles navigation event
  Future<void> _onNavigate(SplashEventNavigate event, emit) async {
    _router.replaceAll([_appRoute.login]);
  }
}
