import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'base_api_service.dart';

class NetworkApiService extends BaseApiService {
  @override
  Future getResponse(
    String url,
  ) async {
    try {
      final response =
          await http.get(Uri.parse(BaseApiService.baseApiUrl + url));
      dynamic responseJson = returnResponse(response);
      return responseJson;
    } on SocketException {
      return [false, "bir hata meydana geldi."];
    }
  }

  @override
  Future deleteResponse(
    String url,
  ) async {
    try {
      final response =
          await http.delete(Uri.parse(BaseApiService.baseApiUrl + url));
      dynamic responseJson = returnResponse(response);
      return responseJson;
    } on SocketException {
      return [false, "bir hata meydana geldi."];
    }
  }

  @override
  Future postResponse(
    String url,
    Map<String, dynamic> body,
  ) async {
    dynamic responseJson;
    try {
      final response = await http.post(
        Uri.parse(BaseApiService.baseApiUrl + url),
        body: json.encode(body),
        headers: {'Content-Type': 'application/json'},
      );
      responseJson = returnResponse(response);
      return responseJson;
    } on SocketException {
      return "Hata! SocketException";
    }
  }

  @override
  Future postPhotoResponse(String url, String photoPath, String username,
      {bool isUrl = false}) async {
    try {
      var request = http.MultipartRequest(
          "POST", Uri.parse(BaseApiService.baseApiUrl + url));

      request.fields['username'] = username;

      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          photoPath,
        ),
      );

      http.StreamedResponse responseJson = await request.send();

      if (isUrl) {
        final responseString = await responseJson.stream.bytesToString();

        final response = jsonDecode(responseString);

        return response['url'];
      }

      return responseJson.statusCode < 300;
    } on SocketException {
      print("ApiError: postPhotoResponse, socketException");
      return false;
    }
  }

  dynamic returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
      case 400:
      case 401:
      case 404:
      case 500:
        return [response.statusCode < 300, response.body];
      default:
        if (kDebugMode) {
          print("ApiErrorCode: ${response.statusCode}");
          print("ApiError: ${response.body}");
        }
        return false;
    }
  }
}
