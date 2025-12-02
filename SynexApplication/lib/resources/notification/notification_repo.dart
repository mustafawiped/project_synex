import 'package:synex/models/Notification/notification_model.dart';
import 'package:synex/models/Token/token_model.dart';
import 'package:synex/network/network_api_service.dart';
import 'package:synex/resources/token/token_repo.dart';

class NotificationRepo {
  final NetworkApiService apiService = NetworkApiService();

  Future<bool> sendNotification(
      String username, int userId, String text, int conversationId) async {
    try {
      List<DeviceToken> tokens = await TokenRepo().getTokens(userId) ?? [];
      if (tokens.isEmpty) return false;

      for (var token in tokens) {
        PushNotification notification = PushNotification(
            deviceToken: token.token,
            title: username,
            body: text,
            conversationId: conversationId,
            type: "text");

        await apiService.postResponse(
            "Notification/send", notification.toJson());
      }

      return true;
    } catch (e) {
      print(
          "ConversationRepo || getOrCreateConversations || TRY-CATCH || Hata: $e");
      return false;
    }
  }
}
