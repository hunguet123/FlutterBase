import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import 'package:flutter_base/core/network/auth_token_provider.dart';

/// Logging interceptor for debug.
class ApiLogInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    log(
      '┌------------------------------------------------------------------------------',
    );
    log('| REQUEST 🌐 ${options.method} ${options.uri}');
    log('| Headers: ${options.headers}');
    if (options.data != null) {
      log('| Body: ${options.data}');
    }
    log(
      '└------------------------------------------------------------------------------',
    );
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    log(
      '┌------------------------------------------------------------------------------',
    );
    log('| RESPONSE ✅ ${response.statusCode} ${response.requestOptions.uri}');
    if (response.data != null) {
      log('| Payload: ${response.data}');
    }
    log(
      '└------------------------------------------------------------------------------',
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    log(
      '┌------------------------------------------------------------------------------',
    );
    log('| ERROR ❌ ${err.response?.statusCode} ${err.requestOptions.uri}');
    log('| Message: ${err.message}');
    if (err.response?.data != null) {
      log('| Response Data: ${err.response?.data}');
    }
    log(
      '└------------------------------------------------------------------------------',
    );
    handler.next(err);
  }
}

/// Adds Bearer token to requests when user is logged in.
class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._tokenProvider);

  final AuthTokenProvider _tokenProvider;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = _tokenProvider.accessToken;
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
}

/// Global error handling interceptor.
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
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
