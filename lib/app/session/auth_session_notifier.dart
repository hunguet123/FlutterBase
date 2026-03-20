import 'package:flutter_base/core/analytics/analytics_events.dart';
import 'package:flutter_base/core/analytics/data/analytics_provider.dart';
import 'package:flutter_base/features/auth/data/auth_repository_provider.dart';
import 'package:flutter_base/features/auth/domain/use_cases/logout_use_case_provider.dart';
import 'package:flutter_base/app/session/auth_session_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_session_notifier.g.dart';

/// App-level auth session: tracks login status and handles logout.
/// Lives in app/session/ because it is consumed by routing and any feature,
/// not just the auth feature itself.
@Riverpod(keepAlive: true, dependencies: [authRepository, logoutUseCase, analytics])
class AuthSessionNotifier extends _$AuthSessionNotifier {
  @override
  Future<AuthSessionState> build() async {
    final hasSession = await ref.watch(authRepositoryProvider).hasSession();
    return AuthSessionState(isLoggedIn: hasSession);
  }

  Future<void> logout() async {
    await ref.read(logoutUseCaseProvider).call();
    ref.read(analyticsProvider).logEvent(name: AnalyticsEvents.logout);
    state = const AsyncValue.data(AuthSessionState(isLoggedIn: false));
  }
}
