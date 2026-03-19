import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:flutter_base/core/storage/secure_storage.dart';

const _accessTokenKey = 'access_token';
const _refreshTokenKey = 'refresh_token';

/// Manages auth tokens in SecureStorage with in-memory cache for sync access.
/// Used by [AuthInterceptor] (sync) and [AuthRepository].
final class AuthSessionStore {
  AuthSessionStore._(this._secureStorage);

  static AuthSessionStore? _instance;

  /// Default instance. Initialized with built-in [SecureStorage] implementation.
  static AuthSessionStore get instance {
    _instance ??= AuthSessionStore._(
      SecureStorageImpl(FlutterSecureStorage(
        aOptions: const AndroidOptions(encryptedSharedPreferences: true),
      )),
    );
    return _instance!;
  }

  /// Override for tests. Call with a [FakeSecureStorage] or mock.
  static void initWith(SecureStorage storage) {
    _instance = AuthSessionStore._(storage);
  }

  static void resetForTesting() {
    _instance = null;
  }

  final SecureStorage _secureStorage;

  String? _accessTokenInMemory;

  /// Sync access for [AuthInterceptor]. Must call [loadFromStorage] at app start.
  String? get accessToken => _accessTokenInMemory;

  Future<void> setTokens(String accessToken, [String? refreshToken]) async {
    await _secureStorage.write(_accessTokenKey, accessToken);
    if (refreshToken != null && refreshToken.isNotEmpty) {
      await _secureStorage.write(_refreshTokenKey, refreshToken);
    }
    _accessTokenInMemory = accessToken;
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
