import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

/// Module for third-party dependencies (app-level only)
///
/// Note: SharedPreferencesAsync is registered by domain package's DomainModule
@module
abstract class DiModule {
  /// Dio instance for network calls
  @lazySingleton
  Dio get dio {
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
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Add auth token if available
          // final token = getIt<LocalRepository>().getToken();
          // if (token != null) {
          //   options.headers['Authorization'] = 'Bearer $token';
          // }
          handler.next(options);
        },
        onError: (error, handler) {
          // Handle errors globally
          handler.next(error);
        },
      ),
    );

    return dio;
  }
}
