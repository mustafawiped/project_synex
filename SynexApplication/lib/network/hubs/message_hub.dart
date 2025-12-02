import 'package:flutter/material.dart';
import 'package:signalr_netcore/signalr_client.dart';
import 'package:synex/network/base_api_service.dart';
import '../../models/Message/message_model.dart';

class MessageHub with ChangeNotifier {
  final String hubUrl = "${BaseApiService.baseUrl}chathub";
  late HubConnection hubConnection;

  MessageModel? newMessage;
  Map<String, dynamic>? seenData;
  int? deleteMsgId;

  final int thisUser;
  final int otherUser;
  final int conversationId;

  MessageHub(this.thisUser, this.otherUser, this.conversationId) {
    initSignalR(thisUser, otherUser);
  }

  Future<void> initSignalR(int thisUser, int otherUser) async {
    hubConnection = HubConnectionBuilder()
        .withUrl(hubUrl, transportType: HttpTransportType.WebSockets)
        .build();
    print("SignalR bağlantısı açıldı.");

    await hubConnection.start();

    await hubConnection.invoke("JoinConversation", args: [conversationId]);

    hubConnection.on("ReceiveMessage", (message) {
      try {
        if (message != null && message.isNotEmpty) {
          final msg = MessageModel.fromJson(message[0] as Map<String, dynamic>);
          if ((msg.senderId == thisUser && msg.receiverId == otherUser) ||
              (msg.senderId == otherUser && msg.receiverId == thisUser)) {
            newMessage = msg;
            notifyListeners();
          }
        }
      } catch (e) {
        print("HATA | MessageHub | initSignalR | TRY-CATCH | Hata: $e");
      }
    });

    hubConnection.on("MessageSeen", (data) {
      try {
        if (data != null && data.isNotEmpty) {
          seenData = data[0] as Map<String, dynamic>;
          notifyListeners();
        }
      } catch (e) {
        print(
            "HATA | MessageHub | initSignalR | MessageSeen TRY-CATCH | Hata: $e");
      }
    });

    hubConnection.on("MessageDeleted", (data) {
      try {
        if (data != null && data.isNotEmpty) {
          deleteMsgId = data[0] as int;
          notifyListeners();
        }
      } catch (e) {
        print(
            "HATA | MessageHub | initSignalR | MessageDeleted TRY-CATCH | Hata: $e");
      }
    });
  }

  Future<void> ensureConnected(int thisUser, int otherUser) async {
    if (hubConnection.state == HubConnectionState.Disconnected) {
      print("Bağlantı kopuk, yeniden bağlanılıyor...");
      await initSignalR(thisUser, otherUser);
    } else {
      print("bana açık dendi");
    }
  }

  void seenMessage(MessageModel message, int userId) async {
    if (hubConnection.state == HubConnectionState.Connected) {
      await hubConnection.invoke("SeenMessage", args: [message.id, userId]);
      notifyListeners();
    }
  }

  void sendMessage(MessageModel message) async {
    if (hubConnection.state == HubConnectionState.Connected) {
      await ensureConnected(message.senderId, message.receiverId);
      await hubConnection.invoke("SendMessage", args: [message.toJson()]);
      notifyListeners();
    }
  }

  void deleteMessage(MessageModel message) async {
    if (hubConnection.state == HubConnectionState.Connected) {
      await ensureConnected(message.senderId, message.receiverId);
      await hubConnection
          .invoke("MessageDeleted", args: [message.id, message.senderId]);
      notifyListeners();
    }
  }

  Future<void> stopConnection() async {
    try {
      await hubConnection.invoke("LeaveConversation", args: [conversationId]);
      await hubConnection.stop();
      print('SignalR bağlantısı kapandı.');
    } catch (e) {
      print("SignalR kapatma hatası.. $e");
    }
  }
}
