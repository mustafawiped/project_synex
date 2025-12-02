import 'dart:async';

import 'package:flutter/material.dart';
import 'package:synex/network/hubs/webrtc_hub.dart';

class VoiceChatPageViewModel with ChangeNotifier {
  late WebRTCService webRTCService;
  int userCount = 0;

  VoiceChatPageViewModel() {
    webRTCService = WebRTCService();
  }

  Future<void> initComps(String roomId, VoidCallback onCallEndedCallback,
      int thisUserId, int otherUserId) async {
    webRTCService.thisUserId = thisUserId;
    webRTCService.otherUserId = otherUserId;
    // YENİ: Başka bir kullanıcı katıldığında zamanlayıcıyı başlatır
    webRTCService.onUserJoined = (userId) {
      ++userCount;
      notifyListeners();
    };

    webRTCService.onUserLeft = (userId) {
      userCount = 0;
      notifyListeners();
    };

    webRTCService.onCallEnded = onCallEndedCallback;
    await webRTCService.init(roomId);
  }

  @override
  void dispose() {
    webRTCService.leaveRoom("");
    super.dispose();
  }
}
