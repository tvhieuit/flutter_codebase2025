import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@module
abstract class StorageModule {
  @lazySingleton
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();
}

