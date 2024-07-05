import 'package:shared_preferences/shared_preferences.dart';

class StayLoggedInHandler {
  Future<void> deleteLoginPref() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('stayLoggedIn');
  }

  Future<void> saveLoginPref(bool stayLoggedIn) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('stayLoggedIn', stayLoggedIn);
  }

  Future<bool?> getLoginPref() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getBool('stayLoggedIn');
  }
}
