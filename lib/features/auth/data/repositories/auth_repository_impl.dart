import 'package:dio/dio.dart';
import 'package:flutter_base/core/exceptions/app_exception.dart';
import 'package:flutter_base/features/auth/data/auth_session_store.dart';
import 'package:flutter_base/features/auth/domain/models/auth_tokens.dart';
import 'package:flutter_base/features/auth/domain/repositories/auth_repository.dart';

/// Implementation using Dio for API calls.
/// Wraps [DioException] into [NetworkException] so callers above the data
/// layer never need to import Dio.
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._dio, this._sessionStore);

  final Dio _dio;
  final AuthSessionStore _sessionStore;

  static const _loginPath = '/auth/login';

  @override
  Future<void> login(String username, String password) async {
    try {
      final response = await _dio.post(
        _loginPath,
        data: {'username': username, 'password': password},
      );

      if (response.statusCode == 200 && response.data != null) {
        if (response.data is! Map<String, dynamic>) {
          throw NetworkException(
            'Login failed: unexpected response format',
          );
        }

        final data = response.data as Map<String, dynamic>;
        final accessToken =
            data['access_token'] as String? ?? data['token'] as String?;
        final refreshToken = data['refresh_token'] as String?;

        if (accessToken != null && accessToken.isNotEmpty) {
          await _sessionStore.setTokens(
            AuthTokens(accessToken: accessToken, refreshToken: refreshToken),
          );
        } else {
          throw NetworkException('Login failed: access_token missing in response');
        }
      } else {
        throw NetworkException('Login failed: invalid status code or empty data');
      }
    } on DioException catch (e) {
      throw NetworkException(e.message ?? 'Network error');
    }
  }

  @override
  Future<void> logout() async {
    await _sessionStore.clear();
  }

  @override
  Future<bool> hasSession() async {
    final token = _sessionStore.accessToken;
    return token != null && token.isNotEmpty;
  }
}
