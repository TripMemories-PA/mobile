class SubscribeModel {
  static Map<String, dynamic> createJson({
    required String username,
    required String email,
    required String password,
  }) {
    return {
      'name': username,
      'email': email,
      'password': password,
    };
  }
}
