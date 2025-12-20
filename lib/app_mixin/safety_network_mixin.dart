import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Mixin for safe network calls with error handling
/// Use this in all BLoCs that make API calls
mixin SafetyNetworkMixin {
  /// Executes a network call safely with error handling
  ///
  /// [call] - The async function to execute
  /// [onError] - Optional error handler
  /// [onFinally] - Optional finally block
  Future<T?> safeNetworkCall<T>({
    required Future<T> Function() call,
    Function(dynamic error)? onError,
    Function()? onFinally,
  }) async {
    try {
      return await call();
    } on DioException catch (e) {
      debugPrint('DioException: ${e.message}');
      debugPrint('Error type: ${e.type}');
      debugPrint('Response: ${e.response?.data}');

      if (onError != null) {
        onError(e);
      }
      return null;
    } catch (e) {
      debugPrint('Unexpected error: $e');
      if (onError != null) {
        onError(e);
      }
      return null;
    } finally {
      if (onFinally != null) {
        onFinally();
      }
    }
  }
}
