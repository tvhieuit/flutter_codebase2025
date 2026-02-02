import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/app_settings_bloc.dart';

/// Strings required to render the common settings UI.
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

@RoutePage()
class AppSettingsPage extends StatelessWidget {
  final AppSettingsSheetStrings strings;

  const AppSettingsPage({super.key, required this.strings});

  @override
  Widget build(BuildContext context) {
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
                RadioGroup<ThemeMode>(
                  groupValue: state.themeMode,
                  onChanged: (value) {
                    if (value == null) return;
                    context.read<AppSettingsBloc>().add(
                      AppSettingsEvent.themeModeChanged(themeMode: value),
                    );
                  },
                  child: Column(
                    children: [
                      RadioListTile<ThemeMode>(
                        value: ThemeMode.system,
                        title: Text(strings.themeSystem),
                      ),
                      RadioListTile<ThemeMode>(
                        value: ThemeMode.light,
                        title: Text(strings.themeLight),
                      ),
                      RadioListTile<ThemeMode>(
                        value: ThemeMode.dark,
                        title: Text(strings.themeDark),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  strings.languageTitle,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                RadioGroup<String?>(
                  groupValue: selectedLanguageCode,
                  onChanged: (value) => context.read<AppSettingsBloc>().add(
                    AppSettingsEvent.localeChanged(
                      locale: value != null ? Locale(value) : null,
                    ),
                  ),
                  child: Column(
                    children: [
                      RadioListTile<String?>(
                        value: null,
                        title: Text(strings.languageSystem),
                      ),
                      RadioListTile<String?>(
                        value: 'en',
                        title: Text(strings.languageEnglish),
                      ),
                      RadioListTile<String?>(
                        value: 'ko',
                        title: Text(strings.languageKorean),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
              ],
            );
          },
        ),
      ),
    );
  }
}
