import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:flutter_base/core/storage/domain/secure_storage.dart';

part 'secure_storage_provider.g.dart';

/// Provider for [SecureStorage].
@Riverpod(keepAlive: true, dependencies: [])
SecureStorage secureStorage(Ref ref) {
  return SecureStorageImpl(
    const FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true),
    ),
  );
}

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
