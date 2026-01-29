import 'package:dio/dio.dart';
import 'package:domain/domain.dart';
import 'package:feature_auth/auth.dart';
import 'package:injectable/injectable.dart';

import '../app/app_router.dart' show AppRouter, HomeRoute;
import '../app/auth_routes.dart';

/// Module for registering third-party dependencies and implementations
@module
abstract class AppModule {
  /// Provide Dio instance for networking
  @singleton
  Dio get dio {
    final dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
      ),
    );

    // Add logging interceptor in debug mode
    dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true, error: true),
    );

    return dio;
  }
}

/// Module for registering auth-related implementations
@module
abstract class AuthModule {
  /// Provide AuthRepository implementation
  @LazySingleton(as: AuthRepository)
  AuthRepositoryImpl get authRepository;

  /// Provide AuthNavigation implementation
  @LazySingleton(as: AuthNavigation)
  AuthNavigationImpl get authNavigation;
}

/// AuthRepository implementation for the driver app
@Injectable()
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl();

  @override
  Future<Result<AuthToken>> login(LoginCredentials credentials) async {
    try {
      // TODO: Implement actual API call for driver login
      await Future.delayed(const Duration(seconds: 1));

      return const Result.success(
        AuthToken(
          accessToken: 'driver_mock_access_token',
          refreshToken: 'driver_mock_refresh_token',
          expiresIn: 3600,
        ),
      );
    } catch (e) {
      return Result.failure(Failure.server(message: e.toString()));
    }
  }

  @override
  Future<Result<AuthToken>> register(RegisterCredentials credentials) async {
    try {
      // TODO: Implement actual API call for driver registration
      await Future.delayed(const Duration(seconds: 1));

      return const Result.success(
        AuthToken(
          accessToken: 'driver_mock_access_token',
          refreshToken: 'driver_mock_refresh_token',
          expiresIn: 3600,
        ),
      );
    } catch (e) {
      return Result.failure(Failure.server(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> logout() async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      return const Result.success(null);
    } catch (e) {
      return Result.failure(Failure.server(message: e.toString()));
    }
  }

  @override
  Future<Result<AuthToken>> refreshToken(String refreshToken) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));

      return const Result.success(
        AuthToken(
          accessToken: 'new_driver_mock_access_token',
          refreshToken: 'new_driver_mock_refresh_token',
          expiresIn: 3600,
        ),
      );
    } catch (e) {
      return Result.failure(Failure.server(message: e.toString()));
    }
  }

  @override
  Future<Result<bool>> isAuthenticated() async {
    try {
      return const Result.success(false);
    } catch (e) {
      return Result.failure(Failure.server(message: e.toString()));
    }
  }

  @override
  Future<Result<String?>> getAccessToken() async {
    try {
      return const Result.success(null);
    } catch (e) {
      return Result.failure(Failure.server(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> forgotPassword(String email) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      return const Result.success(null);
    } catch (e) {
      return Result.failure(Failure.server(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      return const Result.success(null);
    } catch (e) {
      return Result.failure(Failure.server(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> verifyEmail(String otp) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      return const Result.success(null);
    } catch (e) {
      return Result.failure(Failure.server(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> resendVerificationEmail(String email) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      return const Result.success(null);
    } catch (e) {
      return Result.failure(Failure.server(message: e.toString()));
    }
  }
}

/// AuthNavigation implementation using auto_route
@Injectable()
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
    _router.replaceAll([const HomeRoute()]);
  }

  @override
  void goToForgotPassword() {
    // TODO: Implement forgot password route
  }

  @override
  void goBack() {
    _router.maybePop();
  }
}
