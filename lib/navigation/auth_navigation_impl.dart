import 'package:feature_auth/auth.dart';
import 'package:injectable/injectable.dart';

import '../app/app_router.dart';
import '../app/app_router.gr.dart';
import '../app/auth_routes.dart';

/// Implementation of AuthNavigation using auto_route.
@LazySingleton(as: AuthNavigation)
class AuthNavigationImpl implements AuthNavigation {
  final AppRouter _router;

  AuthNavigationImpl(this._router);

  @override
  void goToRegister() {
    _router.push(const RegisterRoute());
  }

  @override
  void goToLogin() {
    _router.push(const LoginRoute());
  }

  @override
  void goToHome() {
    // Replace with your home route
    // _router.replace(const HomeRoute());

    // For now, navigate to user screen as placeholder
    _router.replaceAll([const UserRoute()]);
  }

  @override
  void goToForgotPassword() {
    // Add forgot password route when implemented
    // _router.push(const ForgotPasswordRoute());
  }

  @override
  void goBack() {
    _router.maybePop();
  }
}
