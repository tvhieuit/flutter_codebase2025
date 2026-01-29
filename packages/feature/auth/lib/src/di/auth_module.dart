import 'package:injectable/injectable.dart';

/// Auth feature dependency injection module.
///
/// Register this module in your main app's injection configuration:
/// ```dart
/// @InjectableInit(
///   externalPackageModulesBefore: [
///     ExternalModule(DomainModule),
///     ExternalModule(AuthModule),
///   ],
/// )
/// ```
///
/// Note: AuthRepository implementation should be provided by the main app
/// since it may depend on API client configuration.
@module
abstract class AuthModule {
  // Add any auth-specific dependencies here
  // Example:
  // @lazySingleton
  // AuthValidator get authValidator => AuthValidator();
}
