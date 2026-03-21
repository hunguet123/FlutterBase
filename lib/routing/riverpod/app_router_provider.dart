import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:flutter_base/core/analytics/riverpod/analytics_provider.dart';
import 'package:flutter_base/routing/analytics_route_observer.dart';
import 'package:flutter_base/routing/go_router_factory.dart';
import 'package:flutter_base/routing/riverpod/router_refresh_notifier_provider.dart';

part 'app_router_provider.g.dart';

/// Provider for application router.
@Riverpod(keepAlive: true, dependencies: [routerRefreshNotifier, analytics])
GoRouter router(Ref ref) {
  final refreshNotifier = ref.read(routerRefreshNotifierProvider);
  final analytics = ref.read(analyticsProvider);
  final observer = AnalyticsRouteObserver(analytics);
  return createAppRouter(refreshNotifier, observer);
}
