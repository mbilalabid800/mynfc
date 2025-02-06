import 'dart:async';

import 'package:flutter/material.dart';

class ResentButtonProvider extends ChangeNotifier {
  bool _isButtonEnabled = false;
  int _countdown = 59;
  Timer? _timer;

  bool get isButtonEnabled => _isButtonEnabled;
  int get countdown => _countdown;

  ResentButtonProvider() {
    _startCountdown();
  }

  void _startCountdown() {
    _isButtonEnabled = false;
    _countdown = 59;
    notifyListeners();
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_countdown == 0) {
        _isButtonEnabled = true;
        timer.cancel();
      } else {
        _countdown--;
      }
      notifyListeners();
    });
  }

  void resentEmail() {
    if (_isButtonEnabled) {
      _startCountdown();
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
