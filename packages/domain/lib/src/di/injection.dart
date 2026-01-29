import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'injection.config.dart' as config;

/// Initialize domain package dependencies.
///
/// Call this from your main app's configureDependencies BEFORE the main init:
///
/// ```dart
/// void configureDependencies() {
///   initDomainPackage(getIt);  // Domain first
///   getIt.init();               // Then main app
/// }
/// ```
GetIt initDomainPackage({
  GetIt? getIt,
  String? environment,
  EnvironmentFilter? environmentFilter,
}) {
  return config.initDomainPackage(
    getIt ?? GetIt.instance,
    environment: environment,
    environmentFilter: environmentFilter,
  );
}
