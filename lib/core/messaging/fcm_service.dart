import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for Firebase Messaging instance.
final firebaseMessagingProvider =
    Provider<FirebaseMessaging>((ref) => FirebaseMessaging.instance);

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
    await requestPermission();

    // Log token
    final token = await getToken();
    log('FCM Token: $token');

    onTokenRefresh.listen((token) {
      log('FCM Token Refreshed: $token');
      // TODO: Send new token to backend session
    });

    onMessage.listen((msg) {
      // Foreground message – log or show in-app notification
      log('FCM foreground: ${msg.notification?.title}');
    });

    onMessageOpenedApp.listen((msg) {
      // User tapped notification – handle deep link / navigate
      log('FCM opened: ${msg.data}');
    });
  }
}


final fcmServiceProvider = Provider<FcmService>((ref) {
  final messaging = ref.watch(firebaseMessagingProvider);
  return FcmService(messaging);
});
