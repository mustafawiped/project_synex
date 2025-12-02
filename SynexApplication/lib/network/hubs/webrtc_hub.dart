// ignore_for_file: unnecessary_null_comparison

import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:signalr_netcore/signalr_client.dart';
import 'package:synex/network/base_api_service.dart';

class WebRTCService {
  late HubConnection hubConnection;
  RTCPeerConnection? peerConnection;
  MediaStream? localStream;
  Function(MediaStream)? onRemoteStream;
  Function(bool)? onConnectionStatus;
  Function(String)? onUserJoined;
  Function(String)? onUserLeft;
  Function()? onCallEnded; // Yeni geri çağrı
  int? thisUserId;
  int? otherUserId;

  bool _isConnected = false;
  bool get isConnected => _isConnected;
  set isConnected(bool value) {
    _isConnected = value;
    onConnectionStatus?.call(value);
  }

  Future<void> init(String roomId) async {
    // Hub bağlantısını kur
    hubConnection = HubConnectionBuilder()
        .withUrl("${BaseApiService.baseUrl}webrtcHub")
        .build();

    // Hub olaylarını dinle
    hubConnection.on("UserJoined", (arguments) {
      final userId = arguments![0] as String;
      print("Kullanıcı Odaya Katıldı: $userId");
      onUserJoined?.call(userId);
      // Yeni kullanıcı katıldığında bir teklif oluştur ve gönder
      _createOfferAndSendSignal(roomId);
    });

    hubConnection.on("UserLeft", (arguments) {
      final userId = arguments![0] as String;
      print("Kullanıcı Odadan Ayrıldı: $userId");
      onUserLeft?.call(userId);
      onCallEnded?.call(); // Çağrı sonlandırma geri çağrısı
    });

    hubConnection.on("SignalReceived", (arguments) async {
      final signal = arguments![0] as Map<String, dynamic>;
      print("Sinyal Alındı: ${signal['type']}");
      await _handleSignal(signal, roomId);
    });

    try {
      await hubConnection.start();
      print("SignalR bağlantısı başarılı.");
      isConnected = true;
      await joinRoom(roomId);
    } catch (e) {
      print("SignalR bağlantı hatası: $e");
      isConnected = false;
    }
  }

  Future<void> joinRoom(String roomId) async {
    if (hubConnection.state == HubConnectionState.Connected) {
      await hubConnection
          .invoke("JoinRoom", args: [roomId, thisUserId!, otherUserId!]);
      print("Odaya Katıldı: $roomId");
      // Yerel akışı al ve PeerConnection'ı kur
      await _getMediaStream();
      await _createPeerConnection(roomId);
    }
  }

  Future<void> leaveRoom(String roomId) async {
    if (hubConnection.state == HubConnectionState.Connected) {
      await hubConnection.invoke("LeaveRoom", args: [roomId]);
      print("Odadan Ayrıldı: $roomId");
    }
    _disconnect();
  }

  Future<void> sendSignal(String roomId, dynamic signal) async {
    if (hubConnection.state == HubConnectionState.Connected) {
      await hubConnection.invoke("SendSignal", args: [roomId, signal]);
      print("Sinyal Gönderildi: ${signal['type']}");
    }
  }

  Future<void> _getMediaStream() async {
    final Map<String, dynamic> mediaConstraints = {
      'audio': true,
      'video': false,
    };
    localStream = await navigator.mediaDevices.getUserMedia(mediaConstraints);
  }

  Future<void> _createPeerConnection(String roomId) async {
    final Map<String, dynamic> configuration = {
      'iceServers': [
        {'urls': 'stun:stun.l.google.com:19302'},
      ]
    };

    final Map<String, dynamic> offerSdpConstraints = {
      'mandatory': {
        'OfferToReceiveAudio': true,
        'OfferToReceiveVideo': false,
      },
    };

    peerConnection =
        await createPeerConnection(configuration, offerSdpConstraints);

    // Peer'ın yerel akışı almasına izin ver
    localStream?.getTracks().forEach((track) {
      peerConnection?.addTrack(track, localStream!);
    });

    // ICE adaylarını (candidate) dinle ve hub üzerinden gönder
    peerConnection?.onIceCandidate = (RTCIceCandidate candidate) {
      sendSignal(roomId, {'candidate': candidate.toMap(), 'type': 'candidate'});
    };

    // Peer tarafından eklenen uzaktan akışı dinle
    peerConnection?.onTrack = (RTCTrackEvent event) {
      print('Uzak akış alındı');
      onRemoteStream?.call(event.streams[0]);
    };
  }

  Future<void> _handleSignal(Map<String, dynamic> signal, String roomId) async {
    if (signal['type'] == 'offer') {
      if (peerConnection == null) {
        print(
            "Hata: peerConnection henüz oluşturulmadı. Cevap oluşturulamıyor.");
        return;
      }
      await peerConnection!.setRemoteDescription(
          RTCSessionDescription(signal['sdp'], signal['type']));
      final answer = await peerConnection!.createAnswer();
      if (answer == null) {
        print("Hata: Cevap oluşturulamadı.");
        return;
      }
      await peerConnection!.setLocalDescription(answer);
      sendSignal(roomId, {'sdp': answer.sdp, 'type': answer.type});
    } else if (signal['type'] == 'answer') {
      await peerConnection?.setRemoteDescription(
          RTCSessionDescription(signal['sdp'], signal['type']));
    } else if (signal['type'] == 'candidate') {
      await peerConnection?.addCandidate(RTCIceCandidate(
        signal['candidate']['candidate'],
        signal['candidate']['sdpMid'],
        signal['candidate']['sdpMLineIndex'],
      ));
    }
  }

  Future<void> _createOfferAndSendSignal(String roomId) async {
    if (peerConnection == null) {
      print(
          "Hata: peerConnection henüz oluşturulmadı. Teklif oluşturulamıyor.");
      return;
    }
    final offer = await peerConnection!.createOffer();
    if (offer == null) {
      print("Hata: Teklif oluşturulamadı.");
      return;
    }
    await peerConnection!.setLocalDescription(offer);
    await sendSignal(roomId, {'sdp': offer.sdp, 'type': offer.type});
  }

  void _disconnect() {
    // ignore: deprecated_member_use
    localStream?.getTracks().forEach((track) => track.dispose());
    localStream?.dispose();
    peerConnection?.dispose();
    hubConnection.stop();
  }
}
