// ignore_for_file: use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nfc_app/constants/appColors.dart';
import 'package:nfc_app/provider/social_app_provider.dart';
import 'package:nfc_app/responsive/device_dimensions.dart';
import 'package:nfc_app/shared/common_widgets/custom_app_bar_widget.dart';
import 'package:nfc_app/shared/utils/ui_mode_helper.dart';
import 'package:nfc_app/shared/utils/url_launcher_helper.dart';
import 'package:nfc_app/shared/common_widgets/custom_loader_widget.dart';
import 'package:provider/provider.dart';
import '../provider/user_info_form_state_provider.dart';

class ProfilePreview extends StatefulWidget {
  const ProfilePreview({super.key});

  @override
  State<ProfilePreview> createState() => _ProfilePreviewState();
}

class _ProfilePreviewState extends State<ProfilePreview> {
  @override
  void initState() {
    super.initState();
    enableImmersiveStickyMode();
    final userProvider =
        Provider.of<UserInfoFormStateProvider>(context, listen: false);
    userProvider.loadUserData();
  }

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
              title: 'Profile',
              leftButton: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 9),
                    decoration: const BoxDecoration(
                        //color: Color(0xFFFFFFFF),
                        //shape: BoxShape.circle,
                        ),
                    child:
                        Icon(Icons.arrow_back, color: AppColors.appBlueColor)),
              ),
            ),
            SizedBox(height: DeviceDimensions.screenHeight(context) * 0.020),
            Flexible(
              child: SingleChildScrollView(
                child: Consumer2<UserInfoFormStateProvider, SocialAppProvider>(
                  builder: (context, userProvider, socialAppProvider, child) {
                    return Column(
                      children: [
                        Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12.0,
                              ),
                              child: Image.asset(
                                "assets/images/cardimage_graphscreen.png",
                                height: 250,
                              ),
                            ),
                            Positioned(
                              right: 30,
                              top: 58,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, '/share-profile');
                                },
                                child: SvgPicture.asset(
                                    "assets/icons/share.svg",
                                    height: DeviceDimensions.responsiveSize(
                                            context) *
                                        0.10),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 60,
                                child: CircleAvatar(
                                  radius: 56,
                                  backgroundColor: AppColors.appBlueColor,
                                  child: CachedNetworkImage(
                                    imageUrl: userProvider.imageUrl,
                                    imageBuilder: (context, imageProvider) =>
                                        CircleAvatar(
                                      radius: 60,
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
                              ),
                            ),
                          ],
                        ),
                        Text(
                          "${userProvider.firstName} ${userProvider.lastName}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: DeviceDimensions.responsiveSize(context) *
                                0.065,
                            fontFamily: 'Barlow-Bold',
                            fontWeight: FontWeight.w600,
                            color: AppColors.textColorBlue,
                          ),
                        ),
                        SizedBox(
                          child: Text(
                            "${userProvider.designation} at ${userProvider.companyName}",
                            style: TextStyle(
                              fontSize:
                                  DeviceDimensions.responsiveSize(context) *
                                      0.040,
                              fontFamily: 'Barlow-Regular',
                              color: const Color(0xFF909091),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(
                            width:
                                DeviceDimensions.screenWidth(context) * 0.015),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              "assets/icons/dot.svg",
                              width: 5,
                            ),
                            SizedBox(
                                width: DeviceDimensions.screenWidth(context) *
                                    0.015),
                            Text(
                              "${userProvider.profileType}",
                              style: TextStyle(
                                  fontSize:
                                      DeviceDimensions.responsiveSize(context) *
                                          0.045,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textColorBlue,
                                  fontFamily: 'Barlow-Regular'),
                            ),
                          ],
                        ),
                        SizedBox(
                            height:
                                DeviceDimensions.screenHeight(context) * 0.025),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 27.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  UrlLauncherHelper.launchPhone(
                                      context, userProvider.contact);
                                },
                                child: Container(
                                  width: DeviceDimensions.screenWidth(context) *
                                      0.35,
                                  height:
                                      DeviceDimensions.screenHeight(context) *
                                          0.052,
                                  decoration: BoxDecoration(
                                      color: AppColors.buttonColor,
                                      borderRadius: BorderRadius.circular(50)
                                      //shape: BoxShape.rectangle,
                                      ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(11.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        SvgPicture.asset(
                                          "assets/icons/phone.svg",
                                          fit: BoxFit.contain,
                                        ),
                                        Text('Contact',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: DeviceDimensions
                                                        .responsiveSize(
                                                            context) *
                                                    0.035)),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                  width: DeviceDimensions.screenWidth(context) *
                                      0.050),
                              GestureDetector(
                                onTap: () {
                                  UrlLauncherHelper.launchEmail(
                                    context,
                                    userProvider.email,
                                    subject: 'Business Query',
                                    body:
                                        'Hello ${userProvider.firstName}, How are you?',
                                  );
                                },
                                child: Container(
                                  width: DeviceDimensions.screenWidth(context) *
                                      0.35,
                                  height:
                                      DeviceDimensions.screenHeight(context) *
                                          0.052,
                                  decoration: BoxDecoration(
                                      color: AppColors.buttonColor,
                                      borderRadius: BorderRadius.circular(50)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(11.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        SvgPicture.asset(
                                          "assets/icons/mail.svg",
                                          fit: BoxFit.contain,
                                        ),
                                        Text(
                                          'Email',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: DeviceDimensions
                                                      .responsiveSize(context) *
                                                  0.035),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                            height:
                                DeviceDimensions.screenHeight(context) * 0.025),
                        Padding(
                          padding: const EdgeInsets.only(left: 25.0),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Bio",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize:
                                      DeviceDimensions.responsiveSize(context) *
                                          0.058,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textColorBlue,
                                  fontFamily: 'Barlow-Bold'),
                            ),
                          ),
                        ),
                        SizedBox(
                            height:
                                DeviceDimensions.screenHeight(context) * 0.010),
                        Padding(
                          padding: const EdgeInsets.only(left: 25.0, right: 25),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              userProvider.bio,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: AppColors.appBlueColor,
                                fontSize:
                                    DeviceDimensions.responsiveSize(context) *
                                        0.036,
                                fontFamily: 'Barlow-Regular',
                              ),
                              //textAlign: TextAlign.justify,
                            ),
                          ),
                        ),
                        SizedBox(
                            height:
                                DeviceDimensions.screenHeight(context) * 0.030),
                        Container(
                          width: DeviceDimensions.screenWidth(context) * 0.89,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Column(
                            children: [
                              SizedBox(
                                  height:
                                      DeviceDimensions.screenHeight(context) *
                                          0.030),
                              const Text(
                                "All Links",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textColorBlue,
                                ),
                              ),
                              SizedBox(
                                  height:
                                      DeviceDimensions.screenHeight(context) *
                                          0.020),
                              if (socialAppProvider.filteredSocialApps.isEmpty)
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 20),
                                  child: Center(
                                    child: Text(
                                      'No Social apps is added',
                                      style: TextStyle(
                                          fontFamily: 'Barlow-Regular'),
                                    ),
                                  ),
                                )
                              else
                                GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: socialAppProvider
                                      .filteredSocialApps.length,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 1,
                                    childAspectRatio: 2.2,
                                  ),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final platform = socialAppProvider
                                        .filteredSocialApps[socialAppProvider
                                            .filteredSocialApps.length -
                                        1 -
                                        index];

                                    return Row(
                                      children: [
                                        SizedBox(
                                            width: DeviceDimensions.screenWidth(
                                                    context) *
                                                0.050),
                                        GestureDetector(
                                          onTap: () {
                                            UrlLauncherHelper.launchSocialApps(
                                                context,
                                                platform.profileLink +
                                                    platform.userName);
                                          },
                                          child: Container(
                                            width: 50,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(35),
                                              color: Colors.black54,
                                              image: DecorationImage(
                                                image:
                                                    CachedNetworkImageProvider(
                                                        platform.icon),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                            width: DeviceDimensions.screenWidth(
                                                    context) *
                                                0.015),
                                        GestureDetector(
                                          onTap: () {
                                            UrlLauncherHelper.launchSocialApps(
                                                context,
                                                platform.profileLink +
                                                    platform.userName);
                                          },
                                          child: Text(
                                            platform.name,
                                            style: TextStyle(
                                              fontSize: DeviceDimensions
                                                      .responsiveSize(context) *
                                                  0.037,
                                              fontFamily: 'Barlow-Regular',
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.textColorBlue,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              SizedBox(
                                  height:
                                      DeviceDimensions.screenHeight(context) *
                                          0.010),
                              GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, '/active-link');
                                  },
                                  child: SvgPicture.asset(
                                    "assets/icons/addlink.svg",
                                    height: 40,
                                  )),
                              SizedBox(
                                  height:
                                      DeviceDimensions.screenHeight(context) *
                                          0.025),
                            ],
                          ),
                        ),
                        SizedBox(
                            height:
                                DeviceDimensions.screenHeight(context) * 0.030),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
