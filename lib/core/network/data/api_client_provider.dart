import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_base/core/network/api_client.dart';
import 'package:flutter_base/core/storage/secure_storage.dart';
import 'package:flutter_base/features/auth/data/auth_session_store.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'api_client_provider.g.dart';

/// Provides configured Dio instance for API calls.
@Riverpod(keepAlive: true, dependencies: [authSessionStore, secureStorage])
Dio apiClient(Ref ref) {
  final sessionStore = ref.watch(authSessionStoreProvider);
  return createApiClient(sessionStore);
}
