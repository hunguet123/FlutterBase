import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:flutter_base/core/network/api_client.dart';
import 'package:flutter_base/core/network/auth_token_provider.dart';

part 'api_client_provider.g.dart';

/// Provides configured Dio instance for API calls.
/// Depends on [authTokenProviderRef] which must be overridden at the
/// composition root with the concrete [AuthTokenProvider] implementation.
@Riverpod(keepAlive: true, dependencies: [])
Dio apiClient(Ref ref) {
  final tokenProvider = ref.watch(authTokenProviderRef);
  return createApiClient(tokenProvider);
}
