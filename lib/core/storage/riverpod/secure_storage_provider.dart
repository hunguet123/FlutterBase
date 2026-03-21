import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:flutter_base/core/storage/secure_storage_contract.dart';
import 'package:flutter_base/core/storage/secure_storage_impl.dart';

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
