import 'dart:ui' show PlatformDispatcher;

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:flutter_base/app.dart';
import 'package:flutter_base/core/config/env.dart';
import 'package:flutter_base/core/config/remote_config_service.dart';
import 'package:flutter_base/features/auth/data/auth_session_store.dart';
import 'package:flutter_base/l10n/strings.g.dart';

/// Firebase Messaging background handler – must be top-level.
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Need to load env here as well if the background handler needs it
  const flavor = String.fromEnvironment('FLUTTER_APP_FLAVOR', defaultValue: 'development');
  await dotenv.load(fileName: flavor == 'production' ? '.env.prod' : '.env.dev');

  await Firebase.initializeApp();

  // ignore: avoid_print
  print('Background message: ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Load env via flutter_dotenv based on flavor
  const flavor = String.fromEnvironment('FLUTTER_APP_FLAVOR', defaultValue: 'development');
  await dotenv.load(fileName: flavor == 'production' ? '.env.prod' : '.env.dev');
  
  assert(Env.apiBaseUrl.isNotEmpty, 'API_BASE_URL must be set in .env');

  await Firebase.initializeApp();

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await initRemoteConfig(FirebaseRemoteConfig.instance);

  // 3. Localization
  LocaleSettings.useDeviceLocale();

  // 4. Load auth tokens from SecureStorage into memory before app starts
  await AuthSessionStore.instance.loadFromStorage();

  // 5. Run app with ProviderScope
  runApp(const ProviderScope(child: App()));
}
