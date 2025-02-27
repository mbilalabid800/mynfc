// ignore_for_file: file_names, unused_field, avoid_print, use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nfc_app/components/setting_component.dart';
import 'package:nfc_app/constants/appColors.dart';
import 'package:nfc_app/models/faq_model.dart';
import 'package:nfc_app/provider/user_info_form_state_provider.dart';
import 'package:nfc_app/responsive/device_dimensions.dart';
import 'package:nfc_app/services/auth_service/auth_service.dart';
import 'package:nfc_app/services/firestore_service/faq_service.dart';
import 'package:nfc_app/services/nfc_service/nfc_service.dart';
import 'package:nfc_app/shared/common_widgets/custom_app_bar_widget.dart';
import 'package:nfc_app/shared/utils/no_back_button_observer.dart';
import 'package:nfc_app/widgets/change_password.dart';
import 'package:nfc_app/widgets/custom_profile_container_widget.dart';
import 'package:nfc_app/shared/common_widgets/custom_loader_widget.dart';
import 'package:nfc_app/widgets/delete_confirmation_sheet_pre.dart';
import 'package:nfc_app/widgets/change_language.dart';
import 'package:nfc_app/widgets/logout_alert_widget.dart';
import 'package:nfc_app/widgets/switch_profile_type_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../provider/connection_provider.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  List<FaqModel> _faqs = [];
  bool _isLoading = true;

  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _loadFaqs();
    // Provider.of<BiometricHandlerProvider>(context, listen: false)
    //     .loadFingerprintPreference();
  }

  void _loadFaqs() async {
    FaqService faqService = FaqService();
    List<FaqModel> faqs = await faqService.fetchFaqs();
    setState(() {
      _faqs = faqs;
      _isLoading = false;
    });
  }

  // Method to generate the profile link with UID
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

  // Function to increment the NFC tap counter in Firestore
  Future<void> incrementTapCounter() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String uid = user.uid;

      DocumentReference tapCounterRef =
          FirebaseFirestore.instance.collection('users').doc(uid);

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(tapCounterRef);

        if (!snapshot.exists) {
          // Create the document with initial tap count if it doesn't exist
          transaction.set(tapCounterRef, {'tapCount': 1});
        } else {
          int newTapCount = (snapshot['tapCount'] ?? 0) + 1;
          transaction.update(tapCounterRef, {'tapCount': newTapCount});
        }
      });
    } else {
      throw Exception('User not logged in');
    }
  }

  // Method to save the profile link to SharedPreferences
  Future<void> saveProfileLink(String userProfileLink) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userProfileLink', userProfileLink);
  }

  @override
  Widget build(BuildContext context) {
    //final biometricProvider = Provider.of<BiometricHandlerProvider>(context);
    return Consumer<UserInfoFormStateProvider>(
      builder: (context, userProvider, child) {
        return SafeArea(
          child: GlobalBackButtonHandler(
            child: Scaffold(
              backgroundColor: AppColors.screenBackground,
              body: Column(
                children: [
                  SizedBox(
                    height: DeviceDimensions.screenHeight(context) * 0.0001,
                  ),
                  AbsherAppBar(
                    title: 'Settings',
                    onLeftButtonTap: null,
                    rightButton: GestureDetector(
                      onTap: () {
                        //Navigator.pushNamed(context, '/add-employees');
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 9),
                        decoration: const BoxDecoration(
                          color: Color(0xFFFFFFFF),
                          shape: BoxShape.circle,
                        ),
                        child: SvgPicture.asset(
                          'assets/icons/bell.svg',
                          width: 20,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                      height: DeviceDimensions.screenHeight(context) * 0.020),
                  Flexible(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Stack(
                            clipBehavior: Clip.none,
                            alignment: Alignment.topCenter,
                            children: [
                              ClipPath(
                                clipper: CustomContainer(),
                                child: Container(
                                  height: 238,
                                  width: DeviceDimensions.screenWidth(context) *
                                      0.90,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                          height: DeviceDimensions.screenHeight(
                                                  context) *
                                              0.017),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20, right: 36),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              userProvider.profileType,
                                              style: TextStyle(
                                                fontSize: DeviceDimensions
                                                        .responsiveSize(
                                                            context) *
                                                    0.04,
                                                fontWeight: FontWeight.w600,
                                                color: AppColors.textColorBlue,
                                              ),
                                            ),
                                            Provider.of<ConnectionProvider>(
                                                        context)
                                                    .isLoading
                                                ? Text(
                                                    "--",
                                                    style: TextStyle(
                                                      fontSize: DeviceDimensions
                                                              .responsiveSize(
                                                                  context) *
                                                          0.035,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  )
                                                : Text(
                                                    Provider.of<ConnectionProvider>(
                                                                    context)
                                                                .addedConnections
                                                                .length <
                                                            10
                                                        ? "0${Provider.of<ConnectionProvider>(context).addedConnections.length}"
                                                        : "${Provider.of<ConnectionProvider>(context).addedConnections.length}",
                                                    style: TextStyle(
                                                      fontSize: DeviceDimensions
                                                              .responsiveSize(
                                                                  context) *
                                                          0.04,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: AppColors
                                                          .textColorBlue,
                                                    ),
                                                  ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Profile",
                                              style: TextStyle(
                                                fontSize: DeviceDimensions
                                                        .responsiveSize(
                                                            context) *
                                                    0.04,
                                                fontFamily: 'Barlow-Regular',
                                                fontWeight: FontWeight.w500,
                                                color: AppColors.textColorBlue,
                                              ),
                                            ),
                                            Text(
                                              "Connected",
                                              style: TextStyle(
                                                fontSize: DeviceDimensions
                                                        .responsiveSize(
                                                            context) *
                                                    0.035,
                                                fontFamily: 'Barlow-Regular',
                                                color: AppColors.textColorBlue,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                          height: DeviceDimensions.screenHeight(
                                                  context) *
                                              0.080),
                                      SizedBox(
                                        width: DeviceDimensions.screenWidth(
                                                context) *
                                            0.8,
                                        child: Text(
                                          "${userProvider.firstName} ${userProvider.lastName}",
                                          softWrap: true,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize:
                                                DeviceDimensions.responsiveSize(
                                                        context) *
                                                    0.047,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.textColorBlue,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        "${userProvider.designation} at ${userProvider.companyName}",
                                        style: TextStyle(
                                          fontSize:
                                              DeviceDimensions.responsiveSize(
                                                      context) *
                                                  0.035,
                                          letterSpacing: 1.5,
                                          color: AppColors.textColorBlue,
                                        ),
                                      ),
                                      const Spacer(),
                                      const Divider(color: Color(0xFFE0E0E0)),
                                      SizedBox(
                                          height: DeviceDimensions.screenHeight(
                                                  context) *
                                              0.039),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                top: DeviceDimensions.screenHeight(context) *
                                    0.045,
                                child: CircleAvatar(
                                  radius: 40,
                                  backgroundColor: AppColors.appBlueColor,
                                  child: CachedNetworkImage(
                                    imageUrl: userProvider.imageUrl,
                                    imageBuilder: (context, imageProvider) =>
                                        CircleAvatar(
                                      radius: 40,
                                      backgroundImage: imageProvider,
                                    ),
                                    placeholder: (context, url) => const Center(
                                      child: SmallThreeBounceLoader(),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Image.asset(
                                            'assets/images/default_profile.jpg'),
                                  ),
                                ),
                              ),
                              Positioned(
                                left:
                                    DeviceDimensions.screenWidth(context) / 2 -
                                        96,
                                bottom: -10,
                                child: SizedBox(
                                  height:
                                      DeviceDimensions.screenHeight(context) *
                                          0.048,
                                  width: DeviceDimensions.screenWidth(context) *
                                      0.41,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.pushNamed(
                                          context, "/edit-profile");
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.textColorBlue,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                      ),
                                    ),
                                    child: Text(
                                      'Edit Profile',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize:
                                            DeviceDimensions.responsiveSize(
                                                    context) *
                                                0.045,
                                        fontFamily: 'Barlow-Regular',
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                              height: DeviceDimensions.screenHeight(context) *
                                  0.040),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 25.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "App Settings",
                                style: TextStyle(
                                    fontSize: DeviceDimensions.responsiveSize(
                                            context) *
                                        0.045,
                                    fontFamily: 'Barlow-Regular',
                                    color: const Color(0xFF727272),
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                          SizedBox(
                              height: DeviceDimensions.screenHeight(context) *
                                  0.020),
                          Container(
                            width: DeviceDimensions.screenWidth(context) * 0.90,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Column(
                              children: [
                                const SizedBox(height: 8),
                                SettingListComponent(
                                  icons: "assets/icons/settingicon2.svg",
                                  title: "Profile View",
                                  showDivider: true,
                                  callBack: () {
                                    //dummy link
                                    Navigator.pushNamed(
                                        context, '/profile-preview');
                                  },
                                ),
                                SettingListComponent(
                                  icons: "assets/icons/settingicon3.svg",
                                  title: "NFC Cards",
                                  showDivider: true,
                                  callBack: () {
                                    //dummy link
                                    Navigator.pushNamed(
                                      context,
                                      '/card-details',
                                      arguments: {'screenType': 'NFC Cards'},
                                    );
                                  },
                                ),
                                SettingListComponent(
                                  icons: "assets/icons/settingicon3.svg",
                                  title: "Order NFC Card",
                                  showDivider: true,
                                  callBack: () {
                                    //dummy link
                                    Navigator.pushNamed(
                                      context,
                                      '/card-details',
                                      arguments: {
                                        'screenType': 'Order NFC Card'
                                      },
                                    );
                                  },
                                ),

                                SettingListComponent(
                                  icons: "assets/icons/settingicon4.svg",
                                  title: "Order History",
                                  showDivider: true,
                                  callBack: () {
                                    Navigator.pushNamed(
                                        context, '/order-history-screen');
                                  },
                                ),
                                if (userProvider.profileType != 'Individual')
                                  SettingListComponent(
                                    icons: "assets/icons/settingicon5.svg",
                                    title: "Employees List",
                                    showDivider: true,
                                    callBack: () {
                                      Navigator.pushNamed(
                                          context, '/employees-list');
                                    },
                                  ),
                                // SettingListComponent(
                                //   icons: "assets/icons/settingicon8.svg",
                                //   title: "Manage Subscriptions",
                                //   showDivider: true,
                                //   callBack: () {
                                //     Navigator.pushNamed(
                                //         context, '/subscription-screen');
                                //   },
                                // ),
                                SettingListComponent(
                                  icons: "assets/icons/settingicon6.svg",
                                  title: "Write NFC",
                                  showDivider: false,
                                  callBack: () async {
                                    final nfcService = NfcService();

                                    // Generate the deep link with UID
                                    String userprofileLink =
                                        await generateProfileLink();
                                    // Save the link in SharedPreferences
                                    await saveProfileLink(userprofileLink);

                                    // Write the link to the NFC card via NfcService
                                    await nfcService.writeProfileToNfc(
                                        context, userprofileLink);
                                    // String? userId =
                                    //     FirebaseAuth.instance.currentUser?.uid;
                                  },
                                ),
                                // SettingListComponent(
                                //   icons: "assets/icons/settingicon3.svg",
                                //   title: "Switch Profile",
                                //   showDivider: false,
                                //   callBack: () {
                                //     SwitchProfileTypeWidget
                                //         .showSwitchProfileTypeAlertDialog(
                                //             context);
                                //   },
                                // ),
                                // SettingListComponent(
                                //   icons: "assets/icons/settingicon8.svg",
                                //   title: "Enable Fingureprint",
                                //   trailing: SizedBox(
                                //     height: 34,
                                //     width: 45,
                                //     child: FittedBox(
                                //       fit: BoxFit.fill,
                                //       child: Switch(
                                //         activeTrackColor:
                                //             AppColors.appOrangeColor,
                                //         inactiveTrackColor: Colors.grey.shade200,
                                //         inactiveThumbColor:
                                //             AppColors.appBlueColor,
                                //         value: biometricProvider
                                //             .isFingerprintEnabled,
                                //         onChanged: (value) async {
                                //           await biometricProvider
                                //               .toggleFingerprint(value, context);
                                //         },
                                //       ),
                                //     ),
                                //   ),
                                //   callBack: () {},
                                // ),
                                const SizedBox(height: 8),
                              ],
                            ),
                          ),
                          SizedBox(
                            height:
                                DeviceDimensions.screenHeight(context) * 0.03,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 25.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "App Information",
                                style: TextStyle(
                                  fontSize:
                                      DeviceDimensions.responsiveSize(context) *
                                          0.045,
                                  fontFamily: 'Barlow-Regular',
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF727272),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                              height: DeviceDimensions.screenHeight(context) *
                                  0.020),
                          Container(
                            width: DeviceDimensions.screenWidth(context) * 0.90,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Column(
                              children: [
                                const SizedBox(height: 8),
                                SettingListComponent(
                                  icons: "assets/icons/settingicon9.svg",
                                  title: "Billing",
                                  showDivider: true,
                                  callBack: () {
                                    //dummy link
                                    Navigator.pushNamed(
                                        context, '/billing-screen');
                                  },
                                ),
                                SettingListComponent(
                                  icons: "assets/icons/settingicon10.svg",
                                  title: "Contact us",
                                  showDivider: true,
                                  callBack: () {
                                    //dummy link
                                    Navigator.pushNamed(
                                        context, '/contact-us-screen');
                                  },
                                ),
                                SettingListComponent(
                                  icons: "assets/icons/settingicon11.svg",
                                  title: "How to use",
                                  showDivider: true,
                                  callBack: () {
                                    //dummy link
                                    Navigator.pushNamed(context, '/how-to-use');
                                  },
                                ),
                                SettingListComponent(
                                  icons: "assets/icons/settingicon12.svg",
                                  title: "Language",
                                  showDivider: true,
                                  callBack: () {
                                    ChangeLanguage().changeLanguage(context);
                                  },
                                ),
                                SettingListComponent(
                                  icons: "assets/icons/settingicon13.svg",
                                  title: "FAQs",
                                  showDivider: true,
                                  callBack: () {
                                    //dummy link
                                    Navigator.pushNamed(
                                      context,
                                      '/faq-screen',
                                      arguments: _faqs,
                                    );
                                  },
                                ),
                                SettingListComponent(
                                  icons: "assets/icons/settingicon7.svg",
                                  title: "Change Password",
                                  callBack: () {
                                    showModalBottomSheet(
                                        isScrollControlled: true,
                                        context: context,
                                        builder: (context) {
                                          return Padding(
                                            padding: EdgeInsets.only(
                                              bottom: MediaQuery.of(context)
                                                  .viewInsets
                                                  .bottom,
                                            ),
                                            child: const Wrap(
                                              children: [
                                                ChangePassword(),
                                              ],
                                            ),
                                          );
                                        });
                                  },
                                ),
                                const SizedBox(height: 8),
                              ],
                            ),
                          ),
                          SizedBox(
                            height:
                                DeviceDimensions.screenHeight(context) * 0.035,
                          ),
                          Container(
                            width: DeviceDimensions.screenWidth(context) * 0.90,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Column(
                              children: [
                                const SizedBox(height: 8),
                                SettingListComponent(
                                  icons: "assets/icons/switch_icon.svg",
                                  title: "Switch Profile",
                                  callBack: () {
                                    SwitchProfileTypeWidget
                                        .showSwitchProfileTypeAlertDialog(
                                            context);
                                  },
                                ),
                                const SizedBox(height: 8),
                              ],
                            ),
                          ),
                          SizedBox(
                            height:
                                DeviceDimensions.screenHeight(context) * 0.035,
                          ),
                          Container(
                            width: DeviceDimensions.screenWidth(context) * 0.90,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Column(
                              children: [
                                const SizedBox(height: 8),
                                SettingListComponent(
                                  icons: "assets/icons/settingicon14.svg",
                                  title: "Logout",
                                  callBack: () async {
                                    LogoutAlertWidget.showLogoutAlertDialog(
                                        context);

                                    // await _authService.signOut(context);
                                  },
                                ),
                                const SizedBox(height: 8),
                              ],
                            ),
                          ),
                          SizedBox(
                              height: DeviceDimensions.screenHeight(context) *
                                  0.035),
                          Center(
                            child: InkWell(
                              onTap: () {
                                DeleteConfirmationSheetPre()
                                    .accountDeleteConfirmPre(context);
                              },
                              child: Text(
                                "Delete my account",
                                style: TextStyle(
                                    fontSize: DeviceDimensions.responsiveSize(
                                            context) *
                                        0.036,
                                    fontFamily: 'Barlow-Regular',
                                    color: const Color(0xFF909091),
                                    decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                          SizedBox(
                              height: DeviceDimensions.screenHeight(context) *
                                  0.003),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, "/privacy-policy");
                                },
                                child: Text(
                                  "Privacy policy",
                                  style: TextStyle(
                                      fontSize: DeviceDimensions.responsiveSize(
                                              context) *
                                          0.036,
                                      fontFamily: 'Barlow-Regular',
                                      color: const Color(0xFF909091),
                                      decoration: TextDecoration.underline,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              SizedBox(
                                  width: DeviceDimensions.screenWidth(context) *
                                      0.020),
                              Text(
                                "&",
                                style: TextStyle(
                                    fontSize: DeviceDimensions.responsiveSize(
                                            context) *
                                        0.036,
                                    fontFamily: 'Barlow-Regular',
                                    color: const Color(0xFF909091),
                                    fontWeight: FontWeight.w500),
                              ),
                              SizedBox(
                                  width: DeviceDimensions.screenWidth(context) *
                                      0.020),
                              InkWell(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, "/terms-conditions");
                                },
                                child: Text(
                                  "Terms and Conditions",
                                  style: TextStyle(
                                      fontSize: DeviceDimensions.responsiveSize(
                                              context) *
                                          0.036,
                                      fontFamily: 'Barlow-Regular',
                                      decoration: TextDecoration.underline,
                                      color: const Color(0xFF909091),
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height:
                                DeviceDimensions.screenHeight(context) * 0.035,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
