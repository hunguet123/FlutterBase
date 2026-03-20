import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_base/core/config/remote_config_keys.dart';
import 'package:flutter_base/core/config/remote_config_service.dart';
import 'package:flutter_base/core/exceptions/app_exception.dart';
import 'package:flutter_base/core/analytics/analytics_events.dart';
import 'package:flutter_base/core/analytics/analytics_service.dart';
import 'package:flutter_base/features/auth/data/auth_repository.dart';
import 'package:flutter_base/features/auth/data/auth_repository_provider.dart';

final authNotifierProvider =
    AsyncNotifierProvider<AuthNotifier, bool>(AuthNotifier.new);

class AuthNotifier extends AsyncNotifier<bool> {
  @override
  Future<bool> build() async {
    return ref.read(authRepositoryProvider).hasSession();
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
