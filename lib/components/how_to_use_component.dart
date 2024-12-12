// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nfc_app/constants/appColors.dart';
import 'package:nfc_app/responsive/device_dimensions.dart';

class HowToUseComponent extends StatelessWidget {
  final String imagePath;
  final String title;

  final String desc;
  final String icons2;

  const HowToUseComponent({
    super.key,
    required this.imagePath,
    required this.title,
    required this.desc,
    this.icons2 = "assets/icons/more4.svg",
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                width: 70, // set width
                height: 70, // set height
                decoration: BoxDecoration(
                  shape: BoxShape.circle, // makes the container circular
                  border: Border.all(
                    color: AppColors.appBlueColor, // color of the border
                    width: 2.0, // width of the border
                  ),
                ),
                child: CircleAvatar(
                  backgroundColor: const Color.fromARGB(255, 218, 218, 218),
                  radius: 30,
                  child: SvgPicture.asset(
                    imagePath,
                    height: 24,

                    ///height: 25,
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                          fontSize:
                              DeviceDimensions.responsiveSize(context) * 0.040,
                          fontFamily: 'Barlow-Regular',
                          fontWeight: FontWeight.w600,
                          color: AppColors.headingFontColor),
                    ),
                    Text(
                      desc,
                      style: TextStyle(
                          fontSize:
                              DeviceDimensions.responsiveSize(context) * 0.030,
                          fontFamily: 'Barlow-Regular',
                          color: AppColors.greyText),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: SvgPicture.asset(
                  icons2,
                  height: 15,
                  color: const Color(0xFF95989A),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
