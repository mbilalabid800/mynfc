// ignore_for_file: file_names, unused_field, avoid_print, use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
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
import 'package:nfc_app/widgets/change_password.dart';
import 'package:nfc_app/widgets/custom_profile_container_widget.dart';
import 'package:nfc_app/widgets/custom_loader_widget.dart';
import 'package:nfc_app/widgets/delete_confirmation_sheet_pre.dart';
import 'package:nfc_app/widgets/change_language.dart';
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
      String userProfileLink =
          'https://nfcapp.com/connection-profile-preview/$uid';
      return userProfileLink;
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
    return Consumer<UserInfoFormStateProvider>(
      builder: (context, userProvider, child) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: AppColors.screenBackground,
            body: Column(
              children: [
                SizedBox(
                  height: DeviceDimensions.screenHeight(context) * 0.0001,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12, right: 12, top: 35),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, "/profile-preview");
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 9),
                          decoration: const BoxDecoration(
                            color: Color(0xFFFFFFFF),
                            shape: BoxShape.circle,
                          ),
                          child: SvgPicture.asset('assets/icons/eye2.svg',
                              width: 20),
                        ),
                      ),
                      const Text(
                        "Setting",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      GestureDetector(
                        onTapDown: (TapDownDetails details) {
                          final Offset position = details.globalPosition;

                          // Show the popup menu directly inside onTapDown
                          showMenu(
                            color: Colors.white,
                            context: context,
                            position: RelativeRect.fromLTRB(
                              position.dx, // X position
                              position.dy, // Y position
                              position.dx,
                              position.dy,
                            ),
                            items: [
                              const PopupMenuItem(
                                child: Text(
                                  'Coming Soon',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ],
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 9),
                          decoration: const BoxDecoration(
                            color: Color(0xFFFFFFFF),
                            shape: BoxShape.circle,
                          ),
                          child: SvgPicture.asset(
                            'assets/icons/cut2.svg',
                            width: 20,
                          ),
                        ),
                      ),
                    ],
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
                                height: 235,
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
                                            "${userProvider.selectedItem}",
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Provider.of<ConnectionProvider>(
                                                      context)
                                                  .isLoading
                                              ? const Text(
                                                  "--",
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                )
                                              : Text(
                                                  Provider.of<ConnectionProvider>(
                                                                  context)
                                                              .addedConnections
                                                              .length <
                                                          10
                                                      ? "0${Provider.of<ConnectionProvider>(context).addedConnections.length}+"
                                                      : "${Provider.of<ConnectionProvider>(context).addedConnections.length}+",
                                                  style: const TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                        ],
                                      ),
                                    ),
                                    const Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 20),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Profile",
                                            style: TextStyle(fontSize: 14),
                                          ),
                                          Text(
                                            "Connected",
                                            style: TextStyle(fontSize: 14),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                        height: DeviceDimensions.screenHeight(
                                                context) *
                                            0.075),
                                    Text(
                                      "${userProvider.firstName} ${userProvider.lastName}",
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      "${userProvider.designation} at ${userProvider.companyName}",
                                      style: const TextStyle(
                                          fontSize: 13, letterSpacing: 1.5),
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
                                backgroundColor: Colors.black54,
                                child: CachedNetworkImage(
                                  imageUrl: userProvider.imageUrl!,
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
                              left: DeviceDimensions.screenWidth(context) / 2 -
                                  96,
                              bottom: -10,
                              child: SizedBox(
                                height: DeviceDimensions.screenHeight(context) *
                                    0.048,
                                width: DeviceDimensions.screenWidth(context) *
                                    0.41,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, "/edit-profile");
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF202020),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                  ),
                                  child: Text(
                                    'Edit Profile',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: DeviceDimensions.responsiveSize(
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
                            height:
                                DeviceDimensions.screenHeight(context) * 0.040),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "App Settings",
                              style: TextStyle(
                                  fontSize:
                                      DeviceDimensions.responsiveSize(context) *
                                          0.045,
                                  fontFamily: 'Barlow-Regular',
                                  color: const Color(0xFF727272),
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        SizedBox(
                            height:
                                DeviceDimensions.screenHeight(context) * 0.020),
                        Container(
                          width: DeviceDimensions.screenWidth(context) * 0.90,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Column(
                            children: [
                              const SizedBox(height: 8),
                              // SettingListComponent(
                              //   icons: "assets/icons/settingicon1.svg",
                              //   title: "Account Information",
                              //   showDivider: true,
                              //   callBack: () {
                              //     //dummy link
                              //     Navigator.pushNamed(
                              //         context, '/privacy-policy');
                              //   },
                              // ),
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
                                title: "Business Cards",
                                showDivider: true,
                                callBack: () {
                                  //dummy link
                                  Navigator.pushNamed(context, '/card-details');
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
                              SettingListComponent(
                                icons: "assets/icons/settingicon5.svg",
                                title: "Company Leads",
                                showDivider: true,
                                callBack: () {
                                  //dummy link
                                  Navigator.pushNamed(
                                      context, '/privacy-policy');
                                },
                              ),
                              SettingListComponent(
                                icons: "assets/icons/settingicon6.svg",
                                title: "Write NFC",
                                showDivider: true,
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
                          height: DeviceDimensions.screenHeight(context) * 0.03,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
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
                            height:
                                DeviceDimensions.screenHeight(context) * 0.020),
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
                                icons: "assets/icons/settingicon8.svg",
                                title: "Manage Subscriptions",
                                showDivider: true,
                                callBack: () {
                                  Navigator.pushNamed(
                                      context, '/subscription-screen');
                                },
                              ),
                              SettingListComponent(
                                icons: "assets/icons/settingicon9.svg",
                                title: "Billing",
                                showDivider: true,
                                callBack: () {
                                  //dummy link
                                  Navigator.pushNamed(
                                      context, '/privacy-policy');
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
                                title: "How to use sahab",
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
                                callBack: () {
                                  //dummy link
                                  Navigator.pushNamed(
                                    context,
                                    '/faq-screen',
                                    arguments: _faqs,
                                  );
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
                                  await _authService.signOut(context);
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
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              DeleteConfirmationSheetPre()
                                  .accountDeleteConfirmPre(context);
                            },
                            child: Text(
                              "Delete my account",
                              style: TextStyle(
                                  fontSize:
                                      DeviceDimensions.responsiveSize(context) *
                                          0.036,
                                  fontFamily: 'Barlow-Regular',
                                  color: const Color(0xFF909091),
                                  decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, "/privacy-settings");
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
                                  fontSize:
                                      DeviceDimensions.responsiveSize(context) *
                                          0.036,
                                  fontFamily: 'Barlow-Regular',
                                  color: const Color(0xFF909091),
                                  fontWeight: FontWeight.w500),
                            ),
                            SizedBox(
                                width: DeviceDimensions.screenWidth(context) *
                                    0.020),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, "/terms-conditions");
                              },
                              child: Text(
                                "Terms of conditions",
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
        );
      },
    );
  }
}
