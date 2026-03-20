import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:developer';

/// Firebase Messaging background handler – MUST be top-level and NOT inside any class.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Ensure Firebase is initialized in the background isolate
  if (Firebase.apps.isEmpty) {
    const flavor = String.fromEnvironment('FLUTTER_APP_FLAVOR', defaultValue: 'development');
    await dotenv.load(fileName: flavor == 'production' ? '.env.prod' : '.env.dev');
    await Firebase.initializeApp();
  }

  log('FCM Background message: ${message.messageId}');
}
