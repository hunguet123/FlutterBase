import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';

/// NavigatorObserver that logs screen views to Firebase Analytics.
class AnalyticsRouteObserver extends NavigatorObserver {
  AnalyticsRouteObserver(this._analytics);

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
