import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter_base/core/messaging/domain/models/fcm_message.dart';

FcmMessage fcmMessageFromRemoteMessage(RemoteMessage message) {
  return FcmMessage(
    messageId: message.messageId,
    title: message.notification?.title,
    data: message.data,
  );
}
