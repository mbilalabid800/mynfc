import 'dart:async';

import 'package:flutter/material.dart';

class ResentButtonProvider extends ChangeNotifier {
  bool _isButtonEnabled = false;
  Timer? _timer;

  bool get isButtonEnabled => _isButtonEnabled;

  ResentButtonProvider() {
    _startCountdown();
  }

  void _startCountdown() {
    _isButtonEnabled = false;
    _timer = Timer(
      const Duration(seconds: 50),
      () {
        _isButtonEnabled = true;
        notifyListeners();
      },
    );
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
