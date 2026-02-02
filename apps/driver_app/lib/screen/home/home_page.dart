import 'package:auto_route/auto_route.dart';
import 'package:domain/domain.dart';
import 'package:feature_app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../app/auth_routes.dart';
import '../../l10n/app_localizations.dart';

@RoutePage()
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isOnline = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.homeTitle),
        backgroundColor: _isOnline ? Colors.green : Colors.grey,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => _openSettings(context),
          ),
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () {
              // TODO: Navigate to profile
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Online/Offline Toggle
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            color: _isOnline ? Colors.green.shade50 : Colors.grey.shade100,
            child: Column(
              children: [
                Text(
                  _isOnline ? 'You are Online' : 'You are Offline',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: _isOnline
                        ? Colors.green.shade700
                        : Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      _isOnline = !_isOnline;
                    });
                  },
                  icon: Icon(_isOnline ? Icons.pause : Icons.play_arrow),
                  label: Text(_isOnline ? l10n.goOffline : l10n.goOnline),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isOnline ? Colors.red : Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: _isOnline
                ? _buildOnlineContent(l10n)
                : _buildOfflineContent(l10n),
          ),
        ],
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

  Widget _buildOnlineContent(AppLocalizations l10n) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Today's Earnings Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.todayEarnings,
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '\$0.00',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Current Deliveries Section
          Text(
            l10n.currentDeliveries,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // Empty state
          Center(
            child: Column(
              children: [
                const SizedBox(height: 32),
                Icon(
                  Icons.inbox_outlined,
                  size: 80,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.noDeliveries,
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 8),
                const Text(
                  'New delivery requests will appear here',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOfflineContent(AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.wifi_off_outlined, size: 80, color: Colors.grey.shade400),
          const SizedBox(height: 24),
          Text(
            l10n.welcomeMessage,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Go online to start receiving delivery requests',
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            textAlign: TextAlign.center,
          ),
        ],
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
