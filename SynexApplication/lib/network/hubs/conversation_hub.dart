import 'package:flutter/material.dart';
import 'package:signalr_netcore/signalr_client.dart';
import 'package:synex/models/Conversations/conversation_dto_model.dart';
import 'package:synex/network/base_api_service.dart';

class ConversationHub with ChangeNotifier {
  final String hubUrl = "${BaseApiService.baseUrl}conversationhub";
  late HubConnection hubConnection;

  final int userId;

  ConversationDtoModel? newConversationData;

  ConversationHub(this.userId) {
    initSignalR();
  }

  Future<void> initSignalR() async {
    hubConnection = HubConnectionBuilder()
        .withUrl(hubUrl, transportType: HttpTransportType.WebSockets)
        .build();
    print("ConversationHub SignalR bağlantısı açıldı.");

    await hubConnection.start();

    await hubConnection.invoke("JoinConversation", args: [userId]);

    hubConnection.on("ConversationUpdated", (data) {
      try {
        if (data != null) {
          ConversationDtoModel conversationDto =
              ConversationDtoModel.fromJson(data[0] as Map<String, dynamic>);

          newConversationData = conversationDto;
          notifyListeners();
        }
      } catch (e) {
        print(
            "HATA | ConversationHub | initSignalR | ConversationUpdated | TRY-CATCH | Hata: $e");
      }
    });
  }

  Future<void> stopConnection() async {
    try {
      if (hubConnection.state == HubConnectionState.Disconnected) {
        return;
      }
      await hubConnection.invoke("LeaveConversation", args: [userId]);
      await hubConnection.stop();
      print('ConversationHub - SignalR bağlantısı kapandı.');
    } catch (e) {
      print("ConversationHub - SignalR kapatma hatası.. $e");
    }
  }
}
