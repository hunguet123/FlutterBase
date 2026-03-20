import 'package:go_router/go_router.dart';
import 'package:flutter_base/core/analytics/analytics_events.dart';
import 'package:flutter_base/core/analytics/data/analytics_provider.dart';
import 'package:flutter_base/features/auth/presentation/screens/login_screen.dart';
import 'package:flutter_base/features/home/presentation/screens/home_screen.dart';
import 'package:flutter_base/features/home/presentation/screens/maintenance_screen.dart';
import 'package:flutter_base/routing/analytics_route_observer.dart';
import 'package:flutter_base/routing/app_routes.dart';
import 'package:flutter_base/routing/router_refresh_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

GoRouter createAppRouter(RouterRefreshNotifier refreshNotifier, AnalyticsRouteObserver observer) {
  return GoRouter(
    initialLocation: AppRoutes.login,
    refreshListenable: refreshNotifier,
    observers: [observer],
    redirect: (context, state) {
      final isMaintenance = refreshNotifier.isMaintenance;
      final isOnMaintenance = state.matchedLocation == AppRoutes.maintenance;

      if (isMaintenance) {
        return isOnMaintenance ? null : AppRoutes.maintenance;
      }
      if (isOnMaintenance && !isMaintenance) {
        return AppRoutes.login;
      }

      final isLoggedIn = refreshNotifier.isLoggedIn;
      final isOnLogin = state.matchedLocation == AppRoutes.login;

      if (!isLoggedIn && !isOnLogin) return AppRoutes.login;
      if (isLoggedIn && isOnLogin) return AppRoutes.home;
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

/// Provider for application router.
@Riverpod(keepAlive: true, dependencies: [routerRefreshNotifier, analytics])
GoRouter router(Ref ref) {
  final refreshNotifier = ref.read(routerRefreshNotifierProvider);
  final analytics = ref.read(analyticsProvider);
  final observer = AnalyticsRouteObserver(analytics);
  return createAppRouter(refreshNotifier, observer);
}
