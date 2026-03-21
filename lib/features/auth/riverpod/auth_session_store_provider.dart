import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:flutter_base/core/storage/riverpod/secure_storage_provider.dart';
import 'package:flutter_base/features/auth/data/auth_session_store.dart';

part 'auth_session_store_provider.g.dart';

@Riverpod(keepAlive: true, dependencies: [secureStorage])
AuthSessionStore authSessionStore(Ref ref) {
  return AuthSessionStore(ref.watch(secureStorageProvider));
}
