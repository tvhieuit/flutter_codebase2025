import 'package:domain/domain.dart';
import 'package:feature_auth/auth.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)
void configureDependencies() {
  // Initialize domain package dependencies first
  initDomainPackage();

  // Initialize auth package dependencies
  initAuthPackage();

  // Initialize main app dependencies
  getIt.init();
}
