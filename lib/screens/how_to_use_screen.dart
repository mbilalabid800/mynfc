import 'package:flutter/material.dart';
import 'package:nfc_app/components/how_to_use_component.dart';
import 'package:nfc_app/constants/appColors.dart';
import 'package:nfc_app/responsive/device_dimensions.dart';
import 'package:nfc_app/shared/common_widgets/custom_app_bar_widget.dart';
import 'package:nfc_app/shared/utils/no_back_button_observer.dart';
import 'package:nfc_app/widgets/how_to_use_widget.dart';

class HowToUseScreen extends StatefulWidget {
  const HowToUseScreen({super.key});

  @override
  State<HowToUseScreen> createState() => _HowToUseScreenState();
}

class _HowToUseScreenState extends State<HowToUseScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.screenBackground,
        body: Column(
          children: [
            SizedBox(
              height: DeviceDimensions.screenHeight(context) * 0.0001,
            ),
            AbsherAppBar(
              title: 'How To Use Absher',
              onLeftButtonTap: () {
                Navigator.pop(context);
              },
              rightButton: Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                    width: DeviceDimensions.screenWidth(context) * 0.035),
              ),
            ),
            SizedBox(height: DeviceDimensions.screenHeight(context) * 0.020),
            // SizedBox(
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                            'How to use Absher with different mobiles and screens.',
                            softWrap: true,
                            maxLines: 2,
                            style: TextStyle(
                              fontSize:
                                  DeviceDimensions.responsiveSize(context) *
                                      0.035,
                              color: AppColors.textColorBlue,
                            )),
                      ),
                    ),
                    SizedBox(
                      height: DeviceDimensions.screenHeight(context) * 0.01,
                    ),
                    //SvgPicture.asset('assets/icons/how_to_use.svg'),
                    Image.asset('assets/icons/howtouse.png'),
                    SizedBox(
                      height: DeviceDimensions.screenHeight(context) * 0.01,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          HowToUseBottomSheetWidget.showBottomSheetForiPhones(
                              context);
                        },
                        child: Container(
                          width: DeviceDimensions.screenWidth(context) * 0.9,
                          // height: DeviceDimensions.screenHeight(context) * 0.12,
                          //color: Colors.blue,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12)),
                          child: const HowToUseComponent(
                            imagePath: 'assets/icons/apple.svg',
                            title: "Latest iPhones",
                            desc: "iPhone XR and Latest iPhone Models",
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          HowToUseBottomSheetWidget.showBottomSheetForAndroid(
                              context);
                        },
                        child: Container(
                          width: DeviceDimensions.screenWidth(context) * 0.9,
                          // height: DeviceDimensions.screenHeight(context) * 0.12,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12)),
                          child: const HowToUseComponent(
                            imagePath: 'assets/icons/android2.svg',
                            title: "Android Mobiles",
                            desc: "All Models with NFC",
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          HowToUseBottomSheetWidget
                              .showBottomSheetForOlderiPhones(context);
                        },
                        child: Container(
                          width: DeviceDimensions.screenWidth(context) * 0.9,
                          // height: DeviceDimensions.screenHeight(context) * 0.12,
                          //color: Colors.blue,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12)),
                          child: const HowToUseComponent(
                            imagePath: 'assets/icons/apple.svg',
                            title: "Older iPhone Models",
                            desc: "iPhone X or Older",
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          HowToUseBottomSheetWidget.showBottomSheetForQRCode(
                              context);
                        },
                        child: Container(
                          width: DeviceDimensions.screenWidth(context) * 0.9,
                          // height: DeviceDimensions.screenHeight(context) * 0.12,
                          //color: Colors.blue,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12)),
                          child: const HowToUseComponent(
                            imagePath: 'assets/icons/qr_code2.svg',
                            title: "QR Code Sharing",
                            desc: "For any Smart Phone",
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                        height: DeviceDimensions.screenHeight(context) * 0.04)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
