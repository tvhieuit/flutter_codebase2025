import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'injection.config.dart' as config;

/// Initialize feature_app_settings package dependencies.
@InjectableInit(
  initializerName: 'initAppSettingsPackageConfig',
  preferRelativeImports: true,
  asExtension: false,
)
GetIt initAppSettingsPackage({
  GetIt? getIt,
  String? environment,
  EnvironmentFilter? environmentFilter,
}) {
  return config.initAppSettingsPackageConfig(
    getIt ?? GetIt.instance,
    environment: environment,
    environmentFilter: environmentFilter,
  );
}
