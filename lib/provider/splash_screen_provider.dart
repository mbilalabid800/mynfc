import 'dart:async';
import 'package:flutter/material.dart';

class SplashScreenProvider with ChangeNotifier {
  final List<String>? splashImages;
  int _currentDot = 0;
  final PageController pageController =
      PageController(initialPage: 0); // Start at the first image
  late Timer _autoChangeTimer;

  int get currentDot => _currentDot;

  SplashScreenProvider({required this.splashImages}) {
    _startAutoChangeTimer();
  }

  void _startAutoChangeTimer() {
    if (splashImages == null || splashImages!.isEmpty) return;

    //Start an auto change timer that will update the images every 3 seconds
    _autoChangeTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      int nextPage = _currentDot + 1;

      // If we reach the end, loop to the first image without using dummy pages
      if (nextPage >= splashImages!.length) {
        nextPage = 0; // Loop back to the first image
      }

      // Animate to the next image
      // pageController.animateToPage(
      //   nextPage,
      //   duration: const Duration(milliseconds: 600),
      //   curve: Curves.easeInOut,
      // );
// Check if the controller has clients before animating
      if (pageController.hasClients) {
        pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      }
      //Update the current page index
      setPage(nextPage);
    });
  }

  void setPage(int index) {
    _currentDot = index % splashImages!.length;
    notifyListeners();
  }

  void handlePageChange(int index) {
    if (splashImages == null || splashImages!.isEmpty) return;

    // Update the current dot when the user manually swipes
    setPage(index);
  }

  @override
  void dispose() {
    _autoChangeTimer.cancel();
    pageController.dispose();
    super.dispose();
  }
}
