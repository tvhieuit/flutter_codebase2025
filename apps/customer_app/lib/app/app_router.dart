import 'package:auto_route/auto_route.dart';
import 'package:injectable/injectable.dart';

import '../screen/home/home_page.dart';
import '../screen/splash/splash_page.dart';
import 'auth_routes.dart';

part 'app_router.gr.dart';

@singleton
@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: SplashRoute.page, initial: true),
    AutoRoute(page: HomeRoute.page),
    // Auth routes from feature_auth
    AutoRoute(page: LoginRoute.page),
    AutoRoute(page: RegisterRoute.page),
  ];
}
