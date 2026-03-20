import 'package:flutter_base/core/config/remote_config_keys.dart';
import 'package:flutter_base/core/config/remote_config_provider.dart';
import 'package:flutter_base/core/exceptions/app_exception.dart';
import 'package:flutter_base/core/analytics/analytics_events.dart';
import 'package:flutter_base/core/analytics/analytics_provider.dart';
import 'package:flutter_base/features/auth/data/auth_repository.dart';
import 'package:flutter_base/features/auth/data/auth_repository_provider.dart';
import 'package:flutter_base/core/network/api_client_provider.dart';
import 'package:flutter_base/features/auth/data/auth_session_store.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_provider.g.dart';

@Riverpod(
  keepAlive: true,
  dependencies: [
    authRepository,
    apiClient,
    authSessionStore,
    remoteConfig,
    analytics,
  ],
)
class AuthNotifier extends _$AuthNotifier {
  @override
  Future<bool> build() async {
    return ref.watch(authRepositoryProvider).hasSession();
  }

  AuthRepository get _authRepository => ref.read(authRepositoryProvider);

  Future<void> login(String username, String password) async {
    final remoteConfig = ref.read(remoteConfigProvider);
    if (remoteConfig.getBool(RemoteConfigKeys.maintenanceMode)) {
      throw MaintenanceException();
    }

    state = await AsyncValue.guard(() async {
      await _authRepository.login(username, password);
      ref.read(analyticsProvider).logEvent(name: AnalyticsEvents.login);
      return true;
    });
    state.whenOrNull(error: (e, _) => throw e);
  }

  Future<void> logout() async {
    await _authRepository.logout();
    ref.read(analyticsProvider).logEvent(name: AnalyticsEvents.logout);
    state = const AsyncValue.data(false);
  }
}
