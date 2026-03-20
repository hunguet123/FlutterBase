import 'package:flutter_base/core/analytics/data/analytics_events.dart';
import 'package:flutter_base/core/analytics/data/analytics_provider.dart';
import 'package:flutter_base/core/config/data/app_config_provider.dart';
import 'package:flutter_base/core/exceptions/app_exception.dart';
import 'package:flutter_base/features/auth/data/auth_repository_provider.dart';
import 'package:flutter_base/app/providers/auth_session_notifier.dart';
import 'package:flutter_base/features/auth/presentation/providers/login_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'login_notifier.g.dart';

@Riverpod(dependencies: [authRepository, appConfig, analytics])
class LoginNotifier extends _$LoginNotifier {
  @override
  LoginState build() => LoginState.initial();

  Future<void> login(String username, String password) async {
    final appConfigState = ref.read(appConfigProvider);
    if (appConfigState.maintenanceMode) {
      throw MaintenanceException();
    }

    final authRepository = ref.read(authRepositoryProvider);

    state = state.copyWith(isLoading: true);

    try {
      await authRepository.login(username, password);
      ref.read(analyticsProvider).logEvent(name: AnalyticsEvents.login);
      state = state.copyWith(isLoading: false);
      // Refresh app-level auth status for router redirect.
      ref.invalidate(authSessionNotifierProvider);
    } catch (e) {
      state = state.copyWith(isLoading: false);
      rethrow;
    }
  }
}
