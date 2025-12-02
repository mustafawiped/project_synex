class DeviceToken {
  final int id;
  final int userId;
  final String token;

  DeviceToken({
    required this.id,
    required this.userId,
    required this.token,
  });

  factory DeviceToken.fromJson(Map<String, dynamic> json) {
    return DeviceToken(
      id: json['id'],
      userId: json['userId'],
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'token': token,
    };
  }
}
