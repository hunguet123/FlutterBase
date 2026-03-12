import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Interface for plain key-value storage.
/// Use for non-sensitive data: theme, locale, preferences, etc.
abstract interface class PreferencesStorage {
  Future<void> setString(String key, String value);
  Future<void> setInt(String key, int value);
  Future<void> setBool(String key, bool value);
  Future<void> setStringList(String key, List<String> value);

  Future<String?> getString(String key);
  Future<int?> getInt(String key);
  Future<bool?> getBool(String key);
  Future<List<String>?> getStringList(String key);

  Future<void> remove(String key);
  Future<void> clear();
}

/// Implementation using SharedPreferences.
class PreferencesStorageImpl implements PreferencesStorage {
  PreferencesStorageImpl(this._prefs);

  final SharedPreferences _prefs;

  @override
  Future<void> setString(String key, String value) =>
      _prefs.setString(key, value);

  @override
  Future<void> setInt(String key, int value) => _prefs.setInt(key, value);

  @override
  Future<void> setBool(String key, bool value) => _prefs.setBool(key, value);

  @override
  Future<void> setStringList(String key, List<String> value) =>
      _prefs.setStringList(key, value);

  @override
  String? getString(String key) => _prefs.getString(key);

  @override
  int? getInt(String key) => _prefs.getInt(key);

  @override
  bool? getBool(String key) => _prefs.getBool(key);

  @override
  List<String>? getStringList(String key) => _prefs.getStringList(key);

  @override
  Future<void> remove(String key) => _prefs.remove(key);

  @override
  Future<void> clear() => _prefs.clear();
}

/// Provider for [PreferencesStorage]. Requires async init via SharedPreferences.getInstance().
final preferencesStorageProvider = FutureProvider<PreferencesStorage>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  return PreferencesStorageImpl(prefs);
});
