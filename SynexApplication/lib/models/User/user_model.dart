class UserModel {
  final int id;
  final String username;
  final String email;
  final String password;
  final String? about;
  final String? title;
  final String? photo;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.password,
    this.about,
    this.title,
    this.photo,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      username: json['username'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      about: json['about'] as String?,
      title: json['title'] as String?,
      photo: json['photo'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'password': password,
      'about': about,
      'title': title,
      'photo': photo,
    };
  }
}
