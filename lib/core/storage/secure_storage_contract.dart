/// Contract for encrypted key-value storage.
/// Use for sensitive data: tokens, secrets, etc.
abstract interface class SecureStorage {
  Future<void> write(String key, String value);
  Future<String?> read(String key);
  Future<void> delete(String key);
  Future<void> clear();
}
