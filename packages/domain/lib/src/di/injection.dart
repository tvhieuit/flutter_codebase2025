import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'injection.config.dart' as config;

/// Initialize domain package dependencies.
///
/// Call this from your main app's configureDependencies BEFORE the main init:
///
/// ```dart
/// void configureDependencies() {
///   initDomainPackage();  // Domain first
///   getIt.init();               // Then main app
/// }
/// ```
@InjectableInit(
  initializerName: 'initDomainPackageConfig',
  preferRelativeImports: true,
  asExtension: false,
)
GetIt initDomainPackage({
  GetIt? getIt,
  String? environment,
  EnvironmentFilter? environmentFilter,
}) {
  return config.initDomainPackageConfig(
    getIt ?? GetIt.instance,
    environment: environment,
    environmentFilter: environmentFilter,
  );
}
