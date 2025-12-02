import 'dart:convert';
import 'package:synex/models/User/user_model.dart';
import 'package:synex/network/network_api_service.dart';

class UserRepo {
  final NetworkApiService apiService = NetworkApiService();

  Future<List> createUser(UserModel user) async {
    try {
      Map<String, dynamic> userMap = user.toJson();
      userMap["photo"] = "http://192.168.1.115:5010/user.png";
      dynamic response = await apiService.postResponse("Users", userMap);

      if (response[0]) {
        return [true, "Başarıyla hesap oluşturuldu!"];
      }

      return [false, response[1].toString()];
    } catch (e) {
      print("UserRepo || createUser || TRY-CATCH || Hata: $e");
      return [false, "Bilinmeyen bir hata oluştu, lütfen tekrar deneyin."];
    }
  }

  Future<List> loginUser(String username, String password) async {
    try {
      return await apiService.postResponse(
          "users/auth", {"username": username, "password": password});
    } catch (e) {
      print("UserRepo || createUser || TRY-CATCH || Hata: $e");
      return [false, "Bilinmeyen bir hata oluştu, lütfen tekrar deneyin."];
    }
  }

  Future<UserModel?> getUserData(String username) async {
    try {
      String url = "users/get-user/$username";
      var response = await apiService.getResponse(url);

      if (!response[0]) {
        print("UserRepo || getUserData || Method || Hata: ${response[1]}");
        return null;
      }

      Map<String, dynamic> data = jsonDecode(response[1]);

      return UserModel.fromJson(data);
    } catch (e) {
      print("UserRepo || getUserData || TRY-CATCH || Hata: $e");
      return null;
    }
  }

  Future<List<UserModel>?> getAllUser(String username) async {
    try {
      String url = "users/get-all-user/$username";
      var response = await apiService.getResponse(url);

      if (!response[0]) {
        print("UserRepo || getAllUser || Method || Hata: ${response[1]}");
        return null;
      }

      List<dynamic> dataList = jsonDecode(response[1]);

      List<UserModel> userList = [];

      for (var data in dataList) {
        userList.add(UserModel.fromJson(data));
      }

      return userList;
    } catch (e) {
      print("UserRepo || getAllUser || TRY-CATCH || Hata: $e");
      return null;
    }
  }
}
