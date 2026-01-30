import 'package:app_widget/app_widget.dart' as widget;
import 'package:domain/domain.dart' as domain;
import 'package:app_core/app_core.dart' as core;
import 'package:feature_auth/auth.dart' as auth;
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async {
  core.initCorePackage(getIt: getIt);
  // Configure widget package DI
  widget.initWidgetPackage(getIt: getIt);

  // Configure domain package DI
  domain.initDomainPackage(getIt: getIt);

  // Configure feature_auth package DI
  auth.initAuthPackage(getIt: getIt);

  // Configure this app's DI
  getIt.init();
}
