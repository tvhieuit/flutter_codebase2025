import 'package:app_core/app_core.dart';
import 'package:injectable/injectable.dart';

import '../utils/constants.dart';

@module
abstract class DataModule {
  @apiUrlNamed
  @lazySingleton
  String get apiUrl => Constants.apiUrl;

  @tenantIdNamed
  @lazySingleton
  String get tenantId => Constants.tenantId;

  @categoryOilNamed
  @lazySingleton
  String get categoryOil => Constants.categoryOil;
}
