import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nfc_app/constants/appColors.dart';
import 'package:nfc_app/provider/user_info_form_state_provider.dart';
import 'package:nfc_app/responsive/device_dimensions.dart';
import 'package:nfc_app/shared/common_widgets/custom_app_bar_widget.dart';
import 'package:nfc_app/shared/common_widgets/custom_loader_widget.dart';

import 'package:nfc_app/widgets/share_profile_widget.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ShareProfileScreen extends StatefulWidget {
  const ShareProfileScreen({super.key});

  @override
  State<ShareProfileScreen> createState() => _ShareProfileScreenState();
}

class _ShareProfileScreenState extends State<ShareProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenBackground,
      // appBar: CustomAppBar(title: "Share Profile"),
      body: Column(
        children: [
          SizedBox(
            height: DeviceDimensions.screenHeight(context) * 0.0001,
          ),
          AbsherAppBar(
            title: 'Share Profile',
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
          Flexible(
            child: SingleChildScrollView(
              child: Center(
                child: Consumer<UserInfoFormStateProvider>(
                  builder: (context, userProvider, child) {
                    String profileLink =
                        'https://website.myabsher.com/#/profile/${userProvider.uid}';
                    return Column(
                      children: [
                        Container(
                          width: DeviceDimensions.screenWidth(context) * 0.92,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            children: [
                              SizedBox(
                                  height:
                                      DeviceDimensions.screenHeight(context) *
                                          0.010),
                              Padding(
                                padding: EdgeInsets.all(15.0),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 35,
                                      backgroundColor: AppColors.appBlueColor,
                                      child: CachedNetworkImage(
                                        imageUrl: userProvider.imageUrl,
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                CircleAvatar(
                                          radius: 35,
                                          backgroundImage: imageProvider,
                                        ),
                                        placeholder: (context, url) => Center(
                                          child: SmallThreeBounceLoader(),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Image.asset(
                                                'assets/images/default_profile.jpg'),
                                      ),
                                    ),
                                    SizedBox(
                                        width: DeviceDimensions.screenWidth(
                                                context) *
                                            0.040),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: DeviceDimensions.screenWidth(
                                                  context) *
                                              0.6,
                                          child: Text(
                                            "${userProvider.firstName} ${userProvider.lastName}",
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            softWrap: true,
                                            style: TextStyle(
                                              fontSize: DeviceDimensions
                                                      .responsiveSize(context) *
                                                  0.042,
                                              fontFamily: 'Barlow-Bold',
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.textColorBlue,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          userProvider.email,
                                          style: TextStyle(
                                            fontSize:
                                                DeviceDimensions.responsiveSize(
                                                        context) *
                                                    0.042,
                                            fontFamily: 'Barlow-Regular',
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.textColorBlue,
                                          ),
                                        ),
                                      ],
                                    ),
                                    // SvgPicture.asset(
                                    //   "assets/icons/more5.svg",
                                    //   height: 25,
                                    // ),
                                  ],
                                ),
                              ),
                              Divider(),
                              SizedBox(
                                  height:
                                      DeviceDimensions.screenHeight(context) *
                                          0.030),
                              Center(
                                child: QrImageView(
                                  data: profileLink,
                                  version: QrVersions.auto,
                                  size: 210,
                                ),
                              ),
                              SizedBox(
                                  height:
                                      DeviceDimensions.screenHeight(context) *
                                          0.035),
                              SizedBox(
                                height: DeviceDimensions.screenHeight(context) *
                                    0.060,
                                width: DeviceDimensions.screenWidth(context) *
                                    0.80,
                                child: ElevatedButton(
                                  onPressed: () {
                                    ShareProfile()
                                        .shareProfile(context, profileLink);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.appBlueColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    padding: EdgeInsets.zero,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Share",
                                        style: TextStyle(
                                          fontSize:
                                              DeviceDimensions.responsiveSize(
                                                      context) *
                                                  0.045,
                                          fontFamily: 'Barlow-Regular',
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 1,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(
                                          width: DeviceDimensions.screenWidth(
                                                  context) *
                                              0.02),
                                      SvgPicture.asset(
                                        "assets/icons/arrow_farward.svg",
                                        height: 12,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                  height:
                                      DeviceDimensions.screenHeight(context) *
                                          0.030),
                            ],
                          ),
                        ),
                        // SizedBox(
                        //     height:
                        //         DeviceDimensions.screenHeight(context) * 0.020),
                        // Container(
                        //   width: DeviceDimensions.screenWidth(context) * 0.92,
                        //   decoration: BoxDecoration(
                        //     color: Colors.white,
                        //     borderRadius: BorderRadius.circular(20),
                        //   ),
                        //   child: Padding(
                        //     padding: const EdgeInsets.symmetric(
                        //         horizontal: 18, vertical: 20),
                        //     child: Row(
                        //       children: [
                        //         Image.asset("assets/icons/wallet.png",
                        //             height: 26),
                        //         SizedBox(
                        //             width:
                        //                 DeviceDimensions.screenWidth(context) *
                        //                     0.030),
                        //         Text(
                        //           "Add to Google Wallet",
                        //           style: TextStyle(
                        //             fontSize: DeviceDimensions.responsiveSize(
                        //                     context) *
                        //                 0.052,
                        //             fontFamily: 'Barlow-Regular',
                        //             fontWeight: FontWeight.w600,
                        //             color: AppColors.textColorBlue,
                        //           ),
                        //         )
                        //       ],
                        //     ),
                        //   ),
                        // ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
