import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Domain layer dependency injection module.
///
/// Registers external dependencies that can't be auto-injected.
@module
abstract class DomainModule {
  /// Provides SharedPreferencesAsync instance.
  ///
  /// This is a lazy singleton - created when first requested.
  /// Uses the new async-only API (no local cache).
  @lazySingleton
  SharedPreferencesAsync get sharedPreferencesAsync => SharedPreferencesAsync();

  /// Main Dio instance with auth interceptor
  @lazySingleton
  Dio dio(@Named('auth_interceptor') Interceptor authInterceptor) {
    final dio = Dio(
      BaseOptions(
        baseUrl: const String.fromEnvironment(
          'API_BASE_URL',
          defaultValue: 'https://jsonplaceholder.typicode.com',
        ),
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add interceptors
    dio.interceptors.addAll([
      authInterceptor,
      LogInterceptor(responseBody: true, requestBody: true),
    ]);

    return dio;
  }

  /// Dio instance specifically for AuthRepository to avoid circular dependency
  @Named('auth_dio')
  @lazySingleton
  Dio authDio() {
    return Dio(
      BaseOptions(
        baseUrl: const String.fromEnvironment(
          'API_BASE_URL',
          defaultValue: 'https://jsonplaceholder.typicode.com',
        ),
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
  }
}
