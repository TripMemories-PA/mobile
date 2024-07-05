import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../local_storage/login_handler.dart';
import '../local_storage/theme_handler.dart';

class AuthTokenHandler {
  final StayLoggedInHandler _stayLoggedInHandler = StayLoggedInHandler();
  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  Future<void> logout() async {
    await _storage.delete(key: 'authToken');
    ThemeHandler().deleteTheme();
    _stayLoggedInHandler.deleteLoginPref();
  }

  Future<void> saveToken(String token, stayLoggedIn) async {
    await _storage.write(
      key: 'authToken',
      value: token,
    );
    _stayLoggedInHandler.saveLoginPref(stayLoggedIn);
  }

  Future<String?> getAuthToken() async {
    return _storage.read(key: 'authToken');
  }
}
