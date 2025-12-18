import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../app_mixin/safety_network_mixin.dart';
import '../../use_case/auth_use_case.dart';
import 'splash_event.dart';
import 'splash_state.dart';

@injectable
class SplashBloc extends Bloc<SplashEvent, SplashState>
    with SafetyNetworkMixin {
  final AuthUseCase _authUseCase;

  SplashBloc(this._authUseCase) : super(SplashState.initial()) {
    on<SplashEventStart>(_onStart);
  }

  Future<void> _onStart(
    SplashEventStart event,
    Emitter<SplashState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    await safeNetworkCall(
      call: () async {
        await Future.delayed(const Duration(seconds: 2));
        final user = await _authUseCase.getCurrentUser();

        emit(
          state.copyWith(
            isLoading: false,
            isInitialized: true,
          ),
        );
      },
      onError: (error) {
        emit(
          state.copyWith(
            isLoading: false,
            isInitialized: true,
            error: error.toString(),
          ),
        );
      },
    );
  }
}

