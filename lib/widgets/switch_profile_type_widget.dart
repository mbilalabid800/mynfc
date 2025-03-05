// // ignore_for_file: use_build_context_synchronously

// import 'package:flutter/material.dart';
// import 'package:lottie/lottie.dart';
// import 'package:nfc_app/constants/appColors.dart';
// import 'package:nfc_app/provider/user_info_form_state_provider.dart';
// import 'package:nfc_app/responsive/device_dimensions.dart';
// import 'package:provider/provider.dart';

// class SwitchProfileTypeWidget {
//   static void showSwitchProfileTypeAlertDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext dialogContext) {
//         // Store dialog context separately
//         return AlertDialog(
//           backgroundColor: AppColors.screenBackground,
//           title: Column(
//             children: [
//               GestureDetector(
//                 onTap: () {
//                   Navigator.of(dialogContext).pop();
//                 },
//                 child: Align(
//                     alignment: Alignment.centerRight,
//                     child: Icon(Icons.cancel, color: AppColors.appBlueColor)),
//               ),
//               Lottie.asset(
//                 'assets/animations/switch_profile_type.json',
//                 height: DeviceDimensions.screenHeight(context) * 0.15,
//               ),
//               Center(
//                   child: Text('Switch Profile Type',
//                       style: TextStyle(
//                           color: AppColors.appBlueColor,
//                           fontWeight: FontWeight.w600,
//                           fontSize: DeviceDimensions.responsiveSize(context) *
//                               0.05))),
//             ],
//           ),
//           content: SizedBox(
//             width: DeviceDimensions.screenWidth(context) * 0.95,
//             child: Text(
//               'Do you want to switch your profile type?',
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 color: AppColors.appBlueColor,
//                 fontSize: DeviceDimensions.responsiveSize(context) * 0.045,
//               ),
//             ),
//           ),
//           actions: [
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 SizedBox(height: DeviceDimensions.screenWidth(context) * 0.03),
//                 Container(
//                   height: DeviceDimensions.screenHeight(context) * 0.06,
//                   width: DeviceDimensions.screenWidth(context) * 0.8,
//                   decoration: BoxDecoration(
//                       color: AppColors.appBlueColor,
//                       borderRadius: BorderRadius.circular(25)),
//                   child: TextButton(
//                     onPressed: () async {
//                       // Close the first dialog
//                       Navigator.of(dialogContext).pop();

//                       // Wait to ensure UI updates
//                       await Future.delayed(Duration(milliseconds: 300));

//                       // Get the provider
//                       final userInfoProvider =
//                           Provider.of<UserInfoFormStateProvider>(context,
//                               listen: false);

//                       // Get the current profile type
//                       String currentProfileType = userInfoProvider.profileType;

//                       // Determine the new profile type
//                       String newProfileType = currentProfileType == "Business"
//                           ? "Individual"
//                           : "Business";

//                       // Update the profile type
//                       await userInfoProvider.updateProfileType(newProfileType);

//                       // Ensure the app is still mounted before showing the confirmation dialog
//                       if (!context.mounted) return;

//                       // Show confirmation dialog using `context` from `Builder`
//                       Future.delayed(Duration(milliseconds: 100), () {
//                         showDialog(
//                           context: context,
//                           builder: (context) {
//                             return AlertDialog(
//                               backgroundColor: AppColors.screenBackground,
//                               title: Center(
//                                   child: Text("Profile Type Switched",
//                                       style: TextStyle(
//                                           color: AppColors.appBlueColor))),
//                               content: Text(
//                                   "Your profile has been switched to $newProfileType.",
//                                   style:
//                                       TextStyle(color: AppColors.appBlueColor)),
//                               actions: [
//                                 GestureDetector(
//                                   onTap: () {
//                                     Navigator.pop(
//                                         context); // Close confirmation dialog
//                                   },
//                                   child: Container(
//                                     height:
//                                         DeviceDimensions.screenHeight(context) *
//                                             0.06,
//                                     width:
//                                         DeviceDimensions.screenWidth(context) *
//                                             0.8,
//                                     decoration: BoxDecoration(
//                                         color: AppColors.appBlueColor,
//                                         borderRadius:
//                                             BorderRadius.circular(25)),
//                                     child: Center(
//                                         child: Text("OK",
//                                             style: TextStyle(
//                                                 color: Colors.white))),
//                                   ),
//                                 ),
//                               ],
//                             );
//                           },
//                         );
//                       });
//                     },
//                     child: Text(
//                       'Switch',
//                       style: TextStyle(
//                           color: AppColors.screenBackground,
//                           fontSize:
//                               DeviceDimensions.responsiveSize(context) * 0.04),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:nfc_app/constants/appColors.dart';
import 'package:nfc_app/provider/user_info_form_state_provider.dart';
import 'package:nfc_app/responsive/device_dimensions.dart';
import 'package:provider/provider.dart';

