import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:nfc_app/constants/appColors.dart';
import 'package:nfc_app/provider/user_info_form_state_provider.dart';
import 'package:nfc_app/responsive/device_dimensions.dart';
import 'package:nfc_app/services/auth_service/auth_service.dart';
import 'package:provider/provider.dart';

class SwitchProfileTypeWidget {
  static void showSwitchProfileTypeAlertDialog(BuildContext context) {
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
                    child: Text('Switch Profile Type',
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
                'Do you want to switch your profile type?',
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
                  // Container(
                  //   height: DeviceDimensions.screenHeight(context) * 0.06,
                  //   width: DeviceDimensions.screenWidth(context) * 0.8,
                  //   decoration: BoxDecoration(
                  //       color: Colors.white,
                  //       borderRadius: BorderRadius.circular(25),
                  //       border: Border.all(color: AppColors.appBlueColor)),
                  //   child: TextButton(
                  //     onPressed: () {
                  //       Navigator.of(context).pop(); // Close the dialog
                  //     },
                  //     child: Text(
                  //       'Cancel',
                  //       style: TextStyle(
                  //           color: AppColors.appBlueColor,
                  //           fontSize: DeviceDimensions.responsiveSize(context) *
                  //               0.035),
                  //     ),
                  //   ),
                  // ),
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
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        }

                        // Perform some action
                        // Access the provider
                        final userInfoProvider =
                            Provider.of<UserInfoFormStateProvider>(context,
                                listen: false);

                        // Get the current profile type
                        String currentProfileType =
                            userInfoProvider.profileType;

                        // Determine the new profile type
                        String newProfileType = currentProfileType == "Business"
                            ? "Private"
                            : "Business";

                        // Update the profile type
                        await userInfoProvider.updateProfileType(
                            newProfileType); // Close the dialog
                        if (context.mounted) {
                          Future.delayed(Duration(milliseconds: 300), () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  backgroundColor: AppColors.screenBackground,
                                  title: Center(
                                      child: Text("Profile Type Switched",
                                          style: TextStyle(
                                              color: AppColors.appBlueColor))),
                                  content: Text(
                                      "Your profile has been switched to $newProfileType.",
                                      style: TextStyle(
                                          color: AppColors.appBlueColor)),
                                  actions: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pop(
                                            context); // Close the dialog
                                      },
                                      child: Container(
                                        height: DeviceDimensions.screenHeight(
                                                context) *
                                            0.06,
                                        width: DeviceDimensions.screenWidth(
                                                context) *
                                            0.8,
                                        decoration: BoxDecoration(
                                            color: AppColors.appBlueColor,
                                            borderRadius:
                                                BorderRadius.circular(25)),
                                        child: Center(
                                            child: Text("OK",
                                                style: TextStyle(
                                                    color: Colors.white))),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          });
                        }
                      },
                      child: Text(
                        'Switch',
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
