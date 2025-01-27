import 'dart:async';
import 'package:flutter/material.dart';

class SplashScreenProvider with ChangeNotifier {
  int _currentDot = 0;
  final PageController pageController = PageController(initialPage: 0);
  late Timer _autoChangeTimer;

  int get currentDot => _currentDot;

  SplashScreenProvider() {
    _startAutoChangeTimer();
  }

  void _startAutoChangeTimer() {
    _autoChangeTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      int nextPage = (_currentDot + 1) % 3; // Adjust based on total pages
      setPage(nextPage);
      pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    });
  }

  void setPage(int index) {
    _currentDot = index;
    notifyListeners();
  }

  @override
  void dispose() {
    _autoChangeTimer.cancel();
    pageController.dispose();
    super.dispose();
  }
}
