import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:flutter_base/core/network/data/api_client_provider.dart';
import 'package:flutter_base/features/auth/data/auth_session_store.dart';
import 'package:flutter_base/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:flutter_base/features/auth/domain/repositories/auth_repository.dart';

part 'auth_repository_provider.g.dart';

/// Provides [AuthRepository] implementation.
@Riverpod(dependencies: [apiClient, authSessionStore])
AuthRepository authRepository(Ref ref) {
  final dio = ref.watch(apiClientProvider);
  final sessionStore = ref.watch(authSessionStoreProvider);
  return AuthRepositoryImpl(dio, sessionStore);
}
