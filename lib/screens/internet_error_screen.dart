// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:nfc_app/constants/appColors.dart';
import 'package:nfc_app/provider/internet_checker_provider.dart';
import 'package:nfc_app/responsive/device_dimensions.dart';
import 'package:provider/provider.dart';

class InternetError extends StatelessWidget {
  const InternetError({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.screenBackground,
        body: Consumer<InternetCheckerProvider>(
          builder: (context, internetChecker, child) {
            if (internetChecker.hasInternet) {
              Future.microtask(() => Navigator.pop(context));
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/icons/error.png',
                ),
                Text(
                  'No Internet',
                  style: TextStyle(
                      color: AppColors.headingFontColor,
                      fontSize:
                          DeviceDimensions.responsiveSize(context) * 0.065,
                      fontFamily: 'Barlow-Bold'),
                ),
                SizedBox(
                    height: DeviceDimensions.screenHeight(context) * 0.010),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                      textAlign: TextAlign.center,
                      'Something went wrong with your internet connection, please check it and try again.'),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
