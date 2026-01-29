import 'package:flutter_starter_pro/core/constants/storage_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Local storage for non-sensitive data using SharedPreferences
class LocalStorage {
  LocalStorage(this._prefs);

  final SharedPreferences _prefs;

  bool get isFirstLaunch => _prefs.getBool(StorageKeys.isFirstLaunch) ?? true;

  Future<void> setFirstLaunchComplete() async {
    await _prefs.setBool(StorageKeys.isFirstLaunch, false);
  }

  bool get isOnboardingCompleted =>
      _prefs.getBool(StorageKeys.isOnboardingCompleted) ?? false;

  Future<void> setOnboardingCompleted() async {
    await _prefs.setBool(StorageKeys.isOnboardingCompleted, true);
  }

  String? get themeMode => _prefs.getString(StorageKeys.themeMode);

  Future<void> setThemeMode(String mode) async {
    await _prefs.setString(StorageKeys.themeMode, mode);
  }

  String? get languageCode => _prefs.getString(StorageKeys.languageCode);

  Future<void> setLanguageCode(String code) async {
    await _prefs.setString(StorageKeys.languageCode, code);
  }

  bool get rememberMe => _prefs.getBool(StorageKeys.rememberMe) ?? false;

  Future<void> setRememberMe({required bool value}) async {
    await _prefs.setBool(StorageKeys.rememberMe, value);
  }

  String? get userEmail => _prefs.getString(StorageKeys.userEmail);

  Future<void> setUserEmail(String email) async {
    await _prefs.setString(StorageKeys.userEmail, email);
  }

  Future<void> clearUserEmail() async {
    await _prefs.remove(StorageKeys.userEmail);
  }

  DateTime? get lastSyncTime {
    final timestamp = _prefs.getInt(StorageKeys.lastSyncTime);
    return timestamp != null
        ? DateTime.fromMillisecondsSinceEpoch(timestamp)
        : null;
  }

  Future<void> setLastSyncTime(DateTime time) async {
    await _prefs.setInt(StorageKeys.lastSyncTime, time.millisecondsSinceEpoch);
  }

  Future<bool> setString(String key, String value) async {
    return _prefs.setString(key, value);
  }

  String? getString(String key) => _prefs.getString(key);

  Future<bool> setInt(String key, int value) async {
    return _prefs.setInt(key, value);
  }

  int? getInt(String key) => _prefs.getInt(key);

  Future<bool> setBool(String key, {required bool value}) async {
    return _prefs.setBool(key, value);
  }

  bool? getBool(String key) => _prefs.getBool(key);

  Future<bool> setDouble(String key, double value) async {
    return _prefs.setDouble(key, value);
  }

  double? getDouble(String key) => _prefs.getDouble(key);

  Future<bool> setStringList(String key, List<String> value) async {
    return _prefs.setStringList(key, value);
  }

  List<String>? getStringList(String key) => _prefs.getStringList(key);

  Future<bool> remove(String key) async {
    return _prefs.remove(key);
  }

  Future<bool> clear() async {
    return _prefs.clear();
  }

  bool containsKey(String key) => _prefs.containsKey(key);

  Set<String> getKeys() => _prefs.getKeys();
}
