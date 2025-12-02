import 'dart:convert';

class StoryModel {
  int id;
  int? userId;
  String content;
  String contentMsg;
  List<int> seenBy;
  DateTime createdAt;

  StoryModel({
    required this.id,
    required this.userId,
    required this.content,
    required this.contentMsg,
    required this.seenBy,
    required this.createdAt,
  });

  factory StoryModel.fromJson(Map<String, dynamic> json) {
    return StoryModel(
      id: json['id'],
      userId: json['userId'],
      content: json['content'],
      contentMsg: json['contentMsg'],
      seenBy: List<int>.from(json['seenBy'] ?? []),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'content': content,
        'contentMsg': contentMsg,
        'seenBy': seenBy,
        'createdAt': createdAt.toIso8601String(),
      };

  static StoryModel fromJsonString(String jsonString) =>
      StoryModel.fromJson(json.decode(jsonString));

  String toJsonString() => json.encode(toJson());
}
