import 'package:app_core/app_core.dart';
import 'package:app_widget/app_widget.dart';
import 'package:feature_app_settings/app_settings.dart';
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
  initCorePackage();

  // Initialize widget package dependencies
  initWidgetPackage();

  // Initialize domain package dependencies
  initDomainPackage();

  // Initialize auth package dependencies
  initAuthPackage();

  // Initialize app settings package dependencies
  initAppSettingsPackage();

  // Initialize main app dependencies
  getIt.init();
}
