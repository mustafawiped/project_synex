import 'dart:convert';
import 'package:synex/models/Message/message_model.dart';
import 'package:synex/network/network_api_service.dart';

class MessageRepo {
  final NetworkApiService apiService = NetworkApiService();

  Future<List<MessageModel>?> getChatMessages(int conversationId) async {
    try {
      var response = await apiService.getResponse(
        "messages/conversation/$conversationId",
      );

      if (response[0]) {
        List<dynamic> data = jsonDecode(response[1]);

        List<MessageModel> list = [];

        for (var variable in data) {
          list.add(MessageModel.fromJson(variable));
        }

        return list;
      } else {
        return null;
      }
    } catch (e) {
      print("UserRepo || createUser || TRY-CATCH || Hata: $e");
      return null;
    }
  }

  Future<String?> uploadPhoto(String path) async {
    try {
      String uri = "messages/upload-image";

      dynamic response = await apiService
          .postPhotoResponse(uri, path, "ASDASDSA", isUrl: true);

      if (response is bool) {
        return null;
      } else {
        return response;
      }
    } catch (e) {
      print("UserUpdateRepo || updateProfilePhoto || TRY-CATCH || Error: $e");
      return null;
    }
  }
}
