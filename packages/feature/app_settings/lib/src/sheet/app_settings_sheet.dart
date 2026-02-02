import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/app_settings_bloc.dart';

/// Strings required to render the common settings UI.
///
/// This allows each app to localize the sheet using its own l10n.
class AppSettingsSheetStrings {
  final String title;

  final String themeTitle;
  final String themeSystem;
  final String themeLight;
  final String themeDark;

  final String languageTitle;
  final String languageSystem;
  final String languageEnglish;
  final String languageKorean;

  const AppSettingsSheetStrings({
    required this.title,
    required this.themeTitle,
    required this.themeSystem,
    required this.themeLight,
    required this.themeDark,
    required this.languageTitle,
    required this.languageSystem,
    required this.languageEnglish,
    required this.languageKorean,
  });
}

class AppSettingsSheet {
  const AppSettingsSheet._();

  static Future<void> show(
    BuildContext context, {
    required AppSettingsSheetStrings strings,
    bool showDragHandle = true,
  }) async {
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: showDragHandle,
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: BlocBuilder<AppSettingsBloc, AppSettingsState>(
              buildWhen: (previous, current) =>
                  previous.themeMode != current.themeMode ||
                  previous.locale != current.locale,
              builder: (context, state) {
                final selectedLanguageCode = state.locale?.languageCode;

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      strings.title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      strings.themeTitle,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    RadioListTile<ThemeMode>(
                      value: ThemeMode.system,
                      groupValue: state.themeMode,
                      title: Text(strings.themeSystem),
                      onChanged: (value) {
                        if (value == null) return;
                        context.read<AppSettingsBloc>().add(
                          AppSettingsEvent.themeModeChanged(themeMode: value),
                        );
                      },
                    ),
                    RadioListTile<ThemeMode>(
                      value: ThemeMode.light,
                      groupValue: state.themeMode,
                      title: Text(strings.themeLight),
                      onChanged: (value) {
                        if (value == null) return;
                        context.read<AppSettingsBloc>().add(
                          AppSettingsEvent.themeModeChanged(themeMode: value),
                        );
                      },
                    ),
                    RadioListTile<ThemeMode>(
                      value: ThemeMode.dark,
                      groupValue: state.themeMode,
                      title: Text(strings.themeDark),
                      onChanged: (value) {
                        if (value == null) return;
                        context.read<AppSettingsBloc>().add(
                          AppSettingsEvent.themeModeChanged(themeMode: value),
                        );
                      },
                    ),
                    const SizedBox(height: 8),
                    Text(
                      strings.languageTitle,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    RadioListTile<String?>(
                      value: null,
                      groupValue: selectedLanguageCode,
                      title: Text(strings.languageSystem),
                      onChanged: (_) => context.read<AppSettingsBloc>().add(
                        const AppSettingsEvent.localeChanged(locale: null),
                      ),
                    ),
                    RadioListTile<String?>(
                      value: 'en',
                      groupValue: selectedLanguageCode,
                      title: Text(strings.languageEnglish),
                      onChanged: (_) => context.read<AppSettingsBloc>().add(
                        const AppSettingsEvent.localeChanged(
                          locale: Locale('en'),
                        ),
                      ),
                    ),
                    RadioListTile<String?>(
                      value: 'ko',
                      groupValue: selectedLanguageCode,
                      title: Text(strings.languageKorean),
                      onChanged: (_) => context.read<AppSettingsBloc>().add(
                        const AppSettingsEvent.localeChanged(
                          locale: Locale('ko'),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}
