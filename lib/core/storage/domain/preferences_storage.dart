/// Domain contract for plain key-value storage.
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
