import 'package:app_core/app_core.dart';
import 'package:auto_route/auto_route.dart';
import 'package:feature_auth/auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'splash_bloc.freezed.dart';
part 'splash_event.dart';
part 'splash_state.dart';

@injectable
class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final UserLocalRepository _userLocalRepository;
  final StackRouter _router;
  final AppRoute _appRoute;

  SplashBloc(this._userLocalRepository, this._router, this._appRoute)
    : super(SplashState.initial()) {
    on(_onStarted);

    // Auto-start
    add(const SplashEvent.started());
  }

  Future<void> _onStarted(_Started event, emit) async {
    emit(state.copyWith(isLoading: true));

    // Simulate splash delay
    await Future.delayed(const Duration(seconds: 2));

    try {
      final tokenResult = await _userLocalRepository.getAccessToken();
      assert(tokenResult.failure == null, tokenResult.failure);
      final token = tokenResult.data;
      assert(token != null, 'Token should not be null');

      if (token != null && token.isNotEmpty) {
        emit(state.copyWith(isLoading: false));
        _router.replaceAll([_appRoute.home]);
      } else {
        emit(state.copyWith(isLoading: false));
        _router.replaceAll([_appRoute.login]);
      }
    } on Failure catch (_) {
      emit(state.copyWith(isLoading: false));
      _router.replaceAll([_appRoute.login]);
    } catch (_) {
      emit(state.copyWith(isLoading: false));
      _router.replaceAll([_appRoute.login]);
    }
  }
}
