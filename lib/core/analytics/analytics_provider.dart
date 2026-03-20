import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'analytics_provider.g.dart';

/// Provider for Firebase Analytics instance.
@Riverpod(keepAlive: true, dependencies: [])
FirebaseAnalytics analytics(Ref ref) {
  return FirebaseAnalytics.instance;
}
