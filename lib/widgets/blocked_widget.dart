// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:nfc_app/constants/appColors.dart';
import 'package:nfc_app/responsive/device_dimensions.dart';
import 'package:nfc_app/screens/auth/login_screen.dart';

class Blocked {
  const Blocked();

  void show(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
                (Route<dynamic> route) => false);
            return false;
          },
          child: Center(
            child: Container(
              color: AppColors.appBlueColor,
              child: Dialog(
                insetPadding: EdgeInsets.zero,
                backgroundColor: Colors.white,
                child: SizedBox(
                  height: DeviceDimensions.screenHeight(context) * 0.38,
                  width: DeviceDimensions.screenWidth(context) * 0.85,
                  child: Column(
                    children: [
                      SizedBox(
                          height:
                              DeviceDimensions.screenHeight(context) * 0.015),
                      Lottie.asset(
                        'assets/animations/blocked.json',
                        height: 120,
                      ),
                      // SizedBox(
                      //     height: DeviceDimensions.screenHeight(context) * 0.010),
                      Text(
                        "Account Blocked",
                        style: TextStyle(
                          fontFamily: 'Barlow-Bold',
                          fontWeight: FontWeight.w600,
                          fontSize:
                              DeviceDimensions.responsiveSize(context) * 0.055,
                        ),
                      ),
                      SizedBox(
                          height:
                              DeviceDimensions.screenHeight(context) * 0.010),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          "Your account is blocked. Please contact support for assistance.",
                          style: TextStyle(
                              fontFamily: 'Barlow-Regular',
                              fontWeight: FontWeight.w500,
                              fontSize:
                                  DeviceDimensions.responsiveSize(context) *
                                      0.038,
                              color: Colors.black),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                          height:
                              DeviceDimensions.screenHeight(context) * 0.030),
                      SizedBox(
                        height: DeviceDimensions.screenHeight(context) * 0.050,
                        width: DeviceDimensions.screenWidth(context) * 0.46,
                        child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, "/contact-us-screen");
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.appBlueColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: EdgeInsets.zero,
                            ),
                            child: Text(
                              "Contact Support",
                              style: TextStyle(
                                fontSize:
                                    DeviceDimensions.responsiveSize(context) *
                                        0.040,
                                fontFamily: 'Barlow-Regular',
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1,
                                color: Colors.white,
                              ),
                            )),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
