/// Domain model representing the subset of an FCM message your app cares about.
class FcmMessage {
  const FcmMessage({required this.messageId, this.title, required this.data});

  final String? messageId;
  final String? title;
  final Map<String, dynamic> data;
}
