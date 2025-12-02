import 'dart:convert';

import 'package:synex/models/Calls/caller_model.dart';
import 'package:synex/network/network_api_service.dart';

class CallsRepo {
  final NetworkApiService apiService = NetworkApiService();

  Future<CallerModel?> getCall(int userId) async {
    try {
      var response =
          await apiService.getResponse("ActiveCalls/getCalls/$userId");

      if (response[0]) {
        var data = jsonDecode(response[1]);
        return CallerModel.fromJson(data);
      } else {
        return null;
      }
    } catch (e) {
      print("CallsRepo || getCall || TRY-CATCH || Hata: $e");
      return null;
    }
  }

  Future<List<CallerModel>?> getCallHistory(int userId) async {
    try {
      var response =
          await apiService.getResponse("ActiveCalls/getCallHistory/$userId");

      if (response[0]) {
        var dataList = jsonDecode(response[1]);

        List<CallerModel> callerList = [];

        for (var data in dataList) {
          callerList.add(CallerModel.fromJson(data));
        }
        return callerList;
      } else {
        return null;
      }
    } catch (e) {
      print("CallsRepo || getCallHistory || TRY-CATCH || Hata: $e");
      return null;
    }
  }
}
