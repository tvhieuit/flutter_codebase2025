/// Storage keys constants for type-safe key access.
///
/// Usage:
/// ```dart
/// await localStorage.getString(StorageKeys.accessToken);
/// await localStorage.setJson(StorageKeys.currentUser, user.toJson());
/// ```
abstract class StorageKeys {
  StorageKeys._();

  // ==========================================================================
  // AUTH
  // ==========================================================================

  /// Access token for API authentication
  static const String accessToken = 'access_token';

  /// Refresh token for token renewal
  static const String refreshToken = 'refresh_token';

  /// Token expiry timestamp
  static const String tokenExpiry = 'token_expiry';

  // ==========================================================================
  // USER
  // ==========================================================================

  /// Current logged in user data
  static const String currentUser = 'current_user';

  /// User ID
  static const String userId = 'user_id';

  /// User preferences
  static const String userPreferences = 'user_preferences';

  // ==========================================================================
  // APP SETTINGS
  // ==========================================================================

  /// App theme mode (light/dark/system)
  static const String themeMode = 'theme_mode';

  /// App language code
  static const String languageCode = 'language_code';

  /// First launch flag
  static const String isFirstLaunch = 'is_first_launch';

  /// Onboarding completed flag
  static const String onboardingCompleted = 'onboarding_completed';

  // ==========================================================================
  // CACHE
  // ==========================================================================

  /// Cached user list
  static const String cachedUsers = 'cached_users';

  /// Cached products list
  static const String cachedProducts = 'cached_products';

  /// Cache timestamp for users
  static const String usersCacheTimestamp = 'users_cache_timestamp';

  /// Cache timestamp for products
  static const String productsCacheTimestamp = 'products_cache_timestamp';

  // ==========================================================================
  // NOTIFICATIONS
  // ==========================================================================

  /// Push notification enabled
  static const String pushNotificationEnabled = 'push_notification_enabled';

  /// FCM token
  static const String fcmToken = 'fcm_token';

  // ==========================================================================
  // HELPERS
  // ==========================================================================

  /// Creates a cache key with prefix
  static String cacheKey(String key) => 'cache_$key';

  /// Creates a timestamp key
  static String timestampKey(String key) => '${key}_timestamp';
}
