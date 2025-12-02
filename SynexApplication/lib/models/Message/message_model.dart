class MessageModel {
  final int id;
  final int senderId;
  final int receiverId;
  final String content;
  final bool wasItSeen;
  final DateTime createdAt;
  final DateTime? seenAt;
  final int conversationId;
  final MessageType messageType;

  MessageModel({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.content,
    required this.wasItSeen,
    required this.createdAt,
    this.seenAt,
    required this.conversationId,
    required this.messageType,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] as int,
      senderId: json['senderId'] as int,
      receiverId: json['receiverId'] as int,
      content: json['content'] as String,
      wasItSeen: json['wasItSeen'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      seenAt: json['seenAt'] != null
          ? DateTime.parse(json['seenAt'] as String)
          : null,
      conversationId: json['conversationId'] as int,
      messageType: MessageTypeExtension.fromString(json["messageType"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderId': senderId,
      'receiverId': receiverId,
      'content': content,
      'WasItSeen': wasItSeen,
      'createdAt': createdAt.toIso8601String(),
      'seenAt': seenAt?.toIso8601String(),
      'conversationId': conversationId,
      'messageType': messageType.value,
    };
  }

  MessageModel copyWith({
    int? id,
    int? senderId,
    int? receiverId,
    String? content,
    bool? wasItSeen,
    DateTime? createdAt,
    DateTime? seenAt,
    int? conversationId,
    MessageType? messageType,
  }) {
    return MessageModel(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      content: content ?? this.content,
      wasItSeen: wasItSeen ?? this.wasItSeen,
      createdAt: createdAt ?? this.createdAt,
      seenAt: seenAt ?? this.seenAt,
      conversationId: conversationId ?? this.conversationId,
      messageType: messageType ?? this.messageType,
    );
  }
}

enum MessageType {
  text,
  image,
}

extension MessageTypeExtension on MessageType {
  String get value {
    switch (this) {
      case MessageType.text:
        return 'text';
      case MessageType.image:
        return 'image';
    }
  }

  static MessageType fromString(String type) {
    switch (type) {
      case 'image':
        return MessageType.image;
      case 'text':
      default:
        return MessageType.text;
    }
  }
}

//   @override
//   String toString() {
//     return 'MessageModel(id: $id, senderId: $senderId, receiverId: $receiverId, content: $content, wasItSeen: $wasItSeen, createdAt: $createdAt, seenAt: $seenAt, conversationId: $conversationId)';
//   }

//   @override
//   bool operator ==(Object other) {
//     if (identical(this, other)) return true;

//     return other is MessageModel &&
//         other.id == id &&
//         other.senderId == senderId &&
//         other.receiverId == receiverId &&
//         other.content == content &&
//         other.wasItSeen == wasItSeen &&
//         other.createdAt == createdAt &&
//         other.seenAt == seenAt &&
//         other.conversationId == conversationId;
//   }

//   @override
//   int get hashCode {
//     return id.hashCode ^
//         senderId.hashCode ^
//         receiverId.hashCode ^
//         content.hashCode ^
//         wasItSeen.hashCode ^
//         createdAt.hashCode ^
//         (seenAt?.hashCode ?? 0) ^
//         conversationId.hashCode;
//   }
// }
