import 'package:auto_route/auto_route.dart';
import 'package:domain/domain.dart';
import 'package:feature_app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../app/auth_routes.dart';
import '../../l10n/app_localizations.dart';

@RoutePage()
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.homeTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => _openSettings(context),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.home_outlined, size: 80, color: Colors.blue),
            const SizedBox(height: 24),
            Text(
              l10n.welcomeMessage,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.homeDescription,
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openSettings(BuildContext context) async {
    final l10n = AppLocalizations.of(context);

    await AppSettingsSheet.show(
      context,
      strings: AppSettingsSheetStrings(
        title: l10n.settings,
        themeTitle: l10n.themeModeTitle,
        themeSystem: l10n.themeModeSystem,
        themeLight: l10n.themeModeLight,
        themeDark: l10n.themeModeDark,
        languageTitle: l10n.languageTitle,
        languageSystem: l10n.languageSystem,
        languageEnglish: l10n.languageEnglish,
        languageKorean: l10n.languageKorean,
      ),
    );
  }

  Future<void> _logout(BuildContext context) async {
    final userLocalRepo = GetIt.instance<UserLocalRepository>();
    await userLocalRepo.clearAccessToken();

    if (context.mounted) {
      context.router.replaceAll([const LoginRoute()]);
    }
  }
}
