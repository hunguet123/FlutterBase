import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:flutter_base/core/storage/secure_storage.dart';
import 'package:flutter_base/features/auth/domain/models/auth_tokens.dart';

part 'auth_session_store.g.dart';

const _accessTokenKey = 'access_token';
const _refreshTokenKey = 'refresh_token';

/// Manages auth tokens in SecureStorage with in-memory cache for sync access.
/// Used by [AuthInterceptor] (sync) and [AuthRepository].
final class AuthSessionStore {
  AuthSessionStore(this._secureStorage);

  final SecureStorage _secureStorage;

  String? _accessTokenInMemory;

  /// Sync access for [AuthInterceptor]. Must call [loadFromStorage] at app start.
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

/// Provider for AuthSessionStore. Depends on [secureStorageProvider] for testability.
@Riverpod(keepAlive: true, dependencies: [secureStorage])
AuthSessionStore authSessionStore(Ref ref) {
  return AuthSessionStore(ref.watch(secureStorageProvider));
}
