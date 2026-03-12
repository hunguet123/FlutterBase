import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/analytics/analytics_events.dart';
import '../features/auth/presentation/screens/login_screen.dart';
import '../features/home/presentation/screens/home_screen.dart';
import 'app_routes.dart';

/// NavigatorObserver that logs screen views to Firebase Analytics.
class _AnalyticsRouteObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    if (Firebase.apps.isEmpty) return; // Skip in tests
    final name = route.settings.name ?? route.settings.arguments?.toString();
    if (name != null && name.isNotEmpty) {
      FirebaseAnalytics.instance.logScreenView(
        screenName: name,
        screenClass: name,
      );
    }
  }
}

/// Application router configuration.
/// [refreshNotifier] must be updated when auth state changes (e.g. from authNotifierProvider).
GoRouter createAppRouter(GoRouterRefreshNotifier refreshNotifier) {
  return GoRouter(
    initialLocation: AppRoutes.login,
    refreshListenable: refreshNotifier,
    observers: [_AnalyticsRouteObserver()],
    redirect: (context, state) {
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
