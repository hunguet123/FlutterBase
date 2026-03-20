import 'package:flutter_base/core/analytics/analytics_events.dart';
import 'package:flutter_base/core/analytics/analytics_provider.dart';
import 'package:flutter_base/features/auth/data/auth_repository_provider.dart';
import 'package:flutter_base/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_base/app/providers/auth_session_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_session_notifier.g.dart';

/// App-level auth session: tracks login status and handles logout.
/// Lives in app/ because it is consumed by routing and any feature,
/// not just the auth feature itself.
@Riverpod(keepAlive: true, dependencies: [authRepository, analytics])
class AuthSessionNotifier extends _$AuthSessionNotifier {
  @override
  Future<AuthSessionState> build() async {
    final hasSession = await ref.watch(authRepositoryProvider).hasSession();
    return AuthSessionState(isLoggedIn: hasSession);
  }

  AuthRepository get _authRepository => ref.read(authRepositoryProvider);

  Future<void> logout() async {
    await _authRepository.logout();
    ref.read(analyticsProvider).logEvent(name: AnalyticsEvents.logout);
    state = const AsyncValue.data(AuthSessionState(isLoggedIn: false));
  }
}
