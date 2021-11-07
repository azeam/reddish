class LoginResponse {
  String userId;
  String token;

  LoginResponse({required this.userId, required this.token});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(userId: json['_userId'], token: json['token']);
  }
}
