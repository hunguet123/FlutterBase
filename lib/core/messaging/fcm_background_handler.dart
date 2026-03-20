import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

/// Firebase Messaging background handler – MUST be top-level and NOT inside any class.
/// Runs in a separate isolate — cannot access app state or Riverpod providers.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp();
  }

  log('FCM Background message: ${message.messageId}');
}
