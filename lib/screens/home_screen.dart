// ignore_for_file: file_names, unused_field, use_build_context_synchronously, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nfc_app/constants/appColors.dart';
import 'package:nfc_app/provider/connection_provider.dart';
import 'package:nfc_app/provider/loading_state_provider.dart';
import 'package:nfc_app/provider/social_app_provider.dart';
import 'package:nfc_app/provider/user_info_form_state_provider.dart';
import 'package:nfc_app/responsive/device_dimensions.dart';
import 'package:nfc_app/services/auth_service/auth_service.dart';
import 'package:nfc_app/services/firestore_service/firestore_service.dart';
import 'package:nfc_app/widgets/blocked_widget.dart';
import 'package:nfc_app/shared/common_widgets/custom_loader_widget.dart';
import 'package:nfc_app/widgets/horizontal_scroll_app_list_widget.dart';
//import 'package:nfc_app/widgets/newsletter_popup_widget.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
//import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  final AuthService _authService = AuthService();
  // bool direct = true;

  @override
  void initState() {
    super.initState();

    final userInfoProvider =
        Provider.of<UserInfoFormStateProvider>(context, listen: false);
    final socialAppProvider =
        Provider.of<SocialAppProvider>(context, listen: false);
    final connectionProvider =
        Provider.of<ConnectionProvider>(context, listen: false);
    final loadingState =
        Provider.of<LoadingStateProvider>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!loadingState.dataFetched) {
        loadingState.setLoading(true);
        await userInfoProvider.loadUserData();
        await socialAppProvider.loadSocialApps();
        await connectionProvider.loadAddedConnections();

        if (mounted) {
          loadingState.setDataFetched(true);
          loadingState.setLoading(false);
        }
      }
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        _isBlocked(userInfoProvider);
      }
    });
    //Future.delayed(Duration(seconds: 10), _checkNewsletterPopup);
  }

  Future<void> _isBlocked(UserInfoFormStateProvider userProvider) async {
    if (userProvider.isBlocked && mounted) {
      Blocked().show(context);
    }
  }

  // Future<void> _checkNewsletterPopup() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   bool isPopupShown = prefs.getBool('isNewsletterPopupShown') ?? false;

  //   if (!isPopupShown) {
  //     NewsletterPopup.show(context);
  //     await prefs.setBool('isNewsletterPopupShown', true);
  //   }
  // }

  @override
  void dispose() {
    // Example: Cancel any stream subscriptions or timers
    //_streamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loadingState = Provider.of<LoadingStateProvider>(context);
    return Consumer3<SocialAppProvider, UserInfoFormStateProvider,
        ConnectionProvider>(
      builder: (context, appProvider, userProvider, connectionProvider, child) {
        return SafeArea(
          child: Scaffold(
            // backgroundColor: const Color(0xFFEFEFEF),
            extendBody: true,
            body: Stack(
              children: [
                // Container(
                //   color: Color.fromARGB(255, 41, 41,
                //       41), // Use same background color as `Scaffold`
                // ),
                SizedBox(
                  height: DeviceDimensions.screenHeight(context),
                  width: DeviceDimensions.screenWidth(context),
                  child: ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(
                          0.5), // You can change the color and opacity
                      BlendMode
                          .darken, // You can choose different blend modes (darken, lighten, etc.)
                    ),
                    child: Image.asset(
                      "assets/images/homebackground8.jpeg",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Stack(
                  children: [
                    if (!loadingState.isLoading)
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(
                              height: DeviceDimensions.screenHeight(context) *
                                  0.0001,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 12, right: 12, top: 25),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, "/profile-preview");
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12.0, vertical: 9),
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFFFFFFF),
                                        shape: BoxShape.circle,
                                      ),
                                      child: SvgPicture.asset(
                                        'assets/icons/eye2.svg',
                                        width: 20,
                                        //color: AppColors.appBlueColor
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 4.5),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFFFFFF),
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    child: const Text(
                                      "Home",
                                      style: TextStyle(
                                        fontFamily: 'Barlow-Bold',
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textColorBlue,
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, '/add-employees');
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
                                          color: AppColors.appBlueColor),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                                height: DeviceDimensions.screenHeight(context) *
                                    0.028),
                            Container(
                              width:
                                  DeviceDimensions.screenWidth(context) * 0.92,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30)),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Stack(
                                    alignment: Alignment.center,
                                    clipBehavior: Clip.none,
                                    children: [
                                      Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 22, right: 36, top: 20),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  userProvider.selectedItem ??
                                                      'Not Select',
                                                  style: TextStyle(
                                                    fontFamily: 'Barlow-Bold',
                                                    fontSize: DeviceDimensions
                                                            .responsiveSize(
                                                                context) *
                                                        0.049,
                                                    color:
                                                        AppColors.textColorBlue,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                connectionProvider.isLoading
                                                    ? const Text(
                                                        "--",
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: AppColors
                                                                .textColorBlue),
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
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: AppColors
                                                                .textColorBlue),
                                                      ),
                                              ],
                                            ),
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 22),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "Profile",
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontFamily:
                                                          'Barlow-Regular',
                                                      color: AppColors
                                                          .textColorBlue),
                                                ),
                                                Text(
                                                  "Connected",
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontFamily:
                                                          'Barlow-Regular',
                                                      color: AppColors
                                                          .textColorBlue),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Positioned(
                                        top: 25,
                                        child: CircleAvatar(
                                          radius: 37,
                                          backgroundColor: Colors.black54,
                                          child: CachedNetworkImage(
                                            imageUrl: userProvider.imageUrl,
                                            imageBuilder:
                                                (context, imageProvider) =>
                                                    CircleAvatar(
                                              radius: 37,
                                              backgroundImage: imageProvider,
                                            ),
                                            placeholder: (context, url) =>
                                                const Center(
                                              child: SmallThreeBounceLoader(),
                                            ),
                                            errorWidget: (context, url,
                                                    error) =>
                                                Image.asset(
                                                    'assets/images/default_profile.jpg'),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                      height: DeviceDimensions.screenHeight(
                                              context) *
                                          0.040),
                                  Text(
                                    "${userProvider.firstName} ${userProvider.lastName}",
                                    softWrap: true,
                                    maxLines: 2,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: DeviceDimensions.responsiveSize(
                                              context) *
                                          0.047,
                                      color: AppColors.textColorBlue,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Barlow-Bold',
                                    ),
                                  ),
                                  if (userProvider.companyName == '')
                                    InkWell(
                                      onTap: () {
                                        Navigator.pushNamed(
                                            context, '/edit-profile');
                                      },
                                      child: Text(
                                        "Edit Profile",
                                        style: TextStyle(
                                            fontFamily: 'Barlow-Bold',
                                            fontSize:
                                                DeviceDimensions.responsiveSize(
                                                        context) *
                                                    0.037,
                                            letterSpacing: 1,
                                            color: AppColors.appOrangeColor),
                                      ),
                                    )
                                  else
                                    Text(
                                      "${userProvider.designation} at ${userProvider.companyName.isNotEmpty ? userProvider.companyName : 'Company not set'}",
                                      style: TextStyle(
                                        fontFamily: 'Barlow-Regular',
                                        fontSize:
                                            DeviceDimensions.responsiveSize(
                                                    context) *
                                                0.038,
                                        color: AppColors.textColorBlue,
                                        letterSpacing: 1.5,
                                      ),
                                    ),
                                  const SizedBox(height: 15),
                                  const Divider(),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 22, right: 22, bottom: 15),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Your Links",
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: AppColors.textColorBlue,
                                            fontFamily: 'Barlow-Regular',
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            GestureDetector(
                                              onTapDown:
                                                  (TapDownDetails details) {
                                                showMenu(
                                                  color: Colors.grey.shade100,
                                                  context: context,
                                                  position:
                                                      RelativeRect.fromLTRB(
                                                          details.globalPosition
                                                              .dx,
                                                          details.globalPosition
                                                              .dy,
                                                          details.globalPosition
                                                              .dx,
                                                          details.globalPosition
                                                              .dy),
                                                  items: [
                                                    PopupMenuItem(
                                                      child: Text(
                                                        "Turn on for Private Profile",
                                                        style: TextStyle(
                                                          color: AppColors
                                                              .textColorBlue,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
                                              child: SvgPicture.asset(
                                                "assets/icons/info-circle.svg",
                                              ),
                                            ),
                                            const SizedBox(width: 7),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 2.0),
                                              child: const Text(
                                                "Private",
                                                style: TextStyle(
                                                  fontSize: 17,
                                                  color:
                                                      AppColors.textColorBlue,
                                                  fontWeight: FontWeight.w600,
                                                  fontFamily: 'Barlow-Regular',
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            SizedBox(
                                              height: 33,
                                              width: 45,
                                              child: FittedBox(
                                                fit: BoxFit.fill,
                                                child: Switch(
                                                  activeTrackColor:
                                                      AppColors.appOrangeColor,
                                                  value: userProvider.isPrivate,
                                                  onChanged: (isPrivate) {
                                                    userProvider
                                                        .updateIsPrivate(
                                                            isPrivate);
                                                  },
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                                height: DeviceDimensions.screenHeight(context) *
                                    0.032),
                            Container(
                              width:
                                  DeviceDimensions.screenWidth(context) * 0.92,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Row(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 25, vertical: 18),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Add New",
                                          style: TextStyle(
                                              color: AppColors.appBlueColor,
                                              fontFamily: 'Barlow-Bold',
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          "Add new link as business\nor personal branding",
                                          style: TextStyle(
                                              fontFamily: 'Barlow-Regular',
                                              fontSize: 15,
                                              color: Colors.white),
                                        )
                                      ],
                                    ),
                                  ),
                                  const Spacer(),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, '/active-link');
                                    },
                                    child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 25),
                                        child: SvgPicture.asset(
                                          "assets/icons/addsvg.svg",
                                          width: 80,
                                          height: 80,
                                          //color: AppColors.appBlueColor,
                                        )),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                                height: DeviceDimensions.screenHeight(context) *
                                    0.039),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          Navigator.pushNamed(
                                              context, "/active-link");
                                        },
                                        child: SizedBox(
                                          width: DeviceDimensions.screenWidth(
                                                  context) *
                                              0.5,
                                          child:
                                              const HorizontalScrollAppIcons(),
                                        ),
                                      ),
                                      SizedBox(
                                          height: DeviceDimensions.screenHeight(
                                                  context) *
                                              0.020),
                                      //upgrade now
                                      InkWell(
                                        onTap: () {
                                          Navigator.pushNamed(
                                              context, '/pricing-plan');
                                        },
                                        child: Container(
                                          height: DeviceDimensions.screenHeight(
                                                  context) *
                                              0.06,
                                          width: DeviceDimensions.screenWidth(
                                                  context) *
                                              0.48,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(22),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SvgPicture.asset(
                                                  "assets/icons/diamond.svg"),
                                              // Image.asset("assets/images/upgrade.png"),
                                              const SizedBox(width: 10),
                                              const Text(
                                                "Upgrade Now",
                                                style: TextStyle(
                                                    fontFamily: 'Barlow-Bold',
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        AppColors.textColorBlue,
                                                    fontSize: 17),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, '/recent-connected');
                                    },
                                    child: Container(
                                      height: 195,
                                      width: DeviceDimensions.screenWidth(
                                              context) *
                                          0.41,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 5, top: 07, bottom: 4),
                                            child: Center(
                                              child: Text(
                                                "Recent Connections",
                                                style: TextStyle(
                                                  fontFamily: 'Barlow-Regular',
                                                  fontSize: DeviceDimensions
                                                          .responsiveSize(
                                                              context) *
                                                      0.036,
                                                  fontWeight: FontWeight.w700,
                                                  color:
                                                      AppColors.textColorBlue,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: connectionProvider.isLoading
                                                ? const SmallThreeBounceLoader()
                                                : ListView.builder(
                                                    physics:
                                                        const NeverScrollableScrollPhysics(),
                                                    itemCount: connectionProvider
                                                            .addedConnections
                                                            .isEmpty
                                                        ? 1
                                                        : connectionProvider
                                                                    .addedConnections
                                                                    .length >
                                                                4
                                                            ? 4
                                                            : connectionProvider
                                                                .addedConnections
                                                                .length,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      if (connectionProvider
                                                          .addedConnections
                                                          .isEmpty) {
                                                        return Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  top: 50.0,
                                                                  left: 35),
                                                          child: Text(
                                                            'Connect Now',
                                                            style: TextStyle(
                                                              fontSize: DeviceDimensions
                                                                      .responsiveSize(
                                                                          context) *
                                                                  0.032,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color: AppColors
                                                                  .textColorBlue,
                                                            ),
                                                          ),
                                                        );
                                                      } else {
                                                        final reversedConnections =
                                                            connectionProvider
                                                                .addedConnections
                                                                .reversed
                                                                .toList();
                                                        final connection =
                                                            reversedConnections[
                                                                index];
                                                        return Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  vertical:
                                                                      3.5),
                                                          child: Row(
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            10.0),
                                                                child:
                                                                    Container(
                                                                  width: 32,
                                                                  height: 32,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            35),
                                                                    color: Colors
                                                                        .black54,
                                                                    image:
                                                                        DecorationImage(
                                                                      image: CachedNetworkImageProvider(connection
                                                                              .profileImage
                                                                              .isNotEmpty
                                                                          ? connection
                                                                              .profileImage
                                                                          : 'https://firebasestorage.googleapis.com/v0/b/nfc-project-21b56.appspot.com/o/default_profile.jpg?alt=media&token=dec3b09a-d6fd-47a2-ae5b-cb0e248ae21c'),
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                  width: 10.0),
                                                              Expanded(
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      connection
                                                                          .firstName,
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            DeviceDimensions.responsiveSize(context) *
                                                                                0.028,
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                        color: AppColors
                                                                            .textColorBlue,
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      connection
                                                                          .designation,
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            DeviceDimensions.responsiveSize(context) *
                                                                                0.020,
                                                                        color: const Color(
                                                                            0xFF909091),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              // Padding(
                                                              //   padding:
                                                              //       const EdgeInsets
                                                              //           .only(
                                                              //           right:
                                                              //               15.0),
                                                              //   child:
                                                              //       SvgPicture
                                                              //           .asset(
                                                              //     "assets/icons/connections-manu.svg",
                                                              //     height: 15,
                                                              //   ),
                                                              // ),
                                                            ],
                                                          ),
                                                        );
                                                      }
                                                    },
                                                  ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                                height: DeviceDimensions.screenHeight(context) *
                                    0.029),
                          ],
                        ),
                      ),
                    if (loadingState.isLoading)
                      const Center(
                        child: ScreenLoader(),
                      ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
