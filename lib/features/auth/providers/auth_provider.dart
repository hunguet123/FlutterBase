import 'package:flutter_base/core/exceptions/app_exception.dart';
import 'package:flutter_base/core/analytics/analytics_events.dart';
import 'package:flutter_base/core/analytics/analytics_provider.dart';
import 'package:flutter_base/core/storage/secure_storage.dart';
import 'package:flutter_base/core/config/data/app_config_provider.dart';
import 'package:flutter_base/features/auth/data/auth_repository_provider.dart';
import 'package:flutter_base/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_base/core/network/api_client_provider.dart';
import 'package:flutter_base/features/auth/data/auth_session_store.dart';
import 'package:flutter_base/features/auth/providers/auth_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_provider.g.dart';

@Riverpod(
  keepAlive: true,
  dependencies: [
    authRepository,
    apiClient,
    authSessionStore,
    secureStorage,
    appConfig,
    analytics,
  ],
)
class AuthNotifier extends _$AuthNotifier {
  @override
  Future<AuthState> build() async {
    final hasSession = await ref.watch(authRepositoryProvider).hasSession();
    return AuthState.initial(isLoggedIn: hasSession);
  }

  AuthRepository get _authRepository => ref.read(authRepositoryProvider);

  Future<void> login(String username, String password) async {
    final appConfig = ref.read(appConfigProvider);
    if (appConfig.maintenanceMode) {
      throw MaintenanceException();
    }

    final current = state.value ?? AuthState.initial(isLoggedIn: false);
    state = AsyncValue.data(
      current.copyWith(username: username, password: password, isLoading: true),
    );

    try {
      await _authRepository.login(username, password);
      ref.read(analyticsProvider).logEvent(name: AnalyticsEvents.login);

      state = AsyncValue.data(
        current.copyWith(
          username: username,
          password: password,
          isLoading: false,
          isLoggedIn: true,
        ),
      );
    } catch (e) {
      state = AsyncValue.data(
        current.copyWith(
          username: username,
          password: password,
          isLoading: false,
        ),
      );
      rethrow;
    }
  }

  Future<void> logout() async {
    await _authRepository.logout();
    ref.read(analyticsProvider).logEvent(name: AnalyticsEvents.logout);
    final current = state.value ?? AuthState.initial(isLoggedIn: false);
    state = AsyncValue.data(
      current.copyWith(isLoading: false, isLoggedIn: false, password: ''),
    );
  }
}
