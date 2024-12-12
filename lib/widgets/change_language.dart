import 'package:flutter/material.dart';
import 'package:nfc_app/constants/appColors.dart';
import 'package:nfc_app/responsive/device_dimensions.dart';

class ChangeLanguage {
  void changeLanguage(BuildContext context) {
    String selectedLanguage = 'English';

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
              height: 270,
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
                  Text(
                    "Languages",
                    style: TextStyle(
                        fontSize:
                            DeviceDimensions.responsiveSize(context) * 0.050,
                        fontFamily: 'Barlow-Bold',
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                      height: DeviceDimensions.screenHeight(context) * 0.015),
                  Column(
                    children: [
                      const Divider(color: Color(0xFFE0E0E0)),
                      RadioListTile<String>(
                        title: const Text(
                          'English',
                          style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'Barlow-Regular',
                              fontWeight: FontWeight.w600),
                        ),
                        value: 'English',
                        groupValue: selectedLanguage,
                        onChanged: (value) {
                          setState(() {
                            selectedLanguage = value!;
                          });
                        },
                        activeColor: AppColors.appBlueColor,
                      ),
                      const Divider(color: Color(0xFFE0E0E0)),
                      RadioListTile<String>(
                        title: const Text(
                          'Arabic',
                          style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'Barlow-Regular',
                              fontWeight: FontWeight.w600),
                        ),
                        value: 'Arabic',
                        groupValue: selectedLanguage,
                        onChanged: (value) {
                          setState(() {
                            selectedLanguage = value!;
                          });
                        },
                        activeColor: AppColors.appBlueColor,
                      ),
                    ],
                  ),
                  SizedBox(
                      height: DeviceDimensions.screenHeight(context) * 0.035),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
