import 'package:auto_route/auto_route.dart';
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
}

/// Module for registering routing dependencies
@module
abstract class RouteModule {
  @lazySingleton
  AppRoute get appRoute => const AppRoute(
    login: LoginRoute(),
    register: RegisterRoute(),
    home: HomeRoute(),
  );

  @lazySingleton
  StackRouter stackRouter(AppRouter appRouter) => appRouter;
}

/// AuthRepository implementation for the customer app
@Injectable()
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl();

  @override
  Future<Result<AuthToken>> login(LoginCredentials credentials) async {
    try {
      // TODO: Implement actual API call
      // final response = await _dio.post('/auth/login', data: credentials.toJson());

      // Mock successful login
      await Future.delayed(const Duration(seconds: 1));

      return const Result.success(
        AuthToken(
          accessToken: 'mock_access_token',
          refreshToken: 'mock_refresh_token',
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
      // TODO: Implement actual API call
      // final response = await _dio.post('/auth/register', data: credentials.toJson());

      // Mock successful registration
      await Future.delayed(const Duration(seconds: 1));

      return const Result.success(
        AuthToken(
          accessToken: 'mock_access_token',
          refreshToken: 'mock_refresh_token',
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
      // TODO: Implement actual API call
      await Future.delayed(const Duration(milliseconds: 500));
      return const Result.success(null);
    } catch (e) {
      return Result.failure(Failure.server(message: e.toString()));
    }
  }

  @override
  Future<Result<AuthToken>> refreshToken(String refreshToken) async {
    try {
      // TODO: Implement actual API call
      await Future.delayed(const Duration(milliseconds: 500));

      return const Result.success(
        AuthToken(
          accessToken: 'new_mock_access_token',
          refreshToken: 'new_mock_refresh_token',
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
      // TODO: Check actual authentication status
      return const Result.success(false);
    } catch (e) {
      return Result.failure(Failure.server(message: e.toString()));
    }
  }

  @override
  Future<Result<String?>> getAccessToken() async {
    try {
      // TODO: Get actual access token
      return const Result.success(null);
    } catch (e) {
      return Result.failure(Failure.server(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> forgotPassword(String email) async {
    try {
      // TODO: Implement forgot password API call
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
      // TODO: Implement reset password API call
      await Future.delayed(const Duration(milliseconds: 500));
      return const Result.success(null);
    } catch (e) {
      return Result.failure(Failure.server(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> verifyEmail(String otp) async {
    try {
      // TODO: Implement verify email API call
      await Future.delayed(const Duration(milliseconds: 500));
      return const Result.success(null);
    } catch (e) {
      return Result.failure(Failure.server(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> resendVerificationEmail(String email) async {
    try {
      // TODO: Implement resend verification email API call
      await Future.delayed(const Duration(milliseconds: 500));
      return const Result.success(null);
    } catch (e) {
      return Result.failure(Failure.server(message: e.toString()));
    }
  }
}

