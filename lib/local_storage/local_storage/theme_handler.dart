import 'package:shared_preferences/shared_preferences.dart';

class ThemeHandler {
  Future<void> deleteTheme() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('theme');
  }

  Future<void> saveTheme(String theme) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme', theme);
  }

  Future<String?> getTheme() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getString('theme');
  }
}
