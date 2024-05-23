class SubscribeModel {
  static Map<String, dynamic> createJson({
    required String firstName,
    required String lastName,
    required String username,
    required String email,
    required String password,
  }) {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'username': username,
      'email': email,
      'password': password,
    };
  }
}
