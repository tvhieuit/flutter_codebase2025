import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'injection.config.dart' as config;

/// Initialize auth package dependencies.
///
/// Call this from your main app's configureDependencies AFTER domain init:
///
/// ```dart
/// void configureDependencies() {
///   initDomainPackage(getIt);  // Domain first
///   initAuthPackage(getIt);    // Then auth
///   getIt.init();               // Then main app
/// }
/// ```
@InjectableInit(
  initializerName: 'initAuthPackageConfig',
  preferRelativeImports: true,
  asExtension: false,
)
GetIt initAuthPackage({
  GetIt? getIt,
  String? environment,
  EnvironmentFilter? environmentFilter,
}) {
  return config.initAuthPackageConfig(
    getIt ?? GetIt.instance,
    environment: environment,
    environmentFilter: environmentFilter,
  );
}
