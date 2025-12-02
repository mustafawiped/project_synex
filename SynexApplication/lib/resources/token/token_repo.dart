import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:synex/models/Token/token_model.dart';
import 'package:synex/network/network_api_service.dart';

class TokenRepo {
  final NetworkApiService apiService = NetworkApiService();

  Future<bool> registerToken(String username) async {
    try {
      FirebaseMessaging messaging = FirebaseMessaging.instance;

      // Kullanıcıdan izin isteme (iOS için gerekli)
      NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        String? token = await messaging.getToken();

        if (token == null) return false;

        var response = await apiService.postResponse("DeviceToken/register",
            {"username": username, "clientToken": token});

        if (response[0]) {
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      print(
          "ConversationRepo || getOrCreateConversations || TRY-CATCH || Hata: $e");
      return false;
    }
  }

  Future<List<DeviceToken>?> getTokens(int userID) async {
    try {
      var response = await apiService.getResponse("DeviceToken/user/$userID");

      if (response[0]) {
        var dataList = jsonDecode(response[1]);

        List<DeviceToken> tokenList = [];

        for (var data in dataList) {
          tokenList.add(DeviceToken.fromJson(data));
        }
        return tokenList;
      } else {
        return null;
      }
    } catch (e) {
      print("TokenRepo || getTokens || TRY-CATCH || Hata: $e");
      return null;
    }
  }

  Future<bool> deleteTokens(int userID) async {
    try {
      var response = await apiService.getResponse("DeviceToken/user/$userID");

      if (response[0]) {
        var dataList = jsonDecode(response[1]);

        return dataList["message"] == "Tokenlar silindi.";
      } else {
        return false;
      }
    } catch (e) {
      print("TokenRepo || getTokens || TRY-CATCH || Hata: $e");
      return false;
    }
  }
}
