enum CallStatus { ringing, accepted, rejected }

class ActiveCall {
  final int id;
  final String roomId;
  final int callerId;
  final int receiverId;
  final CallStatus status;
  final DateTime startedAt;

  ActiveCall({
    required this.id,
    required this.roomId,
    required this.callerId,
    required this.receiverId,
    required this.status,
    required this.startedAt,
  });

  // JSON'dan modele
  factory ActiveCall.fromJson(Map<String, dynamic> json) {
    return ActiveCall(
      id: json['id'] as int,
      roomId: json['roomId'] is String ? json['roomId'] : "",
      callerId: json['callerId'] as int,
      receiverId: json['receiverId'] as int,
      status: callStatusFromString(json['status'] as String),
      startedAt: DateTime.parse(json['startedAt'] as String),
    );
  }

  // Modelden JSON'a
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'roomId': roomId,
      'callerId': callerId,
      'receiverId': receiverId,
      'status': _callStatusToString(status),
      'startedAt': startedAt.toIso8601String(),
    };
  }

  // Enum string dönüşümleri
  static CallStatus callStatusFromString(String status) {
    switch (status) {
      case 'ringing':
        return CallStatus.ringing;
      case 'accepted':
        return CallStatus.accepted;
      case 'rejected':
        return CallStatus.rejected;
      default:
        return CallStatus.ringing; // default fallback
    }
  }

  static String _callStatusToString(CallStatus status) {
    switch (status) {
      case CallStatus.ringing:
        return 'ringing';
      case CallStatus.accepted:
        return 'accepted';
      case CallStatus.rejected:
        return 'rejected';
    }
  }
}