class SwitchProfileTypeWidget {
  static void showSwitchProfileTypeAlertDialog(BuildContext context) {
    final userInfoProvider =
        Provider.of<UserInfoFormStateProvider>(context, listen: false);
    String currentProfileType = userInfoProvider.profileType;
    String newProfileType =
        currentProfileType == "Business" ? "Individual" : "Business";
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.screenBackground,
          title: Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(dialogContext).pop();
                },
                child: Align(
                    alignment: Alignment.centerRight,
                    child: Icon(Icons.cancel, color: AppColors.appBlueColor)),
              ),
              Lottie.asset(
                'assets/animations/switch_profile_type.json',
                height: DeviceDimensions.screenHeight(context) * 0.15,
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
              'Do you want to switch your profile type from $currentProfileType to $newProfileType',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.appBlueColor,
                fontSize: DeviceDimensions.responsiveSize(context) * 0.045,
              ),
            ),
          ),
          actions: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: DeviceDimensions.screenWidth(context) * 0.03),
                Container(
                  height: DeviceDimensions.screenHeight(context) * 0.06,
                  width: DeviceDimensions.screenWidth(context) * 0.8,
                  decoration: BoxDecoration(
                      color: AppColors.appBlueColor,
                      borderRadius: BorderRadius.circular(25)),
                  child: TextButton(
                    onPressed: () async {
                      // Close the first dialog
                      Navigator.of(dialogContext).pop();

                      // Show the loading dialog
                      showDialog(
                        context: context,
                        barrierDismissible: false, // Prevent closing manually
                        builder: (BuildContext loadingContext) {
                          return AlertDialog(
                            backgroundColor: AppColors.screenBackground,
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircularProgressIndicator(
                                    color: AppColors.appBlueColor),
                                SizedBox(height: 20),
                                Text("Switching profile...",
                                    style: TextStyle(
                                        color: AppColors.appBlueColor)),
                              ],
                            ),
                          );
                        },
                      );

                      // Simulate a short delay (loader visibility)
                      await Future.delayed(Duration(seconds: 2));

                      // Get the provider
                      final userInfoProvider =
                          Provider.of<UserInfoFormStateProvider>(context,
                              listen: false);

                      // Get the current profile type
                      String currentProfileType = userInfoProvider.profileType;

                      // Determine the new profile type
                      String newProfileType = currentProfileType == "Business"
                          ? "Individual"
                          : "Business";

                      // Update the profile type
                      await userInfoProvider.updateProfileType(newProfileType);

                      // Close the loading dialog
                      Navigator.of(context).pop();

                      // Ensure the app is still mounted before showing the confirmation dialog
                      if (!context.mounted) return;

                      // Show confirmation dialog using `context` from `Builder`
                      Future.delayed(Duration(milliseconds: 100), () {
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
                                  textAlign: TextAlign.center,
                                  "Your profile has been switched from $currentProfileType to $newProfileType",
                                  style:
                                      TextStyle(color: AppColors.appBlueColor)),
                              actions: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    height:
                                        DeviceDimensions.screenHeight(context) *
                                            0.06,
                                    width:
                                        DeviceDimensions.screenWidth(context) *
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
                    },
                    child: Text(
                      'Switch',
                      style: TextStyle(
                          color: AppColors.screenBackground,
                          fontSize:
                              DeviceDimensions.responsiveSize(context) * 0.04),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
