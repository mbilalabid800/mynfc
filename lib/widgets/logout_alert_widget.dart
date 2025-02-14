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
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Align(
                      alignment: Alignment.centerRight,
                      child: Icon(Icons.cancel, color: AppColors.appBlueColor)),
                ),
                Lottie.asset(
                  'assets/animations/logout_lottie.json',
                  height: DeviceDimensions.screenHeight(context) * 0.08,

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
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: DeviceDimensions.screenHeight(context) * 0.06,
                    width: DeviceDimensions.screenWidth(context) * 0.8,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(color: AppColors.appBlueColor)),
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog
                      },
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                            color: AppColors.appBlueColor,
                            fontSize: DeviceDimensions.responsiveSize(context) *
                                0.035),
                      ),
                    ),
                  ),
                  SizedBox(
                      height: DeviceDimensions.screenWidth(context) * 0.03),
                  Container(
                    height: DeviceDimensions.screenHeight(context) * 0.06,
                    width: DeviceDimensions.screenWidth(context) * 0.8,
                    decoration: BoxDecoration(
                        color: AppColors.appBlueColor,
                        borderRadius: BorderRadius.circular(25)),
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
