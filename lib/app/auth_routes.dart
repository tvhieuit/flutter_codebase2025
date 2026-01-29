import 'package:feature_auth/auth.dart';
import 'package:auto_route/auto_route.dart';

/// Route definition for LoginPage from auth package
class LoginRoute extends PageRouteInfo<void> {
  const LoginRoute({List<PageRouteInfo>? children}) : super(LoginRoute.name, initialChildren: children);

  static const String name = 'LoginRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const WrappedRoute(child: LoginPage());
    },
  );
}

/// Route definition for RegisterPage from auth package
class RegisterRoute extends PageRouteInfo<void> {
  const RegisterRoute({List<PageRouteInfo>? children}) : super(RegisterRoute.name, initialChildren: children);

  static const String name = 'RegisterRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const WrappedRoute(child: RegisterPage());
    },
  );
}
