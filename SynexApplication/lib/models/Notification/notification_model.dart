class PushNotification {
  final String deviceToken;
  final String title;
  final String body;
  final int conversationId;
  final String type;

  PushNotification({
    required this.deviceToken,
    required this.title,
    required this.body,
    required this.conversationId,
    required this.type,
  });

  factory PushNotification.fromJson(Map<String, dynamic> json) {
    return PushNotification(
      deviceToken: json['deviceToken'],
      title: json['title'],
      body: json['body'],
      conversationId: json['conversationId'],
      type: json['type'],
    );
  }

  // Dart nesnesini JSON'a çevirme
  Map<String, dynamic> toJson() {
    return {
      'deviceToken': deviceToken,
      'title': title,
      'body': body,
      'conversationId': conversationId,
      'type': type,
    };
  }
}
