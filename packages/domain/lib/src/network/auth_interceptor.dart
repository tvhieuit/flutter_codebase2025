import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../repositories/repositories.dart';

/// Interceptor to handle authentication headers and automated token refresh.
@injectable
class AuthInterceptor extends Interceptor {
  final AuthRepository _authRepository;

  AuthInterceptor(this._authRepository);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final result = await _authRepository.getAccessToken();
    final token = result.data;

    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      // Logic for token refresh can be implemented here if needed,
      // but usually it's better to handle it in a way that doesn't
      // cause circular dependencies. For now, we'll just pass the error.
      // If we need to retry, we'd ideally use a separate Dio instance.
    }

    handler.next(err);
  }
}
