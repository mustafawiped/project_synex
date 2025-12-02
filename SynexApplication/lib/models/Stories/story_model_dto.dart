import 'dart:convert';

import 'package:synex/models/Stories/story_model.dart';

class StoryModelDto {
  int userId;
  String username;
  String photoUrl;
  List<StoryModel> storys;

  StoryModelDto({
    required this.userId,
    required this.username,
    required this.photoUrl,
    required this.storys,
  });

  factory StoryModelDto.fromJson(Map<String, dynamic> json) {
    print("sasdaf");
    return StoryModelDto(
      userId: json['userId'],
      username: json['username'],
      photoUrl: json['photoUrl'],
      storys: (json['storys'] as List<dynamic>)
          .map((e) => StoryModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'username': username,
        'photoUrl': photoUrl,
        'storys': storys.map((e) => e.toJson()).toList(),
      };

  static List<StoryModelDto> listFromJson(String str) =>
      List<StoryModelDto>.from(
          json.decode(str).map((x) => StoryModelDto.fromJson(x)));

  DateTime? get latestCreatedAt =>
      storys.isNotEmpty ? storys.first.createdAt : null;
}
