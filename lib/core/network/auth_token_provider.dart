import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_base/features/auth/domain/interfaces/auth_token_provider.dart';

/// Slot provider for [AuthTokenProvider].
///
/// Must be overridden at the composition root (main.dart) with the concrete
/// implementation (e.g. authSessionStoreProvider) before the app starts.
/// This keeps core/network free of any dependency on features/.
final authTokenProviderRef = Provider<AuthTokenProvider>(
  (ref) => throw UnimplementedError(
    'authTokenProviderRef must be overridden in ProviderContainer',
  ),
);
