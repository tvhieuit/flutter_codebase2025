/// Mixin for safe network calls with error handling
/// Use this in all BLoCs that make API calls
mixin SafetyNetworkMixin {
  /// Executes a network call safely with error handling
  ///
  /// [call] - The async function to execute
  /// [onError] - Optional error handler
  /// [onFinally] - Optional finally block
  Future<T?> safeNetworkCall<T>(
    Future<T> Function() call, {
    Function(dynamic error)? onError,
    Function()? onFinally,
  }) async {
    try {
      return await call();
    } catch (e) {
      // Error logging removed - handle in onError callback
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
