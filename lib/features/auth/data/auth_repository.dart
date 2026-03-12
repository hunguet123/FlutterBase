import 'package:dio/dio.dart';

import 'auth_session_store.dart';

/// Repository for authentication. Calls API for login, manages tokens.
abstract interface class AuthRepository {
  Future<void> login(String username, String password);
  Future<void> logout();
  Future<bool> hasSession();
}

/// Implementation using Dio for API calls.
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._dio);

  final Dio _dio;
  static const _loginPath = '/auth/login';

  @override
  Future<void> login(String username, String password) async {
    final response = await _dio.post<Map<String, dynamic>>(
      _loginPath,
      data: {'username': username, 'password': password},
    );

    if (response.statusCode == 200 && response.data != null) {
      final data = response.data!;
      final accessToken =
          data['access_token'] as String? ?? data['token'] as String?;
      final refreshToken = data['refresh_token'] as String?;

      if (accessToken != null && accessToken.isNotEmpty) {
        await AuthSessionStore.instance.setTokens(accessToken, refreshToken);
      }
    }
  }

  @override
  Future<void> logout() async {
    await AuthSessionStore.instance.clear();
  }

  @override
  Future<bool> hasSession() async {
    final token = AuthSessionStore.instance.accessToken;
    if (token != null && token.isNotEmpty) return true;
    await AuthSessionStore.instance.loadFromStorage();
    final tokenAfter = AuthSessionStore.instance.accessToken;
    return tokenAfter != null && tokenAfter.isNotEmpty;
  }
}
