import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:flutter_base/core/network/api_client_provider.dart';
import 'package:flutter_base/features/auth/data/auth_repository.dart';
import 'package:flutter_base/features/auth/data/auth_session_store.dart';

part 'auth_repository_provider.g.dart';

/// Provides [AuthRepository] implementation.
@Riverpod(dependencies: [apiClient, authSessionStore])
AuthRepository authRepository(Ref ref) {
  final dio = ref.watch(apiClientProvider);
  final sessionStore = ref.watch(authSessionStoreProvider);
  return AuthRepositoryImpl(dio, sessionStore);
}
