import 'package:shared_preferences/shared_preferences.dart';

class SplashImages {
  static const String _splashImagesKey = 'splash_images';

  final List<String> _defaultSplashImages = [
    "assets/images/splash1.png",
    "assets/images/splash2.png",
    "assets/images/splash3.png",
  ];

  Future<void> saveSplashImages() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_splashImagesKey, _defaultSplashImages);
  }

  Future<List<String>> loadSplashImages() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_splashImagesKey) ?? _defaultSplashImages;
  }
}
