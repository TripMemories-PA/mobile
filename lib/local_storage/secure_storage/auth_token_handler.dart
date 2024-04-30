import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../local_storage/theme_handler.dart';

class AuthTokenHandler {
  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  Future<void> logout() async {
    await _storage.delete(key: 'authToken');
    ThemeHandler().deleteTheme();
  }

  Future<void> saveToken(String token) async {
    await _storage.write(
      key: 'authToken',
      value: token,
    );
  }

  Future<String?> getAuthToken() async {
    return _storage.read(key: 'authToken');
  }
}
