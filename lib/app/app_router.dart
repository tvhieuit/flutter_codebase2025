import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import 'app_router.gr.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();
BuildContext get globalContext =>
    rootNavigatorKey.currentContext ?? (throw Exception('Navigator context is not available'));

@singleton
@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends $AppRouter {
  AppRouter() : super(navigatorKey: rootNavigatorKey);

  // Helper getters for accessing context globally

  BuildContext? get globalContextOrNull => rootNavigatorKey.currentContext;

  @override
  List<AutoRoute> get routes => [
    // Splash screen - initial route
    AutoRoute(
      page: SplashRoute.page,
      initial: true,
    ),

    // Add more routes here as you create them
    // Example:
    // AutoRoute(page: HomeRoute.page),
    // AutoRoute(page: LoginRoute.page),
  ];
}
