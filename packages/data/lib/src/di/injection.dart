import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'injection.config.dart' as config;

/// Initialize data package dependencies.
///
/// Call this from your main app's configureDependencies BEFORE domain init:
///
/// ```dart
/// void configureDependencies() {
///   initCorePackage();
///   initWidgetPackage();
///   initDataPackage();    // Data first (registers implementations)
///   initDomainPackage();  // Then domain (registers use cases)
///   getIt.init();
/// }
/// ```
@InjectableInit(
  initializerName: 'initDataPackageConfig',
  preferRelativeImports: true,
  asExtension: false,
)
GetIt initDataPackage({
  GetIt? getIt,
  String? environment,
  EnvironmentFilter? environmentFilter,
}) {
  return config.initDataPackageConfig(
    getIt ?? GetIt.instance,
    environment: environment,
    environmentFilter: environmentFilter,
  );
}
