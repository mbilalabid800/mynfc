import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesServices {
  Future<void> saveEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userEmail', email);
  }

  Future<String?> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userEmail');
  }

  Future<void> saveProfileLink(String userProfileLink) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userProfileLink', userProfileLink);
  }

  Future<String?> getProfileLink() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('profileLink');
  }
}
