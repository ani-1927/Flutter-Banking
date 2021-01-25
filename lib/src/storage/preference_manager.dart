import 'package:shared_preferences/shared_preferences.dart';

/* This is preferenceManage, which is used to save data in device for future use.
* Used to store data locally in device
* */
class PreferenceManager {
  static PreferenceManager _instance;
  static SharedPreferences _preference;

  static const String keyAccessToken = 'accessToken';
  static const String keyRefreshToken = 'refreshToken';
  static const String keyLocalToken = 'localToken';
  static const String keyEmail = 'email';
  static const String keyExpireTime = 'expireTime';

  static const String keyIsLogin = 'isLogin';
  static const String keyUsername = 'username';

  static Future<PreferenceManager> getInstance() async {
    if (_instance == null) {
      _instance = PreferenceManager();
    }
    if (_preference == null) {
      _preference = await SharedPreferences.getInstance();
    }
    return _instance;
  }

  Future<bool> putBool(String key, bool value) =>
      _preference.setBool(key, value);

  bool getBool(String key) => _preference.getBool(key);

  Future<bool> putDouble(String key, double value) =>
      _preference.setDouble(key, value);

  double getDouble(String key) => _preference.getDouble(key);

  Future<bool> putInt(String key, int value) => _preference.setInt(key, value);

  int getInt(String key) => _preference.getInt(key);

  Future<bool> putString(String key, String value) =>
      _preference.setString(key, value);

  String getString(String key) => _preference.getString(key);

  Future<bool> putStringList(String key, List<String> value) =>
      _preference.setStringList(key, value);

  List<String> getStringList(String key) => _preference.getStringList(key);

  bool isKeyExists(String key) => _preference.containsKey(key);

  Future<bool> clearKey(String key) => _preference.remove(key);

  Future<bool> clearAll() => _preference.clear();
}
