// ignore_for_file: avoid_print

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nfc_app/constants/appColors.dart';
import 'package:nfc_app/provider/connection_provider.dart';
import 'package:nfc_app/provider/social_app_provider.dart';
import 'package:nfc_app/provider/user_info_form_state_provider.dart';
import 'package:nfc_app/services/firestore_service/firestore_service.dart';
import 'package:nfc_app/widgets/charts_widget.dart';
import 'package:nfc_app/responsive/device_dimensions.dart';
import 'package:nfc_app/widgets/time_frame_list_widget.dart';
import 'package:provider/provider.dart';

class GraphScreen extends StatefulWidget {
  final String uid; // Pass this UID from your user data
  const GraphScreen({super.key, required this.uid});

  @override
  State<GraphScreen> createState() => _GraphScreenState();
}

class _GraphScreenState extends State<GraphScreen> {
  int tapCount = 0; // State variable to store the tap count

  @override
  void initState() {
    super.initState();
    fetchTapCount();
    // Call the method to fetch tap count from Firestore
  }

  Future<void> fetchTapCount() async {
    // Get the current user's UID from Firebase Authentication
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      String userId = user.uid; // Get the current user's UID dynamically
      int count = await FirestoreService().getTapCount(userId);
      setState(() {
        tapCount = count; // Update the state with fetched tap count
      });
    } else {
      print(
          'User not logged in'); // Handle the case where the user is not logged in
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserInfoFormStateProvider>(context);

    // Call loadChartsData() to start listening for real-time changes
    userProvider.loadChartsData();
    return SafeArea(
      child: Scaffold(
          backgroundColor: const Color(0xFFEFEFEF),
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: DeviceDimensions.screenHeight(context) * 0.04,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12, right: 12, top: 10),
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7.0, vertical: 9),
                        decoration: const BoxDecoration(
                            //color: Color(0xFFFFFFFF),
                            //shape: BoxShape.circle,
                            ),
                        child: const CircleAvatar(
                          backgroundColor: Color.fromARGB(255, 206, 199, 199),
                          backgroundImage: AssetImage(
                            'assets/icons/cardprofile.png',
                          ),
                          radius: 28,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Business Card",
                            style: TextStyle(
                                fontSize:
                                    DeviceDimensions.responsiveSize(context) *
                                        0.045,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontFamily: 'Barlow-Bold'),
                          ),
                          Text(
                            "Activation Date: 19/11/2022",
                            style: TextStyle(
                                fontSize:
                                    DeviceDimensions.responsiveSize(context) *
                                        0.035,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Barlow-Regular'),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(right: 5.0, bottom: 5),
                        child: SizedBox(
                          height: 30,
                          width: 90,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/privacy-policy');
                            },
                            style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.zero,
                                backgroundColor: Colors.black,
                                foregroundColor: Colors.white),
                            child: Text(
                              "Personal",
                              style: TextStyle(
                                fontFamily: 'Barlow-Regular',
                                fontWeight: FontWeight.w500,
                                fontSize:
                                    DeviceDimensions.responsiveSize(context) *
                                        0.045,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: DeviceDimensions.screenHeight(context) * 0.02,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(35)),
                  width: DeviceDimensions.screenWidth(context) * 0.9,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10),
                        child: Image.asset('assets/images/imagecardpng.png',
                            width: DeviceDimensions.screenWidth(context) * 0.7),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: DeviceDimensions.screenHeight(context) * 0.02,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Performance',
                          style: TextStyle(
                              fontSize:
                                  DeviceDimensions.responsiveSize(context) *
                                      0.045,
                              fontWeight: FontWeight.w600))),
                ),
                TimeFrameList(
                  onSelected: (selectedTimeFrame) {
                    // Handle the selected time frame here
                    print('Selected Time Frame: $selectedTimeFrame');
                  },
                ),
                SizedBox(
                  height: DeviceDimensions.screenHeight(context) * 0.02,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/full-screen-graph',
                                arguments: _buildGraph1(),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white),
                              height:
                                  DeviceDimensions.screenHeight(context) * 0.17,
                              width:
                                  DeviceDimensions.screenWidth(context) * 0.45,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Consumer<UserInfoFormStateProvider>(
                                            builder:
                                                (context, userProvider, child) {
                                          return Text(
                                            userProvider.viewCount.toString(),
                                            style: TextStyle(
                                                overflow: TextOverflow.ellipsis,
                                                fontSize: DeviceDimensions
                                                        .responsiveSize(
                                                            context) *
                                                    0.06,
                                                fontWeight: FontWeight.w500),
                                            softWrap: true,
                                            maxLines: 2,
                                          );
                                        }),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                      height: DeviceDimensions.screenHeight(
                                              context) *
                                          0.05,
                                      width: DeviceDimensions.screenWidth(
                                              context) *
                                          0.3,
                                      child: ViewsChart(uid: widget.uid)),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          SvgPicture.asset(
                                              'assets/icons/views.svg'),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: Text(
                                              'Views',
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              style: TextStyle(
                                                  fontSize: DeviceDimensions
                                                          .responsiveSize(
                                                              context) *
                                                      0.032),
                                            ),
                                          ),
                                          const Spacer(),
                                          GestureDetector(
                                            onTapDown:
                                                (TapDownDetails details) {
                                              _showPopupMenu(
                                                  context,
                                                  details.globalPosition,
                                                  'The number of times your profile was  viewed through tapping your profile.');
                                            },
                                            child: SvgPicture.asset(
                                                'assets/icons/info.svg'),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                              width: DeviceDimensions.screenWidth(context) *
                                  0.025),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/full-screen-graph',
                                arguments: _buildGraph2(),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white),
                              height:
                                  DeviceDimensions.screenHeight(context) * 0.17,
                              width:
                                  DeviceDimensions.screenWidth(context) * 0.45,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Text('1.6 K',
                                            style: TextStyle(
                                                fontSize: DeviceDimensions
                                                        .responsiveSize(
                                                            context) *
                                                    0.05,
                                                fontWeight: FontWeight.w600)),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height:
                                        DeviceDimensions.screenHeight(context) *
                                            0.05,
                                    width:
                                        DeviceDimensions.screenWidth(context) *
                                            0.3,
                                    child: const LinkTapChart(),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          SvgPicture.asset(
                                              'assets/icons/taplink.svg'),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: Text(
                                              'Link Tap',
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              style: TextStyle(
                                                  fontSize: DeviceDimensions
                                                          .responsiveSize(
                                                              context) *
                                                      0.032),
                                            ),
                                          ),
                                          const Spacer(),
                                          GestureDetector(
                                            onTapDown:
                                                (TapDownDetails details) {
                                              _showPopupMenu(
                                                  context,
                                                  details.globalPosition,
                                                  'The number of times your links were tapped.');
                                            },
                                            child: SvgPicture.asset(
                                                'assets/icons/info.svg'),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/full-screen-graph',
                                arguments: _buildGraph3(),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white),
                              height:
                                  DeviceDimensions.screenHeight(context) * 0.17,
                              width:
                                  DeviceDimensions.screenWidth(context) * 0.45,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Text('82',
                                            style: TextStyle(
                                                fontSize: DeviceDimensions
                                                        .responsiveSize(
                                                            context) *
                                                    0.05,
                                                fontWeight: FontWeight.w600)),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height:
                                        DeviceDimensions.screenHeight(context) *
                                            0.05,
                                    width:
                                        DeviceDimensions.screenWidth(context) *
                                            0.3,
                                    child: CardTapsChart(),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8),
                                      child: Row(
                                        children: [
                                          SvgPicture.asset(
                                              'assets/icons/rate.svg',
                                              width: DeviceDimensions
                                                      .responsiveSize(context) *
                                                  0.05),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: Text(
                                              'Card Taps',
                                              overflow: TextOverflow.ellipsis,
                                              softWrap: true,
                                              maxLines: 3,
                                              style: TextStyle(
                                                fontSize: DeviceDimensions
                                                        .responsiveSize(
                                                            context) *
                                                    0.030,
                                              ),
                                            ),
                                          ),
                                          const Spacer(),
                                          GestureDetector(
                                            onTapDown:
                                                (TapDownDetails details) {
                                              _showPopupMenu(
                                                  context,
                                                  details.globalPosition,
                                                  'The number of times you tapped your card on NFC enabled devices');
                                            },
                                            child: SvgPicture.asset(
                                                'assets/icons/info.svg'),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                              width: DeviceDimensions.screenWidth(context) *
                                  0.025),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/full-screen-graph',
                                arguments: _buildGraph4(),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white),
                              height:
                                  DeviceDimensions.screenHeight(context) * 0.17,
                              width:
                                  DeviceDimensions.screenWidth(context) * 0.45,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Text('166',
                                              style: TextStyle(
                                                  fontSize: DeviceDimensions
                                                          .responsiveSize(
                                                              context) *
                                                      0.05,
                                                  fontWeight: FontWeight.w600)),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: DeviceDimensions.screenHeight(
                                              context) *
                                          0.05,
                                      width: DeviceDimensions.screenWidth(
                                              context) *
                                          0.3,
                                      child: const NewContactChart(),
                                    ),
                                    Expanded(
                                      child: Row(
                                        children: [
                                          SvgPicture.asset(
                                              'assets/icons/new_contact.svg'),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: Text(
                                              'New Contact',
                                              overflow: TextOverflow.clip,
                                              maxLines: 2,
                                              style: TextStyle(
                                                  fontSize: DeviceDimensions
                                                          .responsiveSize(
                                                              context) *
                                                      0.032),
                                            ),
                                          ),
                                          const Spacer(),
                                          GestureDetector(
                                            onTapDown:
                                                (TapDownDetails details) {
                                              _showPopupMenu(
                                                  context,
                                                  details.globalPosition,
                                                  'The count of total connections that you are connected with');
                                            },
                                            child: SvgPicture.asset(
                                                'assets/icons/info.svg'),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                        height: DeviceDimensions.screenHeight(context) * 0.04),
                  ],
                )
              ],
            ),
          )),
    );
  }

  void _showPopupMenu(BuildContext context, Offset position, String popupText) {
    showMenu(
      color: Colors.grey.shade100,
      context: context,
      position: RelativeRect.fromLTRB(
          position.dx, position.dy, position.dx, position.dy),
      items: [
        PopupMenuItem(
          child: Text(popupText),
        ),
      ],
    );
  }

  Widget _buildGraph1() {
    return SingleChildScrollView(
      child: Container(
        color: AppColors.screenBackground,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            //color: Colors.white,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  spreadRadius: 2,
                                  blurRadius: 8,
                                  offset: Offset(0, 5)),
                            ]),
                        height: DeviceDimensions.screenHeight(context) * 0.45,
                        width: DeviceDimensions.screenWidth(context) * 0.9,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: SizedBox(
                            height:
                                DeviceDimensions.screenHeight(context) * 0.25,
                            width: DeviceDimensions.screenWidth(context) * 0.7,
                            child: FullViewsChart(uid: widget.uid),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 2),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Total views till your profile has been created',
                          style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              fontSize:
                                  DeviceDimensions.responsiveSize(context) *
                                      0.045,
                              fontWeight: FontWeight.w500),
                          softWrap: true,
                          maxLines: 2,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12.0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Consumer<UserInfoFormStateProvider>(
                                    builder: (context, userProvider, child) {
                                  return Text(
                                    userProvider.viewCount.toString(),
                                    style: TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        fontSize:
                                            DeviceDimensions.responsiveSize(
                                                    context) *
                                                0.098,
                                        fontWeight: FontWeight.w500),
                                    softWrap: true,
                                    maxLines: 2,
                                  );
                                }),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12.0,
                              ),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Total Views',
                                  style: TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    color: Colors.black,
                                    fontSize: DeviceDimensions.responsiveSize(
                                            context) *
                                        0.025,
                                  ),
                                  softWrap: true,
                                  maxLines: 2,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Spacer(),
                        Column(
                          children: [
                            Container(
                              padding: EdgeInsets.only(right: 12),
                              width:
                                  DeviceDimensions.screenWidth(context) * 0.4,
                              height:
                                  DeviceDimensions.screenHeight(context) * 0.12,
                              //color: Colors.red,
                              child: SvgPicture.asset(
                                'assets/icons/barchart_black.svg',
                                height: DeviceDimensions.screenHeight(context) *
                                    0.15,
                              ),
                            ),
                            Row(
                              children: [
                                Text('Views: 53 %',
                                    style: TextStyle(
                                        color: Colors.lightGreen,
                                        fontSize:
                                            DeviceDimensions.responsiveSize(
                                                    context) *
                                                0.03)),
                                Icon(
                                  Icons.trending_up,
                                  color: Colors.lightGreen,
                                ),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                    const Divider(),
                    SizedBox(
                      height: DeviceDimensions.screenHeight(context) * 0.02,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGraph2() {
    final socialApps = Provider.of<SocialAppProvider>(context, listen: false)
        .filteredSocialApps;

    return SingleChildScrollView(
      child: Container(
        color: AppColors.screenBackground,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            //color: Colors.white,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  spreadRadius: 2,
                                  blurRadius: 8,
                                  offset: Offset(0, 5)),
                            ]),
                        height: DeviceDimensions.screenHeight(context) * 0.45,
                        width: DeviceDimensions.screenWidth(context) * 0.9,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: SizedBox(
                            height:
                                DeviceDimensions.screenHeight(context) * 0.25,
                            width: DeviceDimensions.screenWidth(context) * 0.7,
                            child: FullViewsChart(uid: widget.uid),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 2),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Total views till your profile has been created',
                          style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              fontSize:
                                  DeviceDimensions.responsiveSize(context) *
                                      0.045,
                              fontWeight: FontWeight.w500),
                          softWrap: true,
                          maxLines: 2,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12.0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  '53.2 K',
                                  style: TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      fontSize: DeviceDimensions.responsiveSize(
                                              context) *
                                          0.098,
                                      fontWeight: FontWeight.w500),
                                  softWrap: true,
                                  maxLines: 2,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12.0,
                              ),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Total Views',
                                  style: TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    color: AppColors.greyText,
                                    fontSize: DeviceDimensions.responsiveSize(
                                            context) *
                                        0.022,
                                  ),
                                  softWrap: true,
                                  maxLines: 2,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12.0, vertical: 6),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Last Updated Yesterday',
                                  style: TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    fontSize: DeviceDimensions.responsiveSize(
                                            context) *
                                        0.035,
                                    color: AppColors.greyText,
                                  ),
                                  softWrap: true,
                                  maxLines: 2,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Spacer(),
                        Column(
                          children: [
                            Container(
                              padding: EdgeInsets.only(right: 12),
                              width:
                                  DeviceDimensions.screenWidth(context) * 0.4,
                              height:
                                  DeviceDimensions.screenHeight(context) * 0.12,
                              //color: Colors.red,
                              child: SvgPicture.asset(
                                'assets/icons/barchart_black.svg',
                                height: DeviceDimensions.screenHeight(context) *
                                    0.15,
                              ),
                            ),
                            Row(
                              children: [
                                Text('Views: 53 %',
                                    style: TextStyle(
                                        color: Colors.lightGreen,
                                        fontSize:
                                            DeviceDimensions.responsiveSize(
                                                    context) *
                                                0.03)),
                                Icon(
                                  Icons.trending_up,
                                  color: Colors.lightGreen,
                                ),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'App Overview',
                          style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              fontSize:
                                  DeviceDimensions.responsiveSize(context) *
                                      0.055,
                              fontWeight: FontWeight.w500),
                          softWrap: true,
                          maxLines: 2,
                        ),
                      ),
                    ),
                    ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: socialApps.length,
                        itemBuilder: (context, index) {
                          final appItem = socialApps[index];
                          return Padding(
                            padding: EdgeInsets.only(left: 20.0, right: 10),
                            child: ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: Container(
                                width: 35,
                                height: 35,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(35),
                                  color: Colors.black54,
                                  image: DecorationImage(
                                      image: CachedNetworkImageProvider(
                                          appItem.icon),
                                      fit: BoxFit.cover),
                                ),
                              ),
                              title: Text(appItem.name),
                              trailing: Text('0 Taps',
                                  style: TextStyle(
                                      fontSize: DeviceDimensions.responsiveSize(
                                              context) *
                                          0.03)),
                            ),
                          );
                        }),
                    SizedBox(
                      height: DeviceDimensions.screenHeight(context) * 0.02,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGraph3() {
    final List<double> tapsPerDay = [15, 14, 12, 18, 10, 5, 8];

    // Calculate the total taps
    double totalTaps = tapsPerDay.reduce((a, b) => a + b);

    final socialApps = Provider.of<SocialAppProvider>(context, listen: false)
        .filteredSocialApps;

    return SingleChildScrollView(
      child: Container(
        color: AppColors.screenBackground,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            //color: Colors.white,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  spreadRadius: 2,
                                  blurRadius: 8,
                                  offset: Offset(0, 5)),
                            ]),
                        height: DeviceDimensions.screenHeight(context) * 0.45,
                        width: DeviceDimensions.screenWidth(context) * 0.9,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: SizedBox(
                            height:
                                DeviceDimensions.screenHeight(context) * 0.25,
                            width: DeviceDimensions.screenWidth(context) * 0.7,
                            child: FullCardTapsChart(
                              tapsPerDay: tapsPerDay,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 2),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Total number of taps with your NFC Card',
                          style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              fontSize:
                                  DeviceDimensions.responsiveSize(context) *
                                      0.045,
                              fontWeight: FontWeight.w500),
                          softWrap: true,
                          maxLines: 2,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12.0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  '${totalTaps.toInt()} Taps',
                                  style: TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      fontSize: DeviceDimensions.responsiveSize(
                                              context) *
                                          0.098,
                                      fontWeight: FontWeight.w500),
                                  softWrap: true,
                                  maxLines: 2,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12.0,
                              ),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Total Taps',
                                  style: TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    color: AppColors.greyText,
                                    fontSize: DeviceDimensions.responsiveSize(
                                            context) *
                                        0.022,
                                  ),
                                  softWrap: true,
                                  maxLines: 2,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12.0, vertical: 6),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Last Updated Yesterday',
                                  style: TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    fontSize: DeviceDimensions.responsiveSize(
                                            context) *
                                        0.035,
                                    color: AppColors.greyText,
                                  ),
                                  softWrap: true,
                                  maxLines: 2,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Spacer(),
                        Column(
                          children: [
                            Container(
                              padding: EdgeInsets.only(right: 12),
                              width:
                                  DeviceDimensions.screenWidth(context) * 0.4,
                              height:
                                  DeviceDimensions.screenHeight(context) * 0.12,
                              //color: Colors.red,
                              child: SvgPicture.asset(
                                'assets/icons/barchart_black.svg',
                                height: DeviceDimensions.screenHeight(context) *
                                    0.15,
                              ),
                            ),
                            Row(
                              children: [
                                Text('Taps: 53 %',
                                    style: TextStyle(
                                        color: Colors.lightGreen,
                                        fontSize:
                                            DeviceDimensions.responsiveSize(
                                                    context) *
                                                0.03)),
                                Icon(
                                  Icons.trending_up,
                                  color: Colors.lightGreen,
                                ),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Card Taps Overview',
                          style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              fontSize:
                                  DeviceDimensions.responsiveSize(context) *
                                      0.055,
                              fontWeight: FontWeight.w500),
                          softWrap: true,
                          maxLines: 2,
                        ),
                      ),
                    ),
                    ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: socialApps.length,
                        itemBuilder: (context, index) {
                          final appItem = socialApps[index];
                          return Padding(
                            padding: EdgeInsets.only(left: 20.0, right: 10),
                            child: ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: Container(
                                width: 35,
                                height: 35,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(35),
                                  color: Colors.black54,
                                  image: DecorationImage(
                                      image: CachedNetworkImageProvider(
                                          appItem.icon),
                                      fit: BoxFit.cover),
                                ),
                              ),
                              title: Text(appItem.name),
                              trailing: Text('0 Taps',
                                  style: TextStyle(
                                      fontSize: DeviceDimensions.responsiveSize(
                                              context) *
                                          0.03)),
                            ),
                          );
                        }),
                    SizedBox(
                      height: DeviceDimensions.screenHeight(context) * 0.02,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGraph4() {
    final addedconnections =
        Provider.of<ConnectionProvider>(context, listen: false)
            .addedConnections;
    return SingleChildScrollView(
      child: Container(
        color: AppColors.screenBackground,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Column(children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 8,
                                offset: Offset(0, 5)),
                          ]),
                      height: DeviceDimensions.screenHeight(context) * 0.45,
                      width: DeviceDimensions.screenWidth(context) * 0.9,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: SizedBox(
                          height: DeviceDimensions.screenHeight(context) * 0.3,
                          width: DeviceDimensions.screenWidth(context) * 0.7,
                          child: const FullNewContactChart(),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 10,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width:
                              DeviceDimensions.responsiveSize(context) * 0.04,
                          height:
                              DeviceDimensions.responsiveSize(context) * 0.04,
                          color: const Color.fromARGB(255, 69, 69, 69),
                        ),
                        Text(
                          '2023 Year',
                        ),
                        Container(
                          width:
                              DeviceDimensions.responsiveSize(context) * 0.04,
                          height:
                              DeviceDimensions.responsiveSize(context) * 0.04,
                          color: const Color.fromARGB(255, 94, 45, 209),
                        ),
                        Text('2024 Year',
                            style: TextStyle(
                              color: const Color.fromARGB(255, 94, 45, 209),
                            )),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Your New Contacts',
                        style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            fontSize: DeviceDimensions.responsiveSize(context) *
                                0.055,
                            fontWeight: FontWeight.w500),
                        softWrap: true,
                        maxLines: 2,
                      ),
                    ),
                  ),
                  ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: addedconnections.length,
                      itemBuilder: (context, index) {
                        final addedConnection = addedconnections[index];
                        return Padding(
                          padding: EdgeInsets.only(left: 20.0, right: 10),
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: Container(
                              width: 35,
                              height: 35,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(35),
                                color: Colors.black54,
                                image: DecorationImage(
                                    image: CachedNetworkImageProvider(
                                        addedConnection.profileImage),
                                    fit: BoxFit.cover),
                              ),
                            ),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    "${addedConnection.firstName} ${addedConnection.lastName}"),
                                Row(
                                  children: [
                                    Text(
                                      addedConnection.designation,
                                      style: TextStyle(
                                        fontSize:
                                            DeviceDimensions.responsiveSize(
                                                    context) *
                                                0.040,
                                        fontFamily: 'Barlow-Regular',
                                        color: const Color(0xFF909091),
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            //trailing: Icon(Icons.arrow_right)
                          ),
                        );
                      }),
                  SizedBox(
                    height: DeviceDimensions.screenHeight(context) * 0.02,
                  )
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
