import 'package:synex/network/network_api_service.dart';

class UserUpdateRepo {
  final NetworkApiService apiService = NetworkApiService();

  Future<List> loginUser(String username, String password) async {
    try {
      return await apiService.postResponse(
          "Users/auth", {"username": username, "password": password});
    } catch (e) {
      print("UserRepo || createUser || TRY-CATCH || Hata: $e");
      return [false, "Bilinmeyen bir hata oluştu, lütfen tekrar deneyin."];
    }
  }

  Future<bool> updateProfilePhoto(String username, String photoUrl) async {
    try {
      String uri = "users/change-photo";

      var response = await apiService
          .postResponse(uri, {"username": username, "photoUrl": photoUrl});

      return response[0];
    } catch (e) {
      print("UserUpdateRepo || updateProfilePhoto || TRY-CATCH || Error: $e");
      return false;
    }
  }

  Future<dynamic> updateBio(
      String username, String type, String newValue) async {
    try {
      String uri = "users/change-$type";

      return await apiService
          .postResponse(uri, {"username": username, type: newValue});
    } catch (e) {
      print("UserUpdateRepo || updateBio || TRY-CATCH || Error: $e");
      return "Bir şeyler ters gitti, işlem başarısız.";
    }
  }
}
