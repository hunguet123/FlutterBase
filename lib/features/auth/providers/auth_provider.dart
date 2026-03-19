import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_base/core/analytics/analytics_events.dart';
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
    state = await AsyncValue.guard(() async {
      await _authRepository.login(username, password);
      if (Firebase.apps.isNotEmpty) {
        FirebaseAnalytics.instance.logEvent(name: AnalyticsEvents.login);
      }
      return true;
    });
    state.whenOrNull(error: (e, _) => throw e);
  }

  Future<void> logout() async {
    await _authRepository.logout();
    if (Firebase.apps.isNotEmpty) {
      FirebaseAnalytics.instance.logEvent(name: AnalyticsEvents.logout);
    }
    state = const AsyncValue.data(false);
  }
}
