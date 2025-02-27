import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:nfc_app/constants/appColors.dart';
import 'package:nfc_app/responsive/device_dimensions.dart';
import 'package:nfc_app/shared/utils/url_launcher_helper.dart';

class DownloadAppWidget {
  static void showDownloadAlertDialog(BuildContext context) {
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
                  "assets/animations/getapp.json",
                  height: 200,
                ),
              ],
            ),
            content: SizedBox(
              width: DeviceDimensions.screenWidth(context) * 0.95,
              child: Text(
                'Saving contacts is only available in our app. Download now to use this feature.',
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
                  SizedBox(
                      height: DeviceDimensions.screenWidth(context) * 0.03),
                  Center(
                    child: Container(
                      height: DeviceDimensions.screenHeight(context) * 0.06,
                      width: DeviceDimensions.screenWidth(context) * 0.75,
                      decoration: BoxDecoration(
                        color: AppColors.appBlueColor,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: TextButton(
                        onPressed: () async {
                          UrlLauncherHelper.launchSocialApps(context,
                              "https://play.google.com/store/apps/details?id=com.sahabit.absher");
                        },
                        child: Text(
                          'Download App',
                          style: TextStyle(
                              color: AppColors.screenBackground,
                              fontSize:
                                  DeviceDimensions.responsiveSize(context) *
                                      0.04),
                        ),
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
