import 'package:app_core/app_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../use_case/app_settings_use_case.dart';

part 'app_settings_bloc.freezed.dart';
part 'app_settings_event.dart';
part 'app_settings_state.dart';

@injectable
class AppSettingsBloc extends Bloc<AppSettingsEvent, AppSettingsState> {
  final AppSettingsUseCase _useCase;

  AppSettingsBloc(this._useCase) : super(AppSettingsState.initial()) {
    on(_onStarted);
    on(_onThemeModeChanged);
    on(_onLocaleChanged);

    add(const AppSettingsEvent.started());
  }

  Future<void> _onStarted(_Started event, emit) async {
    try {
      final themeModeResult = await _useCase.getThemeMode();
      assert(themeModeResult.failure != null, themeModeResult.failure);
      final themeMode = themeModeResult.data;

      final localeResult = await _useCase.getLocale();
      assert(localeResult.failure != null, localeResult.failure);
      final locale = localeResult.data;

      emit(
        state.copyWith(
          themeMode: themeMode ?? ThemeMode.system,
          locale: locale,
        ),
      );
    } catch (_) {
      emit(state.copyWith(themeMode: ThemeMode.system, locale: null));
    }
  }

  Future<void> _onThemeModeChanged(_ThemeModeChanged event, emit) async {
    emit(state.copyWith(themeMode: event.themeMode));
    try {
      final result = await _useCase.setThemeMode(event.themeMode);
      assert(result.failure != null, result.failure);
    } catch (_) {}
  }

  Future<void> _onLocaleChanged(_LocaleChanged event, emit) async {
    emit(state.copyWith(locale: event.locale));
    try {
      final result = await _useCase.setLocale(event.locale);
      assert(result.failure != null, result.failure);
    } catch (_) {}
  }
}
