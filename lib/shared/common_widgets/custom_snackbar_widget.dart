// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:nfc_app/constants/appColors.dart';
import 'package:nfc_app/responsive/device_dimensions.dart';

class CustomSnackbar {
  void snakBarError(BuildContext context, String message) {
    final messenger = ScaffoldMessenger.of(context);

    // Hide the current SnackBar
    messenger.hideCurrentSnackBar(reason: SnackBarClosedReason.dismiss);

    // Show the new SnackBar after a brief delay
    Future.delayed(const Duration(milliseconds: 200), () {
      messenger.showSnackBar(SnackBar(
        content: _buildAnimatedContent(message, context),
        duration: const Duration(seconds: 2),
        backgroundColor: AppColors.errorColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ));
    });
  }

  void snakBarMessage(BuildContext context, String message) {
    final messenger = ScaffoldMessenger.of(context);

    // Hide the current SnackBar
    messenger.hideCurrentSnackBar(reason: SnackBarClosedReason.dismiss);

    // Show the new SnackBar after a brief delay
    Future.delayed(const Duration(milliseconds: 200), () {
      messenger.showSnackBar(SnackBar(
        content: _buildAnimatedContent(message, context),
        duration: const Duration(seconds: 2),
        backgroundColor: AppColors.successColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ));
    });
  }

  // Builds animated content for the SnackBar
  Widget _buildAnimatedContent(String message, BuildContext context) {
    final animationController = AnimationController(
      vsync:
          Scaffold.of(context), // Requires the context to have a TickerProvider
      duration: const Duration(milliseconds: 300),
    );

    final fadeAnimation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeInOut,
    );

    animationController.forward(); // Start the animation

    return FadeTransition(
      opacity: fadeAnimation,
      child: Text(
        message,
        style: TextStyle(
          fontFamily: 'Barlow-Regular',
          fontWeight: FontWeight.w600,
          fontSize: MediaQuery.of(context).size.width * 0.045,
        ),
      ),
    );
  }

  void snakBarMessage2(BuildContext context, String message) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        message,
        style: TextStyle(
            fontFamily: 'Barlow-Regular',
            fontWeight: FontWeight.w600,
            fontSize: DeviceDimensions.responsiveSize(context) * 0.045),
      ),
      duration: const Duration(seconds: 3),
      backgroundColor: AppColors.successColor,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ));
  }

  // void snakBarMessageShort(BuildContext context, String message) {
  //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //     content: Text(
  //       message,
  //       style: TextStyle(
  //           fontFamily: 'Barlow-Regular',
  //           fontWeight: FontWeight.w600,
  //           fontSize: DeviceDimensions.responsiveSize(context) * 0.045),
  //     ),
  //     duration: const Duration(seconds: 1),
  //     backgroundColor: AppColors.successColor,
  //     behavior: SnackBarBehavior.floating,
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.circular(10),
  //     ),
  //   ));
  // }
}
