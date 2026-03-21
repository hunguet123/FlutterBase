import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:flutter_base/core/messaging/fcm_service.dart';

part 'fcm_service_provider.g.dart';

@Riverpod(keepAlive: true, dependencies: [])
FcmService fcmService(Ref ref) {
  final service = FcmService(FirebaseMessaging.instance);
  ref.onDispose(service.dispose);
  return service;
}
