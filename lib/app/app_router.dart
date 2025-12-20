import 'package:auto_route/auto_route.dart';

import 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends RootStackRouter {
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
