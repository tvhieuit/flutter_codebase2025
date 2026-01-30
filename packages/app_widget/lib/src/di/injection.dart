import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'injection.config.dart' as config;

/// Initialize app_widget package dependencies.
///
/// Call this from your main app's configureDependencies:
///
/// ```dart
/// void configureDependencies() {
///   initWidgetPackage();   // Widget package
///   initDomainPackage();   // Domain
///   getIt.init();          // Then main app
/// }
/// ```
@InjectableInit(
  initializerName: 'initWidgetPackageConfig',
  preferRelativeImports: true,
  asExtension: false,
)
GetIt initWidgetPackage({
  GetIt? getIt,
  String? environment,
  EnvironmentFilter? environmentFilter,
}) {
  return config.initWidgetPackageConfig(
    getIt ?? GetIt.instance,
    environment: environment,
    environmentFilter: environmentFilter,
  );
}
