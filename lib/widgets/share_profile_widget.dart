import 'package:flutter/material.dart';
import 'package:nfc_app/constants/appColors.dart';
import 'package:nfc_app/responsive/device_dimensions.dart';

class ShareProfile {
  void shareProfile(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: AppColors.screenBackground,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, setState) {
            return SizedBox(
              height: 170,
              width: DeviceDimensions.screenWidth(context),
              child: Column(
                children: [
                  SizedBox(
                      height: DeviceDimensions.screenHeight(context) * 0.015),
                  Container(
                    width: DeviceDimensions.screenWidth(context) * 0.16,
                    height: DeviceDimensions.screenHeight(context) * 0.007,
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  SizedBox(
                      height: DeviceDimensions.screenHeight(context) * 0.030),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("assets/icons/shareqr.png", height: 26),
                      SizedBox(
                          width: DeviceDimensions.screenWidth(context) * 0.020),
                      Text(
                        "Share with QR Code",
                        style: TextStyle(
                          fontSize:
                              DeviceDimensions.responsiveSize(context) * 0.052,
                          fontFamily: 'Barlow-Regular',
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                      height: DeviceDimensions.screenHeight(context) * 0.010),
                  Divider(),
                  SizedBox(
                      height: DeviceDimensions.screenHeight(context) * 0.010),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("assets/icons/sharelink.png", height: 28),
                      SizedBox(
                          width: DeviceDimensions.screenWidth(context) * 0.050),
                      Text(
                        "Share Profile Link",
                        style: TextStyle(
                          fontSize:
                              DeviceDimensions.responsiveSize(context) * 0.052,
                          fontFamily: 'Barlow-Regular',
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    ],
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }
}
