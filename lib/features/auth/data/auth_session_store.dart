import 'package:flutter_base/core/network/auth_token_provider.dart';
import 'package:flutter_base/core/storage/secure_storage_contract.dart';
import 'package:flutter_base/features/auth/domain/auth_tokens.dart';

const _accessTokenKey = 'access_token';
const _refreshTokenKey = 'refresh_token';

/// Manages auth tokens in SecureStorage with in-memory cache for sync access.
/// Used by [AuthInterceptor] (sync) and [AuthRepositoryImpl].
final class AuthSessionStore implements AuthTokenProvider {
  AuthSessionStore(this._secureStorage);

  final SecureStorage _secureStorage;

  String? _accessTokenInMemory;

  /// Sync access for [AuthInterceptor]. Must call [loadFromStorage] at app start.
  @override
  String? get accessToken => _accessTokenInMemory;

  Future<void> setTokens(AuthTokens tokens) async {
    await _secureStorage.write(_accessTokenKey, tokens.accessToken);
    if (tokens.refreshToken != null && tokens.refreshToken!.isNotEmpty) {
      await _secureStorage.write(_refreshTokenKey, tokens.refreshToken!);
    }
    _accessTokenInMemory = tokens.accessToken;
  }

  Future<void> loadFromStorage() async {
    _accessTokenInMemory = await _secureStorage.read(_accessTokenKey);
  }

  Future<void> clear() async {
    await _secureStorage.delete(_accessTokenKey);
    await _secureStorage.delete(_refreshTokenKey);
    _accessTokenInMemory = null;
  }

  /// For refresh flow: read refreshToken without exposing sync.
  Future<String?> getRefreshToken() => _secureStorage.read(_refreshTokenKey);
}
