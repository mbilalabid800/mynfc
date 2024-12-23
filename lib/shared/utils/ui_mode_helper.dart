// utils/ui_mode_helper.dart
import 'package:flutter/services.dart';

void enableImmersiveStickyMode() {
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
}

// void lockOrientation() {
//   SystemChrome.setPreferredOrientations([
//     DeviceOrientation.portraitUp,
//     DeviceOrientation.portraitDown,
//   ]);
// }
