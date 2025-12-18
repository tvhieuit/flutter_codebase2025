import 'package:auto_route/auto_route.dart';

import '../../screen/splash/splash_page.dart';

@AutoRouterConfig()
class AppRouter extends $AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          page: SplashRoute.page,
          initial: true,
        ),
      ];
}

