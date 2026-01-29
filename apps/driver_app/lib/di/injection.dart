import 'package:domain/domain.dart' as domain;
import 'package:feature_auth/auth.dart' as auth;
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async {

  // Configure domain package DI
  domain.initDomainPackage(getIt: getIt);

  // Configure feature_auth package DI
  auth.initAuthPackage(getIt: getIt);

  // Configure this app's DI
  getIt.init();
}
