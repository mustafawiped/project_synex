class ConversationModel {
  final int id;
  final int user1Id;
  final int user2Id;
  final int? lastMessageId;
  final DateTime? updatedAt;
  final int unreadCountUser1;
  final int unreadCountUser2;

  ConversationModel({
    required this.id,
    required this.user1Id,
    required this.user2Id,
    this.lastMessageId,
    this.updatedAt,
    this.unreadCountUser1 = 0,
    this.unreadCountUser2 = 0,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(
      id: json['id'] as int,
      user1Id: json['user1Id'] as int,
      user2Id: json['user2Id'] as int,
      lastMessageId:
          json['lastMessageId'] != null ? json['lastMessageId'] as int : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      unreadCountUser1: json['unreadCountUser1'] != null
          ? json['unreadCountUser1'] as int
          : 0,
      unreadCountUser2: json['unreadCountUser2'] != null
          ? json['unreadCountUser2'] as int
          : 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user1Id': user1Id,
      'user2Id': user2Id,
      'lastMessageId': lastMessageId,
      'updatedAt': updatedAt?.toIso8601String(),
      'unreadCountUser1': unreadCountUser1,
      'unreadCountUser2': unreadCountUser2,
    };
  }
}
