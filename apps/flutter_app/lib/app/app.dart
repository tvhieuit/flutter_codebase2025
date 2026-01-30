import 'package:feature_auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/di/injection.dart';
import 'package:get_it/get_it.dart';

import '../l10n/app_localization.dart';
import 'app_router.dart';

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final _appRouter = getIt<AppRouter>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context).appName,
      scaffoldMessengerKey: GetIt.instance(),
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const {
        ...AppLocalizations.localizationsDelegates,
        AuthLocalizations.delegate,
      },
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      routerConfig: _appRouter.config(),
    );
  }
}
