import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Contract for providing the current access token to network interceptors.
///
/// Defined in core/network/ so that the network layer owns the abstraction
/// it depends on — no import from features/ required.
abstract interface class AuthTokenProvider {
  String? get accessToken;
}

/// Slot provider for [AuthTokenProvider].
///
/// Must be overridden at the composition root (main.dart) with the concrete
/// implementation (e.g. authSessionStoreProvider) before the app starts.
final authTokenProviderRef = Provider<AuthTokenProvider>(
  (ref) => throw UnimplementedError(
    'authTokenProviderRef must be overridden in ProviderContainer',
  ),
);
