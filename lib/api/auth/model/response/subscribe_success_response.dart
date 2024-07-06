class SubscribeSuccessResponse {
  SubscribeSuccessResponse({
    required this.username,
    required this.email,
    required this.firstname,
    required this.lastname,
    required this.id,
  });

  factory SubscribeSuccessResponse.fromJson(Map<String, dynamic> json) {
    return SubscribeSuccessResponse(
      username: json['username'],
      email: json['email'],
      firstname: json['firstname'],
      lastname: json['lastname'],
      id: json['id'],
    );
  }

  String username;
  String email;
  String firstname;
  String lastname;
  int id;
}
