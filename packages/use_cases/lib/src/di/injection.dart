import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'injection.config.dart' as config;

/// Initialize use_cases package dependencies.
@InjectableInit(
  initializerName: 'initUseCasesPackageConfig',
  preferRelativeImports: true,
  asExtension: false,
)
GetIt initUseCasesPackage({
  GetIt? getIt,
  String? environment,
  EnvironmentFilter? environmentFilter,
}) {
  return config.initUseCasesPackageConfig(
    getIt ?? GetIt.instance,
    environment: environment,
    environmentFilter: environmentFilter,
  );
}
