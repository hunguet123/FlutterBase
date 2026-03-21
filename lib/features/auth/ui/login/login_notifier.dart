import 'package:flutter_base/core/analytics/analytics_events.dart';
import 'package:flutter_base/core/analytics/riverpod/analytics_provider.dart';
import 'package:flutter_base/core/exceptions/app_exception.dart';
import 'package:flutter_base/features/auth/ui/login/login_state.dart';
import 'package:flutter_base/features/auth/riverpod/login_use_case_provider.dart';
import 'package:flutter_base/app/riverpod/auth_session_notifier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'login_notifier.g.dart';

@Riverpod(dependencies: [loginUseCase, analytics, AuthSessionNotifier])
class LoginNotifier extends _$LoginNotifier {
  @override
  LoginState build() => LoginState.initial();

  Future<void> login(String username, String password) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await ref.read(loginUseCaseProvider).call(username, password);
      ref.read(analyticsProvider).logEvent(name: AnalyticsEvents.login);
      state = state.copyWith(isLoading: false);
      ref.invalidate(authSessionNotifierProvider);
    } on AppException catch (e) {
      state = state.copyWith(isLoading: false, error: e);
    } catch (e) {
      // Unknown error: keep UX consistent by mapping to a network-style error.
      state = state.copyWith(isLoading: false, error: NetworkException(e.toString()));
    }
  }
}
