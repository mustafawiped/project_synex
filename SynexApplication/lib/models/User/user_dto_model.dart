class UserDtoModel {
  final int id;
  final String username;
  final String? photo;

  UserDtoModel({
    required this.id,
    required this.username,
    this.photo,
  });

  factory UserDtoModel.fromJson(Map<String, dynamic> json) {
    return UserDtoModel(
      id: json['id'] as int,
      username: json['username'] as String,
      photo: json['photo'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'photo': photo,
    };
  }
}
