class LoginModel {
  static Map<String, dynamic> createJson({
    required String email,
    required String password,
  }) {
    return {
      'email': email,
      'password': password,
    };
  }
}
