import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'splash_bloc.freezed.dart';
part 'splash_event.dart';
part 'splash_state.dart';

@injectable
class SplashBloc extends Bloc<SplashEvent, SplashState>
    with SafetyNetworkMixin {
  final UserLocalRepository _userLocalRepository;

  SplashBloc(this._userLocalRepository) : super(SplashState.initial()) {
    on<SplashEvent>(_onEvent);

    // Auto-start
    add(const SplashEvent.started());
  }

  Future<void> _onEvent(SplashEvent event, Emitter<SplashState> emit) async {
    await event.when(started: () => _onStarted(emit));
  }

  Future<void> _onStarted(Emitter<SplashState> emit) async {
    emit(state.copyWith(isLoading: true));

    // Simulate splash delay
    await Future.delayed(const Duration(seconds: 2));

    await safeNetworkCall(
      () async {
        final tokenResult = await _userLocalRepository.getAccessToken();

        tokenResult.when(
          success: (token) {
            if (token != null && token.isNotEmpty) {
              emit(
                state.copyWith(
                  isLoading: false,
                  authStatus: AuthStatus.authenticated,
                ),
              );
            } else {
              emit(
                state.copyWith(
                  isLoading: false,
                  authStatus: AuthStatus.unauthenticated,
                ),
              );
            }
          },
          failure: (_) {
            emit(
              state.copyWith(
                isLoading: false,
                authStatus: AuthStatus.unauthenticated,
              ),
            );
          },
        );
      },
      onError: (error) {
        emit(
          state.copyWith(
            isLoading: false,
            authStatus: AuthStatus.unauthenticated,
          ),
        );
      },
    );
  }
}
