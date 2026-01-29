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
}
