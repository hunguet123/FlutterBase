import 'dart:async';

import 'package:dio/dio.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import 'package:flutter_base/features/auth/data/auth_session_store.dart';

/// Logging interceptor for debug.
class ApiLogInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    // ignore: avoid_print
    print('┌------------------------------------------------------------------------------');
    // ignore: avoid_print
    print('| REQUEST 🌐 ${options.method} ${options.uri}');
    // ignore: avoid_print
    print('| Headers: ${options.headers}');
    if (options.data != null) {
      // ignore: avoid_print
      print('| Body: ${options.data}');
    }
    // ignore: avoid_print
    print('└------------------------------------------------------------------------------');
    handler.next(options);
  }

  @override
  void onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) {
    // ignore: avoid_print
    print('┌------------------------------------------------------------------------------');
    // ignore: avoid_print
    print('| RESPONSE ✅ ${response.statusCode} ${response.requestOptions.uri}');
    if (response.data != null) {
      // ignore: avoid_print
      print('| Payload: ${response.data}');
    }
    // ignore: avoid_print
    print('└------------------------------------------------------------------------------');
    handler.next(response);
  }

  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) {
    // ignore: avoid_print
    print('┌------------------------------------------------------------------------------');
    // ignore: avoid_print
    print('| ERROR ❌ ${err.response?.statusCode} ${err.requestOptions.uri}');
    // ignore: avoid_print
    print('| Message: ${err.message}');
    if (err.response?.data != null) {
      // ignore: avoid_print
      print('| Response Data: ${err.response?.data}');
    }
    // ignore: avoid_print
    print('└------------------------------------------------------------------------------');
    handler.next(err);
  }
}

/// Adds Bearer token to requests when user is logged in.
class AuthInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    final token = AuthSessionStore.instance.accessToken;
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
}

/// Global error handling interceptor.
class ErrorInterceptor extends Interceptor {
  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) {
    FirebaseCrashlytics.instance
      ..log('API error: ${err.requestOptions.uri}')
      ..setCustomKey('endpoint', err.requestOptions.uri.toString())
      ..setCustomKey('status_code', err.response?.statusCode ?? -1)
      ..setCustomKey('error_type', err.type.name);
    unawaited(
      FirebaseCrashlytics.instance.recordError(
        err,
        err.stackTrace,
        reason: 'API request failed',
        fatal: false,
      ),
    );
    handler.next(err);
  }
}
