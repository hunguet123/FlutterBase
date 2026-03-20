import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_base/core/network/api_client.dart';
import 'package:flutter_base/features/auth/data/auth_session_store.dart';

/// Provides configured Dio instance for API calls.
final apiClientProvider = Provider<Dio>((ref) {
  final sessionStore = ref.watch(authSessionStoreProvider);
  return createApiClient(sessionStore);
});
