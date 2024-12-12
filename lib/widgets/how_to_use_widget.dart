import 'package:flutter/material.dart';
import 'package:nfc_app/constants/appColors.dart';
import 'package:nfc_app/responsive/device_dimensions.dart';

class HowToUseBottomSheetWidget {
  static void showBottomSheetForiPhones(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      context: context,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
            initialChildSize: 0.6,
            maxChildSize: 0.9,
            minChildSize: 0.5,
            expand: false,
            builder: (context, scrollController) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  color: AppColors.screenBackground,
                  width: DeviceDimensions.screenWidth(context),
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    //mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: DeviceDimensions.screenWidth(context) * 0.15,
                        height: DeviceDimensions.screenHeight(context) * 0.005,
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(12)),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 12),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Tap to new iPhones',
                              style: TextStyle(
                                  fontSize:
                                      DeviceDimensions.responsiveSize(context) *
                                          0.045,
                                  fontWeight: FontWeight.w500)),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                              'To share to new iPhones, slide and Hold your product near the top of the iPhone until a push notification appears on screen.',
                              maxLines: 3,
                              style: TextStyle(
                                fontSize:
                                    DeviceDimensions.responsiveSize(context) *
                                        0.03,
                              )),
                        ),
                      ),
                      //SvgPicture.asset('assets/icons/iphone.svg'),
                      const Spacer(),
                      Image.asset(
                        'assets/icons/iphone.png',
                      ),

                      const Spacer(),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          width: DeviceDimensions.screenWidth(context) * 0.8,
                          height: DeviceDimensions.screenHeight(context) * 0.06,
                          decoration: BoxDecoration(
                              color: AppColors.appBlueColor,
                              borderRadius: BorderRadius.circular(25)),
                          child: const Center(
                            child: Text(
                              'Done',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      // Add more content as needed
                    ],
                  ),
                ),
              );
            });
      },
    );
  }

  static void showBottomSheetForAndroid(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      context: context,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
            initialChildSize: 0.8,
            maxChildSize: 0.9,
            minChildSize: 0.5,
            expand: false,
            builder: (context, scrollController) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  color: AppColors.screenBackground,
                  width: DeviceDimensions.screenWidth(context),
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    //mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: DeviceDimensions.screenWidth(context) * 0.15,
                        height: DeviceDimensions.screenHeight(context) * 0.005,
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(12)),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 12),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Tap to Androids',
                              style: TextStyle(
                                  fontSize:
                                      DeviceDimensions.responsiveSize(context) *
                                          0.045,
                                  fontWeight: FontWeight.w500)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Must have NFC enabled',
                              maxLines: 3,
                              style: TextStyle(
                                fontSize:
                                    DeviceDimensions.responsiveSize(context) *
                                        0.03,
                              )),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                              'To share to new iPhones, slide and Hold your product near the top of the iPhone until a push notification appears on screen.',
                              maxLines: 3,
                              style: TextStyle(
                                fontSize:
                                    DeviceDimensions.responsiveSize(context) *
                                        0.03,
                              )),
                        ),
                      ),
                      //SvgPicture.asset('assets/icons/iphone.svg'),
                      const Spacer(),
                      Image.asset(
                        'assets/icons/androidscan.png',
                      ),
                      Container(
                        width: DeviceDimensions.screenWidth(context) * 0.8,
                        //height: DeviceDimensions.screenHeight(context) * 0.1,
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 251, 243, 205),
                            borderRadius: BorderRadius.circular(25)),
                        child: Center(
                          child: Column(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(left: 8, top: 8.0),
                                child: Row(children: [
                                  Icon(
                                    Icons.info_outline_rounded,
                                    color: Colors.amberAccent,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 8.0),
                                    child: Text('Note',
                                        style: TextStyle(color: Colors.black)),
                                  )
                                ]),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Unlike iPhones, Android devices allow you to turn off NFC in the settings. Therefore, before sharing your product with an Android phone, it’s essential to ensure that NFC is turned on by checking te device settings.',
                                  style: TextStyle(
                                      color: const Color.fromARGB(
                                          255, 114, 114, 114),
                                      fontSize: DeviceDimensions.responsiveSize(
                                              context) *
                                          0.03),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          width: DeviceDimensions.screenWidth(context) * 0.8,
                          height: DeviceDimensions.screenHeight(context) * 0.06,
                          decoration: BoxDecoration(
                              color: AppColors.appBlueColor,
                              borderRadius: BorderRadius.circular(25)),
                          child: const Center(
                            child: Text(
                              'Done',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      // Add more content as needed
                    ],
                  ),
                ),
              );
            });
      },
    );
  }

  static void showBottomSheetForOlderiPhones(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      context: context,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
            initialChildSize: 0.8,
            maxChildSize: 0.9,
            minChildSize: 0.5,
            expand: false,
            builder: (context, scrollController) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  color: AppColors.screenBackground,
                  width: DeviceDimensions.screenWidth(context),
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    //mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: DeviceDimensions.screenWidth(context) * 0.15,
                        height: DeviceDimensions.screenHeight(context) * 0.005,
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(12)),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 12),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Older iPhones',
                              style: TextStyle(
                                  fontSize:
                                      DeviceDimensions.responsiveSize(context) *
                                          0.045,
                                  fontWeight: FontWeight.w500)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text('iPhone X and older',
                              maxLines: 3,
                              style: TextStyle(
                                fontSize:
                                    DeviceDimensions.responsiveSize(context) *
                                        0.03,
                              )),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                              'If you want to share your product with older iPhones, you have two options. The first option is to use your product’s QR code. While the second option involves accessing the NFC widget from the control center.',
                              maxLines: 3,
                              style: TextStyle(
                                fontSize:
                                    DeviceDimensions.responsiveSize(context) *
                                        0.03,
                              )),
                        ),
                      ),
                      //SvgPicture.asset('assets/icons/iphone.svg'),
                      const Spacer(),
                      Image.asset(
                        'assets/icons/iphoneold.png',
                      ),
                      Container(
                        width: DeviceDimensions.screenWidth(context) * 0.8,
                        //height: DeviceDimensions.screenHeight(context) * 0.1,
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 251, 243, 205),
                            borderRadius: BorderRadius.circular(25)),
                        child: Center(
                          child: Column(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(left: 8, top: 8.0),
                                child: Row(children: [
                                  Icon(
                                    Icons.info_outline_rounded,
                                    color: Colors.amberAccent,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 8.0),
                                    child: Text('Note',
                                        style: TextStyle(color: Colors.black)),
                                  )
                                ]),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Before sharing your product, make sure that your mobile screen is turned on and that airplane mode is off. Additionally, ensure that your camera is not in use.',
                                  style: TextStyle(
                                      color: const Color.fromARGB(
                                          255, 114, 114, 114),
                                      fontSize: DeviceDimensions.responsiveSize(
                                              context) *
                                          0.03),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          width: DeviceDimensions.screenWidth(context) * 0.8,
                          height: DeviceDimensions.screenHeight(context) * 0.06,
                          decoration: BoxDecoration(
                              color: AppColors.appBlueColor,
                              borderRadius: BorderRadius.circular(25)),
                          child: const Center(
                            child: Text(
                              'Done',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      // Add more content as needed
                    ],
                  ),
                ),
              );
            });
      },
    );
  }

  static void showBottomSheetForQRCode(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      context: context,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
            initialChildSize: 0.6,
            maxChildSize: 0.9,
            minChildSize: 0.5,
            expand: false,
            builder: (context, scrollController) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  color: AppColors.screenBackground,
                  width: DeviceDimensions.screenWidth(context),
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    //mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: DeviceDimensions.screenWidth(context) * 0.15,
                        height: DeviceDimensions.screenHeight(context) * 0.005,
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(12)),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 12),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Tap for QR Sharing',
                              style: TextStyle(
                                  fontSize:
                                      DeviceDimensions.responsiveSize(context) *
                                          0.045,
                                  fontWeight: FontWeight.w500)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text('For any smart phone',
                              maxLines: 3,
                              style: TextStyle(
                                fontSize:
                                    DeviceDimensions.responsiveSize(context) *
                                        0.038,
                              )),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                              "If you want to share your product with others via QR code, there are two ways to share it. The first method includes sharing your in-app QR code, while the second method entails sharing the QR code that’s printed on your product.",
                              maxLines: 3,
                              style: TextStyle(
                                fontSize:
                                    DeviceDimensions.responsiveSize(context) *
                                        0.03,
                              )),
                        ),
                      ),
                      //SvgPicture.asset('assets/icons/iphone.svg'),
                      const Spacer(),
                      Image.asset(
                        'assets/icons/qrcodescan.png',
                      ),

                      const Spacer(),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          width: DeviceDimensions.screenWidth(context) * 0.8,
                          height: DeviceDimensions.screenHeight(context) * 0.06,
                          decoration: BoxDecoration(
                              color: AppColors.appBlueColor,
                              borderRadius: BorderRadius.circular(25)),
                          child: const Center(
                            child: Text(
                              'Done',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      // Add more content as needed
                    ],
                  ),
                ),
              );
            });
      },
    );
  }
}
