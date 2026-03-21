import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:flutter_base/core/storage/secure_storage_contract.dart';

/// Implementation using FlutterSecureStorage (Keychain/EncryptedSharedPreferences).
class SecureStorageImpl implements SecureStorage {
  SecureStorageImpl(this._storage);

  final FlutterSecureStorage _storage;

  @override
  Future<void> write(String key, String value) =>
      _storage.write(key: key, value: value);

  @override
  Future<String?> read(String key) => _storage.read(key: key);

  @override
  Future<void> delete(String key) => _storage.delete(key: key);

  @override
  Future<void> clear() => _storage.deleteAll();
}
