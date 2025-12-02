import 'package:flutter/material.dart';
import 'package:signalr_netcore/signalr_client.dart';
import 'package:synex/models/Calls/caller_model.dart';
import 'package:synex/network/base_api_service.dart';

class ActiveCallsHub with ChangeNotifier {
  final String hubUrl = "${BaseApiService.baseUrl}webrtcHub";
  late HubConnection hubConnection;

  final int userId;

  dynamic callerModelData;

  ActiveCallsHub(this.userId) {
    initSignalR();
  }

  Future<void> initSignalR() async {
    hubConnection = HubConnectionBuilder()
        .withUrl(hubUrl, transportType: HttpTransportType.WebSockets)
        .build();
    print("ActiveCallsHub SignalR bağlantısı açıldı.");

    await hubConnection.start();

    await hubConnection.invoke("JoinActiveCallsHub", args: [userId]);

    print("ActiveCalls hub açıldı ve joinlendi $userId");

    hubConnection.on("IncomingCall", (data) {
      try {
        if (data != null) {
          if (data[0] == null) {
            callerModelData = "delete";
            notifyListeners();
          } else {
            CallerModel callerModel =
                CallerModel.fromJson(data[0] as Map<String, dynamic>);

            callerModelData = callerModel;
            notifyListeners();
          }
        }
      } catch (e) {
        print(
            "HATA | ActiveCallsHub | initSignalR | IncomingCall | TRY-CATCH | Hata: $e");
      }
    });
  }

  Future<void> stopConnection() async {
    try {
      if (hubConnection.state == HubConnectionState.Disconnected) {
        return;
      }
      await hubConnection.invoke("LeaveActiveCallsHub", args: [userId]);
      await hubConnection.stop();
      print('ActiveCallsHub - SignalR bağlantısı kapandı.');
    } catch (e) {
      print("ActiveCallsHub - SignalR kapatma hatası.. $e");
    }
  }

  Future<void> cancelRinging(String roomId) async {
    try {
      if (hubConnection.state == HubConnectionState.Disconnected) {
        return;
      }
      await hubConnection.invoke("LeaveRoom", args: [roomId]);
      print('ActiveCallsHub - Arama reddedildi.');
    } catch (e) {
      print("ActiveCallsHub - SignalR arama reddetme hatası.. $e");
    }
  }
}
