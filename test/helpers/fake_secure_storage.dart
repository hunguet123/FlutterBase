import 'package:flutter_base/core/storage/secure_storage.dart';

/// In-memory implementation of [SecureStorage] for tests.
class FakeSecureStorage implements SecureStorage {
  final Map<String, String> _store = {};

  @override
  Future<void> write(String key, String value) async {
    _store[key] = value;
  }

  @override
  Future<String?> read(String key) async => _store[key];

  @override
  Future<void> delete(String key) async {
    _store.remove(key);
  }

  @override
  Future<void> clear() async {
    _store.clear();
  }

  /// For test verification: check if a key was written.
  bool containsKey(String key) => _store.containsKey(key);
}
