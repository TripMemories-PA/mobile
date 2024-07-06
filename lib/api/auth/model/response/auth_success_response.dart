class AuthSuccessResponse {
  AuthSuccessResponse({
    required this.type,
    required this.token,
  });

  factory AuthSuccessResponse.fromJson(Map<String, dynamic> json) {
    return AuthSuccessResponse(
      type: json['type'],
      token: json['token'],
    );
  }

  String type;
  String token;
}
