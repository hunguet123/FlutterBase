import 'dart:ui' show PlatformDispatcher;

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:flutter_base/app.dart';
import 'package:flutter_base/core/config/env.dart';
import 'package:flutter_base/core/config/remote_config_service.dart';
import 'package:flutter_base/core/messaging/fcm_service.dart';
import 'package:flutter_base/features/auth/data/auth_session_store.dart';
import 'package:flutter_base/l10n/strings.g.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize services and get the container
  final container = await _initServices();

  // 6. Run app with UncontrolledProviderScope to reuse the same container
  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const App(),
    ),
  );
}

/// Initializes all core services (Firebase, Env, Auth, FCM, etc.) 
/// and returns the configured ProviderContainer.
Future<ProviderContainer> _initServices() async {
  // 1. Load env via flutter_dotenv based on flavor
  const flavor = String.fromEnvironment('FLUTTER_APP_FLAVOR', defaultValue: 'development');
  await dotenv.load(fileName: flavor == 'production' ? '.env.prod' : '.env.dev');
  
  assert(Env.apiBaseUrl.isNotEmpty, 'API_BASE_URL must be set in .env');

  await Firebase.initializeApp();

  // 2. Setup Crashlytics
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);

  // 3. Initialize services using Riverpod
  final container = ProviderContainer();
  
  // Remote Config
  await initRemoteConfig(FirebaseRemoteConfig.instance);
  
  // FCM (Background + Foreground)
  await container.read(fcmServiceProvider).init();

  // 4. Localization
  LocaleSettings.useDeviceLocale();

  // 5. Load auth tokens from SecureStorage into memory before app starts
  await AuthSessionStore.instance.loadFromStorage();
  
  return container;
}
