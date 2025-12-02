abstract class BaseApiService {
  static const baseUrl = "http://192.168.218.167:5010/";
  static const baseApiUrl = "http://192.168.218.167:5010/api/";

  Future<dynamic> getResponse(String url);

  Future<dynamic> postResponse(String url, Map<String, dynamic> body);

  Future postPhotoResponse(String url, String photoPath, String username);

  Future deleteResponse(String url);
}
