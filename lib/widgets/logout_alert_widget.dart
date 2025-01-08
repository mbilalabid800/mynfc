import 'package:flutter/material.dart';
import 'package:nfc_app/constants/appColors.dart';
import 'package:nfc_app/responsive/device_dimensions.dart';
import 'package:nfc_app/services/auth_service/auth_service.dart';

class LogoutAlertWidget {
  final AuthService _authService = AuthService();

  static void showLogoutAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: AlertDialog(
            backgroundColor: AppColors.screenBackground,
            //title: Text(''),
            content: Text(
              'Do you want to Logout Absher?',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: AppColors.appBlueColor,
                  fontSize: DeviceDimensions.responsiveSize(context) * 0.045,
                  fontWeight: FontWeight.w600),
            ),
            actions: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: DeviceDimensions.screenWidth(context) * 0.25,
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
                  SizedBox(width: DeviceDimensions.screenWidth(context) * 0.1),
                  Container(
                    width: DeviceDimensions.screenWidth(context) * 0.25,
                    decoration: BoxDecoration(
                        color: AppColors.appBlueColor,
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
