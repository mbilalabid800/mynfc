import 'package:flutter/material.dart';
import 'package:nfc_app/constants/appColors.dart';
import 'package:nfc_app/responsive/device_dimensions.dart';

class FeaturesCard extends StatelessWidget {
  final String title1;
  final String description1;
  final String image;
  final String title2;
  final String description2;

  const FeaturesCard({
    super.key,
    required this.title1,
    required this.description1,
    required this.image,
    required this.title2,
    required this.description2,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: DeviceDimensions.screenWidth(context) * 0.90,
          decoration: BoxDecoration(
            color: AppColors.screenBackground,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              SizedBox(height: DeviceDimensions.screenHeight(context) * 0.030),
              Text(
                title1,
                style: TextStyle(
                  fontSize: DeviceDimensions.responsiveSize(context) * 0.060,
                  fontFamily: 'Barlow-Bold',
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: DeviceDimensions.screenHeight(context) * 0.010),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  description1,
                  style: TextStyle(
                      fontSize: DeviceDimensions.responsiveSize(context) * .033,
                      fontFamily: 'Barlow-Regular',
                      fontWeight: FontWeight.w500,
                      color: AppColors.textColorBlue),
                  textAlign: TextAlign.justify,
                ),
              ),
              SizedBox(height: DeviceDimensions.screenHeight(context) * 0.040),
              Image.asset(
                image,
                // width: 150,
                // height: 200,
                fit: BoxFit.cover,
              ),
              SizedBox(height: DeviceDimensions.screenHeight(context) * 0.040),
            ],
          ),
        ),
        SizedBox(height: DeviceDimensions.screenHeight(context) * 0.020),
        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Align(
            alignment: Alignment.topLeft,
            child: Text(
              title2,
              style: TextStyle(
                  fontFamily: "Barlow-Bold",
                  fontSize: DeviceDimensions.responsiveSize(context) * 0.055,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ),
        // SizedBox(height: DeviceDimensions.screenHeight(context) * 0.005),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(
            description2,
            style: TextStyle(
                fontSize: DeviceDimensions.responsiveSize(context) * .033,
                fontFamily: 'Barlow-Regular',
                fontWeight: FontWeight.w500,
                color: AppColors.textColorBlue),
            textAlign: TextAlign.justify,
          ),
        ),
        SizedBox(height: DeviceDimensions.screenHeight(context) * 0.030),
      ],
    );
  }
}
