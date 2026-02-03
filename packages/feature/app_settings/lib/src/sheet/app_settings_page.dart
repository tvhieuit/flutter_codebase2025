import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/app_settings_bloc.dart';
import '../l10n/l10n.dart';

@RoutePage()
class AppSettingsPage extends StatelessWidget {
  const AppSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.settingsL10n;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: BlocBuilder<AppSettingsBloc, AppSettingsState>(
          buildWhen: (previous, current) =>
              previous.themeMode != current.themeMode || previous.locale != current.locale,
          builder: (context, state) {
            final selectedLanguageCode = state.locale?.languageCode;

            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.settingsTitle,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                Text(
                  l10n.themeTitle,
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
                        title: Text(l10n.themeSystem),
                      ),
                      RadioListTile<ThemeMode>(
                        value: ThemeMode.light,
                        title: Text(l10n.themeLight),
                      ),
                      RadioListTile<ThemeMode>(
                        value: ThemeMode.dark,
                        title: Text(l10n.themeDark),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.languageTitle,
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
                        title: Text(l10n.languageSystem),
                      ),
                      RadioListTile<String?>(
                        value: 'en',
                        title: Text(l10n.languageEnglish),
                      ),
                      RadioListTile<String?>(
                        value: 'ko',
                        title: Text(l10n.languageKorean),
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
