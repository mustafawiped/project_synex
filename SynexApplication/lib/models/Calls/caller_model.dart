import 'package:synex/models/Calls/active_call_model.dart';

class CallerModel {
  final String callerUsername;
  final String callerPhotoUrl;
  final ActiveCall call;

  CallerModel({
    required this.callerUsername,
    required this.callerPhotoUrl,
    required this.call,
  });

  factory CallerModel.fromJson(Map<String, dynamic> json) {
    return CallerModel(
      callerUsername: json['callerUsername'] as String,
      callerPhotoUrl: json['callerPhoto'] as String,
      call: ActiveCall.fromJson(json['call'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'callerUsername': callerUsername,
      'callerPhotoUrl': callerPhotoUrl,
      'call': call.toJson(),
    };
  }
}
