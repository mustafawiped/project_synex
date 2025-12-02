// ignore_for_file: non_constant_identifier_names

import 'package:shared_preferences/shared_preferences.dart';

class SharedUtils {
  static String UsernamePreferenceKey = "user";

  static Future<bool> addOrUpdateShared(String value) async {
    try {
      final preferences = await SharedPreferences.getInstance();
      preferences.setString(UsernamePreferenceKey, value);
      return true;
    } catch (error) {
      return false;
    }
  }

  static Future<String?> getShared() async {
    try {
      final preferences = await SharedPreferences.getInstance();
      return preferences.getString(UsernamePreferenceKey);
    } catch (error) {
      return null;
    }
  }
}
