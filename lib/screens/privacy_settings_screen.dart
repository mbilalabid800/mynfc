import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nfc_app/constants/appColors.dart';
import 'package:nfc_app/responsive/device_dimensions.dart';
import 'package:nfc_app/shared/common_widgets/custom_app_bar_widget.dart';

class PrivacySettings extends StatefulWidget {
  const PrivacySettings({super.key});

  @override
  State<PrivacySettings> createState() => _PrivacySettingsState();
}

class _PrivacySettingsState extends State<PrivacySettings> {
  bool accountPrivate = false;
  bool notifications = false;
  bool locationSharing = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: const CustomAppBar(title: "Privacy & Settings"),
        backgroundColor: AppColors.screenBackground,
        body: Center(
          child: Column(
            children: [
              Container(
                width: DeviceDimensions.screenWidth(context) * 0.90,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    SizedBox(
                        height: DeviceDimensions.screenHeight(context) * 0.020),
                    Container(
                      height: DeviceDimensions.screenHeight(context) * 0.062,
                      width: DeviceDimensions.screenWidth(context) * 0.83,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFEFEF),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Account Private",
                              style: TextStyle(
                                  fontSize:
                                      DeviceDimensions.responsiveSize(context) *
                                          0.039,
                                  fontFamily: 'Barlow-Regular',
                                  fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              height: 33,
                              child: FittedBox(
                                child: Switch(
                                    activeTrackColor: const Color(0xFFCEFD4B),
                                    value: accountPrivate,
                                    onChanged: (value) {
                                      setState(() {
                                        accountPrivate = value;
                                      });
                                    }),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                        height: DeviceDimensions.screenHeight(context) * 0.020),
                    Container(
                      height: DeviceDimensions.screenHeight(context) * 0.062,
                      width: DeviceDimensions.screenWidth(context) * 0.83,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFEFEF),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Notifications",
                              style: TextStyle(
                                  fontSize:
                                      DeviceDimensions.responsiveSize(context) *
                                          0.039,
                                  fontFamily: 'Barlow-Regular',
                                  fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              height: 33,
                              child: FittedBox(
                                child: Switch(
                                    activeTrackColor: const Color(0xFFCEFD4B),
                                    value: notifications,
                                    onChanged: (value) {
                                      setState(() {
                                        notifications = value;
                                      });
                                    }),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                        height: DeviceDimensions.screenHeight(context) * 0.020),
                    Container(
                      height: DeviceDimensions.screenHeight(context) * 0.062,
                      width: DeviceDimensions.screenWidth(context) * 0.83,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFEFEF),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Location Sharing",
                              style: TextStyle(
                                  fontSize:
                                      DeviceDimensions.responsiveSize(context) *
                                          0.039,
                                  fontFamily: 'Barlow-Regular',
                                  fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              height: 33,
                              child: FittedBox(
                                child: Switch(
                                    activeTrackColor: const Color(0xFFCEFD4B),
                                    value: locationSharing,
                                    onChanged: (value) {
                                      setState(() {
                                        locationSharing = value;
                                      });
                                    }),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                        height: DeviceDimensions.screenHeight(context) * 0.020),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, "/privacy-policy");
                      },
                      child: Container(
                        height: DeviceDimensions.screenHeight(context) * 0.062,
                        width: DeviceDimensions.screenWidth(context) * 0.83,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFEFEF),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Privacy Plolicy",
                                style: TextStyle(
                                    fontSize: DeviceDimensions.responsiveSize(
                                            context) *
                                        0.039,
                                    fontFamily: 'Barlow-Regular',
                                    fontWeight: FontWeight.w600),
                              ),
                              SvgPicture.asset(
                                "assets/icons/more3.svg",
                                height: 17,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                        height: DeviceDimensions.screenHeight(context) * 0.020),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, "/terms-conditions");
                      },
                      child: Container(
                        height: DeviceDimensions.screenHeight(context) * 0.062,
                        width: DeviceDimensions.screenWidth(context) * 0.83,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFEFEF),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Terms & Conditions",
                                style: TextStyle(
                                    fontSize: DeviceDimensions.responsiveSize(
                                            context) *
                                        0.039,
                                    fontFamily: 'Barlow-Regular',
                                    fontWeight: FontWeight.w600),
                              ),
                              SvgPicture.asset(
                                "assets/icons/more3.svg",
                                height: 17,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                        height: DeviceDimensions.screenHeight(context) * 0.020),
                    Container(
                      height: DeviceDimensions.screenHeight(context) * 0.062,
                      width: DeviceDimensions.screenWidth(context) * 0.83,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFEFEF),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Blocked Connections",
                              style: TextStyle(
                                  fontSize:
                                      DeviceDimensions.responsiveSize(context) *
                                          0.039,
                                  fontFamily: 'Barlow-Regular',
                                  fontWeight: FontWeight.w600),
                            ),
                            SvgPicture.asset(
                              "assets/icons/more3.svg",
                              height: 17,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                        height: DeviceDimensions.screenHeight(context) * 0.020),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
