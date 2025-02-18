import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nfc_app/constants/appColors.dart';
import 'package:nfc_app/responsive/device_dimensions.dart';

class PaymentSuccessful {
  const PaymentSuccessful();

  void showPaymentSuccessfulDialog(BuildContext context, String orderId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: Container(
            color: Colors.black54,
            child: Dialog(
              insetPadding: EdgeInsets.zero,
              backgroundColor: Colors.white,
              child: SizedBox(
                height: DeviceDimensions.screenHeight(context) * 0.38,
                width: DeviceDimensions.screenWidth(context) * 0.85,
                child: Column(
                  children: [
                    SizedBox(
                        height: DeviceDimensions.screenHeight(context) * 0.030),
                    SvgPicture.asset("assets/icons/done.svg"),
                    SizedBox(
                        height: DeviceDimensions.screenHeight(context) * 0.010),
                    Text(
                      "Order Placed",
                      style: TextStyle(
                        fontFamily: 'Barlow-Bold',
                        fontWeight: FontWeight.w600,
                        fontSize:
                            DeviceDimensions.responsiveSize(context) * 0.050,
                        color: AppColors.textColorBlue,
                      ),
                    ),
                    SizedBox(
                        height: DeviceDimensions.screenHeight(context) * 0.002),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Text(
                        "Your Order# $orderId has been placed successfully.",
                        style: TextStyle(
                            fontFamily: 'Barlow-Regular',
                            fontWeight: FontWeight.w500,
                            fontSize: DeviceDimensions.responsiveSize(context) *
                                0.036,
                            color: AppColors.textColorBlue),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                        height: DeviceDimensions.screenHeight(context) * 0.030),
                    SizedBox(
                      height: DeviceDimensions.screenHeight(context) * 0.050,
                      width: DeviceDimensions.screenWidth(context) * 0.50,
                      child: ElevatedButton(
                        onPressed: () {
                          // Navigator.pushReplacementNamed(
                          //     context, "/order-details");
                          Navigator.pushReplacementNamed(
                            context,
                            '/order-details',
                            // (route) =>
                            //     false, // This removes all previous routes
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.appBlueColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.zero,
                        ),
                        child: Text(
                          "View Order details",
                          style: TextStyle(
                            fontSize: DeviceDimensions.responsiveSize(context) *
                                0.040,
                            fontFamily: 'Barlow-Regular',
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
