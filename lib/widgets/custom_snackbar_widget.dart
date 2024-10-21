import 'package:flutter/material.dart';
import 'package:nfc_app/constants/appColors.dart';
import 'package:nfc_app/responsive/device_dimensions.dart';

class CustomSnackbar {
  void snakBarError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        message,
        style: TextStyle(
            fontFamily: 'Barlow-Regular',
            fontWeight: FontWeight.w600,
            fontSize: DeviceDimensions.responsiveSize(context) * 0.045),
      ),
      duration: const Duration(seconds: 3),
      backgroundColor: AppColors.errorColor,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ));
  }

  void snakBarMessage(BuildContext context, String message) {
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
}
