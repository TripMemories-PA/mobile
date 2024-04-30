class SubscribeModel {
  static Map<String, dynamic> createJson({
    required String username,
    required String email,
    required String password,
    required String confirmPassword,
  }) {
    return {
      'username': username,
      'email': email,
      'password': password,
      'password_confirmation': confirmPassword,
    };
  }
}
