import 'package:dio/dio.dart';

import 'package:flutter_base/features/auth/data/auth_session_store.dart';

/// Repository for authentication. Calls API for login, manages tokens.
abstract interface class AuthRepository {
  Future<void> login(String username, String password);
  Future<void> logout();
  Future<bool> hasSession();
}

/// Implementation using Dio for API calls.
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._dio, this._sessionStore);

  final Dio _dio;
  final AuthSessionStore _sessionStore;
  static const _loginPath = '/auth/login';

  @override
  Future<void> login(String username, String password) async {
    final response = await _dio.post(
      _loginPath,
      data: {'username': username, 'password': password},
    );

    if (response.statusCode == 200 && response.data != null) {
      if (response.data is! Map<String, dynamic>) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Login failed: Expected JSON object but got ${response.data.runtimeType}',
        );
      }
      
      final data = response.data as Map<String, dynamic>;
      final accessToken =
          data['access_token'] as String? ?? data['token'] as String?;
      final refreshToken = data['refresh_token'] as String?;

      if (accessToken != null && accessToken.isNotEmpty) {
        await _sessionStore.setTokens(accessToken, refreshToken);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Login failed: access_token missing in response',
        );
      }
    } else {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        message: 'Login failed: Invalid status code or empty data',
      );
    }
  }

  @override
  Future<void> logout() async {
    await _sessionStore.clear();
  }

  @override
  Future<bool> hasSession() async {
    final token = _sessionStore.accessToken;
    if (token != null && token.isNotEmpty) return true;
    await _sessionStore.loadFromStorage();
    final tokenAfter = _sessionStore.accessToken;
    return tokenAfter != null && tokenAfter.isNotEmpty;
  }
}
