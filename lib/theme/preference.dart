import 'package:shared_preferences/shared_preferences.dart';

class ThemePreference {
  static const themeStatus = 'themeStatus';

  void setTheme(bool value) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool(themeStatus, value);
  }

  Future<bool> getTheme() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getBool(themeStatus) ?? false;
  }
}
