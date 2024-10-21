// ignore_for_file: file_names, unused_field, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nfc_app/provider/connection_provider.dart';
import 'package:nfc_app/provider/loading_state_provider.dart';
import 'package:nfc_app/provider/social_app_provider.dart';
import 'package:nfc_app/provider/user_info_form_state_provider.dart';
import 'package:nfc_app/responsive/device_dimensions.dart';
import 'package:nfc_app/services/auth_service/auth_service.dart';
import 'package:nfc_app/services/firestore_service/firestore_service.dart';
import 'package:nfc_app/utils/ui_mode_helper.dart';
import 'package:nfc_app/widgets/custom_loader_widget.dart';
import 'package:nfc_app/widgets/horizontal_scroll_app_list_widget.dart';
import 'package:nfc_app/widgets/newsletter_popup_widget.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  final AuthService _authService = AuthService();
  // bool _isLoading = true;

  bool direct = true;
  // bool privateprofile = false;
  // bool _dataFetched = false;
  // bool _firstLoadComplete = false;

  @override
  void initState() {
    super.initState();
    final loadingState =
        Provider.of<LoadingStateProvider>(context, listen: false);
    if (!loadingState.dataFetched) {
      _fetchData(loadingState);
    }

    enableImmersiveStickyMode();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserInfoFormStateProvider>(context, listen: false)
          .loadUserData();
    });
    //_checkNewsletterPopup();
  }

  // Future<void> _checkNewsletterPopup() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   bool isPopupShown = prefs.getBool('isNewsletterPopupShown') ?? false;

  //   if (!isPopupShown) {
  //     NewsletterPopup.show(context);
  //     await prefs.setBool('isNewsletterPopupShown', true);
  //   }
  // }

  Future<void> _fetchData(LoadingStateProvider loadingState) async {
    // Simulate a data fetch with Firestore
    await Future.delayed(const Duration(seconds: 3)); // Simulate network delay
    // Pre-fetch user profile image
    // final userImageUrl =
    //     Provider.of<UserInfoFormStateProvider>(context, listen: false).imageUrl;
    // if (userImageUrl != null) {
    //   await precacheImage(CachedNetworkImageProvider(userImageUrl), context);
    // }

    // // Pre-fetch social app icons
    // final socialApps = Provider.of<SocialAppProvider>(context, listen: false)
    //     .filteredSocialApps;
    // for (var app in socialApps) {
    //   await precacheImage(CachedNetworkImageProvider(app.icon), context);
    // }

    // // Pre-fetch connection profile images
    // final connections = Provider.of<ConnectionProvider>(context, listen: false)
    //     .addedConnections;
    // for (var connection in connections) {
    //   await precacheImage(
    //       CachedNetworkImageProvider(connection.profileImage), context);
    // }
    loadingState.setLoading(false);
    loadingState.setDataFetched(true);
  }

  @override
  Widget build(BuildContext context) {
    final loadingState = Provider.of<LoadingStateProvider>(context);

    final size = MediaQuery.of(context).size;
    return Consumer3<SocialAppProvider, UserInfoFormStateProvider,
            ConnectionProvider>(
        builder:
            (context, appProvider, userProvider, connectionProvider, child) {
      return SafeArea(
        child: Scaffold(
          backgroundColor: const Color(0xFFEFEFEF),
          extendBody: true,
          body: Stack(
            children: [
              SizedBox(
                height: DeviceDimensions.screenHeight(context),
                width: DeviceDimensions.screenWidth(context),
                child: Image.asset(
                  "assets/images/homebackground2.png",
                  fit: BoxFit.cover,
                ),
              ),
              loadingState.isLoading
                  ? const Center(
                      child: ScreenLoader(),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            height:
                                DeviceDimensions.screenHeight(context) * 0.0001,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 12, right: 12, top: 35),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Image.asset("assets/images/eye.svg"),
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
                                        width: 20),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 9.0, vertical: 4.5),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFFFFF),
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  child: const Text(
                                    "Home",
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTapDown: (TapDownDetails details) {
                                    final Offset position =
                                        details.globalPosition;

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
                                            style:
                                                TextStyle(color: Colors.black),
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
                          const SizedBox(height: 24),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                            ),
                            child: Container(
                              height: size.height / 3.5,
                              width: size.width,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30)),
                              child: Column(
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
                                                  "${userProvider.selectedItem}",
                                                  style: const TextStyle(
                                                    fontSize: 16,
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
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
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
                                                  style:
                                                      TextStyle(fontSize: 14),
                                                ),
                                                Text(
                                                  "Connected",
                                                  style:
                                                      TextStyle(fontSize: 14),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Positioned(
                                        top: 25,
                                        child: CircleAvatar(
                                          radius: 35,
                                          backgroundColor: Colors.black54,
                                          child: CachedNetworkImage(
                                            imageUrl: userProvider.imageUrl!,
                                            imageBuilder:
                                                (context, imageProvider) =>
                                                    CircleAvatar(
                                              radius: 35,
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
                                  const SizedBox(height: 25),
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
                                  const Divider(),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 22, right: 22, bottom: 15),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          "Your Links",
                                          style: TextStyle(fontSize: 14),
                                        ),
                                        Row(
                                          children: [
                                            SvgPicture.asset(
                                                "assets/icons/info-circle.svg"),
                                            const SizedBox(width: 10),
                                            const Text(
                                              "Direct",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            const SizedBox(width: 15),
                                            SizedBox(
                                              height: 33,
                                              width: 45,
                                              child: FittedBox(
                                                fit: BoxFit.fill,
                                                child: Switch(
                                                  activeTrackColor:
                                                      Colors.black,
                                                  value: direct,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      direct = value;
                                                    });
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
                          ),
                          const SizedBox(height: 25),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: Container(
                                  height:
                                      DeviceDimensions.screenHeight(context) *
                                          0.15,
                                  width: DeviceDimensions.screenWidth(context) *
                                      0.9,
                                  decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(30)),
                                  child: Row(
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.all(25),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Add New",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 17),
                                            ),
                                            Text(
                                              "Add new link as business\nor personal branding",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.white),
                                            )
                                          ],
                                        ),
                                      ),
                                      const Spacer(),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.pushNamed(context,
                                              '/active-link'); // Replace with your route name
                                        },
                                        child: Padding(
                                            padding: const EdgeInsets.only(
                                                right: 25),
                                            child: SvgPicture.asset(
                                              "assets/icons/addsvg.svg",
                                              width: 80,
                                              height: 80,
                                            )
                                            //Image.asset("assets/images/group17.png"),
                                            ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                              height: DeviceDimensions.screenHeight(context) *
                                  0.020),
                          Row(
                            children: [
                              Column(
                                children: [
                                  SizedBox(
                                    height:
                                        DeviceDimensions.screenHeight(context) *
                                            0.015,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, "/active-link");
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 15),
                                      child: SizedBox(
                                        height: DeviceDimensions.screenHeight(
                                                context) *
                                            0.18,
                                        width: DeviceDimensions.screenWidth(
                                                context) *
                                            0.5,
                                        child: const HorizontalScrollAppIcons(),
                                        // child: HorizontalScrollAppIcons(
                                        //     appItemsWithLinks: appItemsWithLinks),
                                      ),
                                    ),
                                  ),
                                  //upgrade now
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15),
                                    child: Container(
                                      height: size.height / 16,
                                      width: size.width / 2.2,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(
                                              "assets/icons/diamond.svg"),
                                          // Image.asset("assets/images/upgrade.png"),
                                          const SizedBox(width: 5),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.pushNamed(
                                                  context, '/pricing-plan');
                                            },
                                            child: const Text(
                                              "Upgrade Now",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, '/recent-connected');
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(right: 15, top: 17),
                                  child: Container(
                                    height:
                                        DeviceDimensions.screenHeight(context) *
                                            0.244,
                                    width: size.width / 2.5,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 10.0, left: 17, bottom: 4),
                                          child: Text(
                                            "Recent Connections",
                                            style: TextStyle(
                                              fontFamily: 'Barlow-Regular',
                                              fontSize: DeviceDimensions
                                                      .responsiveSize(context) *
                                                  0.033,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
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
                                                                FontWeight.w600,
                                                            color: Colors.black,
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
                                                                vertical: 3.5),
                                                        child: Row(
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      left:
                                                                          10.0),
                                                              child: Container(
                                                                width: 32,
                                                                height: 32,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
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
                                                                          FontWeight
                                                                              .w600,
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
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      right:
                                                                          15.0),
                                                              child: SvgPicture
                                                                  .asset(
                                                                "assets/icons/connections-manu.svg",
                                                                height: 15,
                                                              ),
                                                            ),
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
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
            ],
          ),
        ),
      );
    });
  }
}
