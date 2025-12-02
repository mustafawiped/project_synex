import 'dart:convert';

import 'package:synex/models/Stories/story_model.dart';
import 'package:synex/models/Stories/story_model_dto.dart';
import 'package:synex/network/network_api_service.dart';

class StoryRepo {
  final NetworkApiService apiService = NetworkApiService();

  Future<bool> addStory(int userId, String photoUrl, String contentMsg) async {
    try {
      StoryModel newStory = StoryModel(
        id: 0,
        userId: userId,
        content: photoUrl,
        contentMsg: contentMsg,
        seenBy: [],
        createdAt: DateTime.now(),
      );

      List<dynamic> response =
          await apiService.postResponse("Stories/add", newStory.toJson());

      return response[0];
    } catch (e) {
      print("StoryRepo || addStory || TRY-CATCH || Hata: $e");
      return false;
    }
  }

  Future<List<StoryModelDto>?> getAllStory() async {
    try {
      List<dynamic> response =
          await apiService.getResponse("Stories/getAllStories");

      if (response[0]) {
        List<dynamic> dataList = jsonDecode(response[1]);

        List<StoryModelDto> storyList = [];

        for (var data in dataList) {
          storyList.add(StoryModelDto.fromJson(data));
        }

        return storyList;
      } else {
        return null;
      }
    } catch (e) {
      print("StoryRepo || getAllStory || TRY-CATCH || Hata: $e");
      return null;
    }
  }

  Future<bool> deleteStory(int storyId) async {
    try {
      var response =
          await apiService.deleteResponse("Stories/deleteStory/$storyId");

      return response[0];
    } catch (e) {
      print("StoryRepo || deleteStory || TRY-CATCH || Hata: $e");
      return false;
    }
  }

  Future<bool> markStoriesAsSeen(int storyOwnerID, int seeUserId) async {
    try {
      var response = await apiService.postResponse("Stories/markStoriesAsSeen",
          {"storyOwnerId": storyOwnerID, "seeUserId": seeUserId});

      return response[0];
    } catch (e) {
      print("StoryRepo || deleteStory || TRY-CATCH || Hata: $e");
      return false;
    }
  }
}
