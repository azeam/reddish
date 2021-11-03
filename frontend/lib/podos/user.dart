class User {
  String username = "";
  String password = "";
  User({username, password});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(username: json['username'], password: json['password']);
  }

  Map<String, String> toJson() =>
      {"username": this.username, "password": this.password};
}
