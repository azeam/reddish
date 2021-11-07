class User {
  String id;
  String username;
  String password;

  User({this.id = "", required this.username, required this.password});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['_id'],
        username: json['username'],
        password: json['password']);
  }

  Map<String, dynamic> toJson() =>
      {"id": this.id, "username": this.username, "password": this.password};
}
