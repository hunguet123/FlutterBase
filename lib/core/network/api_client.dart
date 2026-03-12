import 'package:dio/dio.dart';

import '../config/env.dart';
import 'api_interceptors.dart';

/// Creates and configures Dio instance for API calls.
Dio createApiClient() {
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
    AuthInterceptor(),
    ErrorInterceptor(),
  ]);

  return dio;
}
