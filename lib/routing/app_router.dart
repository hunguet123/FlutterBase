import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_base/core/analytics/analytics_events.dart';

import 'package:flutter_base/core/analytics/analytics_provider.dart';
import 'package:flutter_base/core/config/data/app_config_provider.dart';
import 'package:flutter_base/core/config/domain/models/app_config.dart';
import 'package:flutter_base/features/auth/presentation/screens/login_screen.dart';
import 'package:flutter_base/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter_base/features/auth/presentation/providers/auth_state.dart';
import 'package:flutter_base/features/home/presentation/screens/home_screen.dart';
import 'package:flutter_base/routing/app_routes.dart';
import 'package:flutter_base/features/home/presentation/screens/maintenance_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

/// NavigatorObserver that logs screen views to Firebase Analytics.
class _AnalyticsRouteObserver extends NavigatorObserver {
  _AnalyticsRouteObserver(this._analytics);

  final FirebaseAnalytics _analytics;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    final name = route.settings.name ?? route.settings.arguments?.toString();
    if (name != null && name.isNotEmpty) {
      _analytics.logScreenView(screenName: name, screenClass: name);
    }
  }
}

/// Application router configuration.
/// [refreshNotifier] must be updated when auth state changes (e.g. from authNotifierProvider).
GoRouter createAppRouter(
  GoRouterRefreshNotifier refreshNotifier,
  FirebaseAnalytics analytics,
  AppConfig appConfig,
) {
  return GoRouter(
    initialLocation: AppRoutes.login,
    refreshListenable: refreshNotifier,
    observers: [_AnalyticsRouteObserver(analytics)],
    redirect: (context, state) {
      // 1. Check Maintenance Mode first (Global switch)
      final isMaintenance = appConfig.maintenanceMode;
      final isOnMaintenance = state.matchedLocation == AppRoutes.maintenance;

      if (isMaintenance) {
        return isOnMaintenance ? null : AppRoutes.maintenance;
      }
      if (isOnMaintenance && !isMaintenance) {
        return AppRoutes.login; // Resume app
      }

      // 2. Auth checks
      final isLoggedIn = refreshNotifier.isLoggedIn;
      final isOnLogin = state.matchedLocation == AppRoutes.login;

      if (!isLoggedIn && !isOnLogin) {
        return AppRoutes.login;
      }
      if (isLoggedIn && isOnLogin) {
        return AppRoutes.home;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.login,
        name: AnalyticsEvents.screenLogin,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.home,
        name: AnalyticsEvents.screenHome,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.maintenance,
        builder: (context, state) => const MaintenanceScreen(),
      ),
    ],
  );
}

/// Notifier for go_router refresh when auth state changes.
class GoRouterRefreshNotifier extends ChangeNotifier {
  GoRouterRefreshNotifier(this._isLoggedIn);

  bool _isLoggedIn;
  bool get isLoggedIn => _isLoggedIn;

  void update(bool value) {
    if (_isLoggedIn != value) {
      _isLoggedIn = value;
      notifyListeners();
    }
  }
}

/// Provider for GoRouterRefreshNotifier.
@Riverpod(keepAlive: true)
Raw<GoRouterRefreshNotifier> authRefreshNotifier(Ref ref) {
  final authAsync = ref.read(authNotifierProvider);
  final isLoggedIn = authAsync.asData?.value.isLoggedIn ?? false;
  final notifier = GoRouterRefreshNotifier(isLoggedIn);

  ref.listen<AsyncValue<AuthState>>(
    authNotifierProvider,
    (_, next) => notifier.update(next.asData?.value.isLoggedIn ?? false),
  );

  ref.onDispose(notifier.dispose);

  return notifier;
}

/// Provider for application router.
@Riverpod(keepAlive: true)
GoRouter router(Ref ref) {
  final refreshNotifier = ref.read(authRefreshNotifierProvider);
  final analytics = ref.read(analyticsProvider);
  final appConfig = ref.read(appConfigProvider);
  return createAppRouter(refreshNotifier, analytics, appConfig);
}
