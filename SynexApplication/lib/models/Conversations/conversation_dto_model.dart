import 'package:synex/models/Message/message_model.dart';

class ConversationDtoModel {
  final int id;
  final int user1Id;
  final int user2Id;
  final int? lastMessageId;
  final MessageModel? lastMessage;
  final DateTime? updatedAt;
  final int unreadCountUser1;
  final int unreadCountUser2;
  final String otherUsername;
  final String? otherProfile;

  ConversationDtoModel({
    required this.id,
    required this.user1Id,
    required this.user2Id,
    required this.otherUsername,
    this.otherProfile,
    this.lastMessage,
    this.lastMessageId,
    this.updatedAt,
    this.unreadCountUser1 = 0,
    this.unreadCountUser2 = 0,
  });

  factory ConversationDtoModel.fromJson(Map<String, dynamic> json) {
    return ConversationDtoModel(
      id: json['id'] as int,
      user1Id: json['user1Id'] as int,
      user2Id: json['user2Id'] as int,
      lastMessageId:
          json['lastMessageId'] != null ? json['lastMessageId'] as int : null,
      lastMessage: json['lastMessage'] != null
          ? MessageModel.fromJson(json['lastMessage'])
          : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      unreadCountUser1: json['unreadCountUser1'] != null
          ? json['unreadCountUser1'] as int
          : 0,
      unreadCountUser2: json['unreadCountUser2'] != null
          ? json['unreadCountUser2'] as int
          : 0,
      otherUsername: json["otherUsername"],
      otherProfile: json["otherPhoto"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user1Id': user1Id,
      'user2Id': user2Id,
      'lastMessageId': lastMessageId,
      'lastMessage': lastMessage,
      'updatedAt': updatedAt?.toIso8601String(),
      'unreadCountUser1': unreadCountUser1,
      'unreadCountUser2': unreadCountUser2,
      'otherUsername': otherUsername,
      'otherPhoto': otherProfile
    };
  }
}
