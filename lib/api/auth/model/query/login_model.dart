class LoginModel {
  static Map<String, dynamic> createJson({
    required String email,
    required String password,
  }) {
    return {
      'login': email,
      'password': password,
    };
  }
}
