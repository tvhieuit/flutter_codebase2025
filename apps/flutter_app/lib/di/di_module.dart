import 'package:dio/dio.dart';
import 'package:domain/domain.dart';
import 'package:injectable/injectable.dart';

/// Module for third-party dependencies (app-level only)
///
/// Note: SharedPreferencesAsync is registered by domain package's DomainModule
@module
abstract class DiModule {
  /// Dio instance for network calls
  @lazySingleton
  Dio dio(AuthInterceptor authInterceptor) {
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
      LogInterceptor(responseBody: true, requestBody: true), // Optional but helpful
    ]);

    return dio;
  }
}
