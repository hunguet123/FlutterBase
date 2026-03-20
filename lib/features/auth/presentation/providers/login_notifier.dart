import 'package:flutter_base/core/analytics/data/analytics_events.dart';
import 'package:flutter_base/core/analytics/data/analytics_provider.dart';
import 'package:flutter_base/features/auth/data/login_use_case_provider.dart';
import 'package:flutter_base/app/providers/auth_session_notifier.dart';
import 'package:flutter_base/features/auth/presentation/providers/login_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'login_notifier.g.dart';

@Riverpod(dependencies: [loginUseCase, analytics])
class LoginNotifier extends _$LoginNotifier {
  @override
  LoginState build() => LoginState.initial();

  Future<void> login(String username, String password) async {
    state = state.copyWith(isLoading: true);
    try {
      await ref.read(loginUseCaseProvider).call(username, password);
      ref.read(analyticsProvider).logEvent(name: AnalyticsEvents.login);
      state = state.copyWith(isLoading: false);
      ref.invalidate(authSessionNotifierProvider);
    } catch (e) {
      state = state.copyWith(isLoading: false);
      rethrow;
    }
  }
}
