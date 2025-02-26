// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nfc_app/constants/appColors.dart';
import 'package:nfc_app/responsive/device_dimensions.dart';
import 'package:nfc_app/services/nfc_service/nfc_service.dart';
import 'package:nfc_app/shared/common_widgets/custom_app_bar_widget.dart';
import 'package:nfc_app/shared/utils/no_back_button_observer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ActiveProductScreen extends StatefulWidget {
  const ActiveProductScreen({super.key});

  @override
  State<ActiveProductScreen> createState() => _ActiveProductScreenState();
}

class _ActiveProductScreenState extends State<ActiveProductScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Future<String> generateProfileLink() async {
    // Get the current user's UID from Firebase Authentication
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      String uid = user.uid;
      // Generate the deep link
      // String userProfileLink = 'https://myabsher.com/profile/$uid?source=nfc';
      String userProfileLink = 'https://website.myabsher.com/#/profile/$uid';
      return userProfileLink;
    } else {
      throw Exception('User not logged in');
    }
  }

  Future<void> saveProfileLink(String userProfileLink) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userProfileLink', userProfileLink);
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(30)),
          padding: const EdgeInsets.all(16.0),
          height: DeviceDimensions.screenHeight(context) * 0.9,
          width: DeviceDimensions.screenWidth(context) * 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(
                'Activate Business Card',
                style: TextStyle(
                  fontSize: DeviceDimensions.responsiveSize(context) * 0.06,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textColorBlue,
                ),
              ),
              Image.asset('assets/images/cardimage_graphscreen.png',
                  width: DeviceDimensions.screenWidth(context) * 0.55),
              //SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Choose how to activate your product',
                    style: TextStyle(
                        fontSize:
                            DeviceDimensions.responsiveSize(context) * 0.04,
                        color: AppColors.textColorBlue,
                        fontWeight: FontWeight.w400)),
              ),
              //SizedBox(height: 20),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/qr-scanner-screen');
                },
                child: Container(
                  width: DeviceDimensions.screenWidth(context) * 0.85,
                  height: DeviceDimensions.screenHeight(context) * 0.08,
                  decoration: BoxDecoration(
                      color: AppColors.screenBackground,
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: SvgPicture.asset(
                            'assets/icons/qrcode.svg',
                            width: 25,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 18.0),
                          child: Text(
                            'Activate by QR Code',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: AppColors.textColorBlue,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(right: 12.0),
                          child: SvgPicture.asset(
                            'assets/icons/more4.svg',
                            width: 8,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: DeviceDimensions.screenHeight(context) * 0.006,
              ),
              Builder(builder: (BuildContext newContext) {
                return InkWell(
                  onTap: () async {
                    final nfcService = NfcService();
                    debugPrint('clicked');
                    try {
                      // Generate the deep link with UID
                      String userprofileLink = await generateProfileLink();

                      // Save the link in SharedPreferences
                      await saveProfileLink(userprofileLink);

                      // Write the link to the NFC card via NfcService
                      await nfcService.writeProfileToNfc(
                          newContext, userprofileLink);

                      // Show success message using ScaffoldMessenger
                      // ScaffoldMessenger.of(newContext).showSnackBar(
                      //   SnackBar(
                      //       content: Text('NFC card successfully written!')),
                      // );
                    } catch (e) {
                      // Show error message using ScaffoldMessenger
                      ScaffoldMessenger.of(newContext).showSnackBar(
                        SnackBar(
                            content: Text('No NFC card detected. Try again!')),
                      );
                    }
                    // // Generate the deep link with UID
                    // String userprofileLink = await generateProfileLink();

                    // // Save the link in SharedPreferences
                    // await saveProfileLink(userprofileLink);

                    // // Write the link to the NFC card via NfcService
                    // await nfcService.writeProfileToNfc(context, userprofileLink);
                  },
                  child: Container(
                    width: DeviceDimensions.screenWidth(context) * 0.85,
                    height: DeviceDimensions.screenHeight(context) * 0.08,
                    decoration: BoxDecoration(
                        color: AppColors.screenBackground,
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: SvgPicture.asset(
                              'assets/icons/nfc.svg',
                              width: 25,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 18.0),
                            child: Text(
                              'Activate by NFC',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: AppColors.textColorBlue,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Padding(
                            padding: const EdgeInsets.only(right: 12.0),
                            child: SvgPicture.asset(
                              'assets/icons/more4.svg',
                              width: 8,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
              SizedBox(height: DeviceDimensions.screenHeight(context) * 0.02)
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: GlobalBackButtonHandler(
      child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: AppColors.screenBackground,
          body: Column(children: [
            SizedBox(
              height: DeviceDimensions.screenHeight(context) * 0.0001,
            ),
            AbsherAppBar(title: 'Add New'),
            //SizedBox(height: DeviceDimensions.screenHeight(context) * 0.020),
            Flexible(
              child: SingleChildScrollView(
                child: Center(
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(35)),
                        height: DeviceDimensions.screenHeight(context) * 0.3,
                        width: DeviceDimensions.screenWidth(context) * 0.9,
                        child: Column(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 10),
                                child: Row(
                                  children: [
                                    Text('Add\nConnections',
                                        style: TextStyle(
                                            fontSize:
                                                DeviceDimensions.responsiveSize(
                                                        context) *
                                                    0.045,
                                            color: AppColors.textColorBlue,
                                            fontWeight: FontWeight.w600)),
                                    const Spacer(),
                                    SvgPicture.asset(
                                        'assets/icons/add_user.svg')
                                  ],
                                ),
                              ),
                            ),
                            Stack(children: [
                              Container(
                                height: DeviceDimensions.screenHeight(context) *
                                    0.20,
                                width: DeviceDimensions.screenWidth(context) *
                                    0.85,
                                decoration: BoxDecoration(
                                  //color: Colors.red,
                                  borderRadius: BorderRadius.circular(35),
                                  image: const DecorationImage(
                                    image: AssetImage(
                                      'assets/icons/add_connections.png',
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, '/recent-connected');
                                  },
                                  child: SvgPicture.asset(
                                    'assets/icons/addsvg.svg',
                                    width: 70,
                                    height: 70,
                                  ),
                                ),
                              ),
                            ]),
                            SizedBox(
                                height: DeviceDimensions.screenHeight(context) *
                                    0.01)
                          ],
                        ),
                      ),
                      SizedBox(
                        height: DeviceDimensions.screenHeight(context) * 0.038,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(35)),
                        height: DeviceDimensions.screenHeight(context) * 0.3,
                        width: DeviceDimensions.screenWidth(context) * 0.9,
                        child: Column(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 10),
                                child: Row(
                                  children: [
                                    Text('Scan\nBusiness Card',
                                        style: TextStyle(
                                            fontSize:
                                                DeviceDimensions.responsiveSize(
                                                        context) *
                                                    0.045,
                                            color: AppColors.textColorBlue,
                                            fontWeight: FontWeight.w600)),
                                    const Spacer(),
                                    SvgPicture.asset('assets/icons/code.svg')
                                  ],
                                ),
                              ),
                            ),
                            Stack(children: [
                              Container(
                                height: DeviceDimensions.screenHeight(context) *
                                    0.20,
                                width: DeviceDimensions.screenWidth(context) *
                                    0.85,
                                decoration: BoxDecoration(
                                  //color: Colors.red,
                                  borderRadius: BorderRadius.circular(35),
                                  image: const DecorationImage(
                                    image: AssetImage(
                                      'assets/images/Subtract.png',
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: () {
                                    // Navigator.pushNamed(context, '/home-screen');
                                    _showBottomSheet(context);
                                  },
                                  child: SvgPicture.asset(
                                    'assets/icons/addsvg.svg',
                                    width: 70,
                                    height: 70,
                                  ),
                                ),
                              ),
                            ]),
                            SizedBox(
                                height: DeviceDimensions.screenHeight(context) *
                                    0.01)
                          ],
                        ),
                      ),
                      SizedBox(
                        height: DeviceDimensions.screenHeight(context) * 0.038,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(35)),
                        height: DeviceDimensions.screenHeight(context) * 0.3,
                        width: DeviceDimensions.screenWidth(context) * 0.9,
                        child: Column(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 10),
                                child: Row(
                                  children: [
                                    Text('Add\nSocial Link',
                                        style: TextStyle(
                                            fontSize:
                                                DeviceDimensions.responsiveSize(
                                                        context) *
                                                    0.045,
                                            color: AppColors.textColorBlue,
                                            fontWeight: FontWeight.w600)),
                                    const Spacer(),
                                    SvgPicture.asset('assets/icons/link.svg')
                                  ],
                                ),
                              ),
                            ),
                            Stack(children: [
                              Container(
                                height: DeviceDimensions.screenHeight(context) *
                                    0.20,
                                width: DeviceDimensions.screenWidth(context) *
                                    0.85,
                                decoration: BoxDecoration(
                                  //color: Colors.red,
                                  borderRadius: BorderRadius.circular(35),
                                  image: const DecorationImage(
                                    image: AssetImage(
                                      'assets/images/Subtract1.png',
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: GestureDetector(
                                      onTap: () {
                                        Navigator.pushNamed(
                                            context, '/active-link');
                                      },
                                      child: SvgPicture.asset(
                                        'assets/icons/addsvg.svg',
                                        width: 70,
                                        height: 70,
                                      ))),
                            ]),
                            SizedBox(
                                height: DeviceDimensions.screenHeight(context) *
                                    0.01)
                          ],
                        ),
                      ),
                      SizedBox(
                        height: DeviceDimensions.screenHeight(context) * 0.038,
                      ),
                    ],
                  ),
                ),
              ),
            )
          ])),
    ));
  }
}
