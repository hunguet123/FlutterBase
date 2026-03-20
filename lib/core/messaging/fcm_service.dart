import 'dart:async';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_base/core/messaging/fcm_background_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'fcm_service.g.dart';

var _backgroundHandlerRegistered = false;

/// FCM service for managing push notifications.
/// Handles permission request, foreground/background messages, token, and tap handling.
class FcmService {
  FcmService(this._messaging);

  final FirebaseMessaging _messaging;

  StreamSubscription<String>? _tokenRefreshSub;
  StreamSubscription<RemoteMessage>? _onMessageSub;
  StreamSubscription<RemoteMessage>? _onMessageOpenedAppSub;

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
    if (!_backgroundHandlerRegistered) {
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
      _backgroundHandlerRegistered = true;
    }

    await requestPermission();

    final token = await getToken();
    if (kDebugMode) {
      log('FCM Token: $token');
    }

    await _cancelForegroundSubscriptions();

    _tokenRefreshSub = onTokenRefresh.listen((newToken) {
      if (kDebugMode) {
        log('FCM Token Refreshed: $newToken');
      }
    });

    _onMessageSub = onMessage.listen((msg) {
      log('FCM foreground: ${msg.notification?.title}');
    });

    _onMessageOpenedAppSub = onMessageOpenedApp.listen((msg) {
      log('FCM opened: ${msg.data}');
    });
  }

  /// Cancels foreground stream listeners. Safe to call multiple times.
  Future<void> _cancelForegroundSubscriptions() async {
    await Future.wait([
      _tokenRefreshSub?.cancel() ?? Future<void>.value(),
      _onMessageSub?.cancel() ?? Future<void>.value(),
      _onMessageOpenedAppSub?.cancel() ?? Future<void>.value(),
    ]);
    _tokenRefreshSub = null;
    _onMessageSub = null;
    _onMessageOpenedAppSub = null;
  }
}

@Riverpod(keepAlive: true, dependencies: [])
FcmService fcmService(Ref ref) {
  return FcmService(FirebaseMessaging.instance);
}
