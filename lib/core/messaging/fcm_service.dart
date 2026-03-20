import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_base/core/messaging/fcm_background_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'fcm_service.g.dart';

/// Provider for Firebase Messaging instance.
@Riverpod(keepAlive: true, dependencies: [])
FirebaseMessaging firebaseMessaging(Ref ref) =>
    FirebaseMessaging.instance;

/// FCM service for managing push notifications.
/// Handles permission request, foreground/background messages, token, and tap handling.
class FcmService {
  FcmService(this._messaging);

  final FirebaseMessaging _messaging;

  /// Request notification permission (iOS / Android 13+).
  Future<NotificationSettings> requestPermission() {
    return _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      announcement: false,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      // ignore: deprecated_member_use
      // clickAction: '', // Not used in modern FCM libs but some old code might have it
    );
  }

  /// Get FCM registration token for sending messages to this device.
  Future<String?> getToken() => _messaging.getToken();

  /// Stream of foreground messages.
  Stream<RemoteMessage> get onMessage => FirebaseMessaging.onMessage;

  /// Stream when user taps notification (app opened from background/terminated).
  Stream<RemoteMessage> get onMessageOpenedApp =>
      FirebaseMessaging.onMessageOpenedApp;

  /// Stream of token refresh.
  Stream<String> get onTokenRefresh => _messaging.onTokenRefresh;

  /// Setup all listeners and request permissions.
  Future<void> init() async {
    // Register background handler
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    await requestPermission();

    // Log token
    final token = await getToken();
    log('FCM Token: $token');

    onTokenRefresh.listen((token) {
      log('FCM Token Refreshed: $token');
    });

    onMessage.listen((msg) {
      log('FCM foreground: ${msg.notification?.title}');
    });

    onMessageOpenedApp.listen((msg) {
      log('FCM opened: ${msg.data}');
    });
  }
}

@Riverpod(keepAlive: true, dependencies: [firebaseMessaging])
FcmService fcmService(Ref ref) {
  final messaging = ref.watch(firebaseMessagingProvider);
  return FcmService(messaging);
}
