import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class LocalRepository {
  Future<void> saveUserToken(String token);
  Future<String?> getUserToken();
  Future<void> clearUserData();
}

@Injectable(as: LocalRepository)
class LocalRepositoryImpl implements LocalRepository {
  final SharedPreferences _prefs;

  LocalRepositoryImpl(this._prefs);

  @override
  Future<void> saveUserToken(String token) async {
    await _prefs.setString('user_token', token);
  }

  @override
  Future<String?> getUserToken() async {
    return _prefs.getString('user_token');
  }

  @override
  Future<void> clearUserData() async {
    await _prefs.clear();
  }
}

