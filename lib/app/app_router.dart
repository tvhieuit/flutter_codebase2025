import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import 'app_custom_route.dart';
import 'app_router.gr.dart';
import 'auth_routes.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();
BuildContext get globalContext =>
    rootNavigatorKey.currentContext ?? (throw Exception('Navigator context is not available'));

@singleton
@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends RootStackRouter {
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

    // Auth routes (from auth package)
    AutoRoute(page: LoginRoute.page),
    AutoRoute(page: RegisterRoute.page),

    // User screen
    AutoRoute(
      page: UserRoute.page,
    ),

    // Dialog routes
    AppDialogRoute(
      page: PermissionDialogRoute.page,
      barrierDismissible: false,
    ),
  ];
}
