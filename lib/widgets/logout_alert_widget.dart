import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:nfc_app/constants/appColors.dart';
import 'package:nfc_app/responsive/device_dimensions.dart';
import 'package:nfc_app/services/auth_service/auth_service.dart';

class LogoutAlertWidget {
  static void showLogoutAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: AlertDialog(
            backgroundColor: AppColors.screenBackground,
            title: Column(
              children: [
                Lottie.asset(
                  'assets/animations/logout_lottie.json',
                  //height: 120,
                ),
                Center(
                    child: Text('Confirm Logout',
                        style: TextStyle(
                            color: AppColors.appBlueColor,
                            fontWeight: FontWeight.w600,
                            fontSize: DeviceDimensions.responsiveSize(context) *
                                0.05))),
              ],
            ),
            content: SizedBox(
              width: DeviceDimensions.screenWidth(context) * 0.95,
              child: Text(
                'Do you want to Logout Absher?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.appBlueColor,
                  fontSize: DeviceDimensions.responsiveSize(context) * 0.045,
                  //fontWeight: FontWeight.w600
                ),
              ),
            ),
            actions: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: DeviceDimensions.screenHeight(context) * 0.05,
                    width: DeviceDimensions.screenWidth(context) * 0.28,
                    decoration: BoxDecoration(
                        color: AppColors.greyText,
                        borderRadius: BorderRadius.circular(20)),
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog
                      },
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                            color: AppColors.screenBackground,
                            fontSize: DeviceDimensions.responsiveSize(context) *
                                0.035),
                      ),
                    ),
                  ),
                  Spacer(),
                  //SizedBox(width: DeviceDimensions.screenWidth(context) * 0.1),
                  Container(
                    height: DeviceDimensions.screenHeight(context) * 0.05,
                    width: DeviceDimensions.screenWidth(context) * 0.28,
                    decoration: BoxDecoration(
                        color: AppColors.errorColor,
                        borderRadius: BorderRadius.circular(20)),
                    child: TextButton(
                      onPressed: () async {
                        // Perform some action
                        await AuthService()
                            .signOut(context); // Close the dialog
                      },
                      child: Text(
                        'Logout',
                        style: TextStyle(
                            color: AppColors.screenBackground,
                            fontSize: DeviceDimensions.responsiveSize(context) *
                                0.035),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
