import 'dart:ui' show PlatformDispatcher;

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart' show kReleaseMode;
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/config/env.dart';
import 'core/config/firebase_options_provider.dart';
import 'core/config/remote_config_service.dart';
import 'features/auth/data/auth_session_store.dart';
import 'l10n/strings.g.dart';

/// Firebase Messaging background handler – must be top-level.
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: FirebaseOptionsProvider.currentPlatform,
  );
  // ignore: avoid_print
  print('Background message: ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Env is loaded at compile time via envied
  assert(Env.apiBaseUrl.isNotEmpty, 'API_BASE_URL must be set in .env');

  // 2. Firebase
  await Firebase.initializeApp(
    options: FirebaseOptionsProvider.currentPlatform,
  );
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  if (kReleaseMode) {
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  } else {
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
  }
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await initRemoteConfig(FirebaseRemoteConfig.instance);

  // 3. Localization
  LocaleSettings.useDeviceLocale();

  // 4. Load auth tokens from SecureStorage into memory before app starts
  await AuthSessionStore.instance.loadFromStorage();

  // 5. Run app with ProviderScope
  runApp(const ProviderScope(child: App()));
}
