import 'package:flutter/material.dart';

class UserInfoProgressProvider with ChangeNotifier {
  int _progress = 1;
  int get progress => _progress;

  void incrementProgress() {
    if (_progress < 3) {
      _progress++;
      notifyListeners();
    }
  }

  void resetProgress() {
    _progress = 0;
    notifyListeners();
  }
}
