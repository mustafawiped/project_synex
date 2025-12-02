import 'dart:convert';

import 'package:synex/models/Conversations/conversation_dto_model.dart';
import 'package:synex/models/Conversations/conversation_model.dart';
import 'package:synex/network/network_api_service.dart';

class ConversationRepo {
  final NetworkApiService apiService = NetworkApiService();

  Future<ConversationModel?> getOrCreateConversations(
      int user1Id, int user2Id) async {
    try {
      var response = await apiService.postResponse(
          "conversations/get-or-create?user1Id=$user1Id&user2Id=$user2Id", {});

      if (response[0]) {
        var data = jsonDecode(response[1]);
        return ConversationModel.fromJson(data);
      } else {
        return null;
      }
    } catch (e) {
      print(
          "ConversationRepo || getOrCreateConversations || TRY-CATCH || Hata: $e");
      return null;
    }
  }

  Future<List<ConversationDtoModel>?> getAllConversations(int user1Id) async {
    try {
      var response =
          await apiService.getResponse("conversations/user/$user1Id");

      if (response[0]) {
        List<dynamic> resultList = jsonDecode(response[1]);

        List<ConversationDtoModel> dataList = [];
        for (var newData in resultList) {
          dataList.add(ConversationDtoModel.fromJson(newData));
        }

        return dataList;
      } else {
        return null;
      }
    } catch (e) {
      print("ConversationRepo || getAllConversations || TRY-CATCH || Hata: $e");
      return null;
    }
  }
}
