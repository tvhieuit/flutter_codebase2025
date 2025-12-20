import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../app_mixin/safety_network_mixin.dart';

part 'splash_event.dart';
part 'splash_state.dart';
part 'splash_bloc.freezed.dart';

/// BLoC for managing splash screen state and initialization
@injectable
class SplashBloc extends Bloc<SplashEvent, SplashState> with SafetyNetworkMixin {
  SplashBloc() : super(SplashState.initial()) {
    on(_onStart);
    on(_onCheckAuth);
    on(_onNavigate);

    // Auto-start initialization when BLoC is created
    add(const SplashEvent.start());
  }

  /// Handles splash screen start event
  /// Initialize app, check dependencies, etc.
  Future<void> _onStart(
    SplashEventStart event,
    emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));

    // Simulate initialization delay
    await Future.delayed(const Duration(seconds: 2));

    // Here you can add:
    // - Database initialization
    // - API configuration
    // - Cache setup
    // - Feature flags
    // - etc.

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
  Future<void> _onCheckAuth(
    SplashEventCheckAuth event,
    emit,
  ) async {
    // Here you would check:
    // - Local storage for auth token
    // - Validate token with API
    // - Check user session
    // For now, we'll simulate it

    await Future.delayed(const Duration(milliseconds: 500));

    // Simulate auth check (replace with actual auth logic)
    final isAuthenticated = false; // await _authRepository.isAuthenticated();

    emit(
      state.copyWith(
        isAuthenticated: isAuthenticated,
      ),
    );

    // Navigate after auth check
    add(const SplashEvent.navigate());
  }

  /// Handles navigation event
  /// This will be handled in the UI to trigger navigation
  Future<void> _onNavigate(
    SplashEventNavigate event,
    emit,
  ) async {
    // State is already set, UI will react to navigate
    // based on isAuthenticated flag
  }
}
