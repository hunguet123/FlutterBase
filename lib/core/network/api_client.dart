import 'package:dio/dio.dart';

import 'package:flutter_base/core/config/env.dart';
import 'package:flutter_base/core/network/api_interceptors.dart';
import 'package:flutter_base/features/auth/domain/interfaces/auth_token_provider.dart';

/// Creates and configures Dio instance for API calls.
Dio createApiClient(AuthTokenProvider tokenProvider) {
  final dio = Dio(
    BaseOptions(
      baseUrl: Env.apiBaseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  dio.interceptors.addAll([
    ApiLogInterceptor(),
    AuthInterceptor(tokenProvider),
    ErrorInterceptor(),
  ]);

  return dio;
}
