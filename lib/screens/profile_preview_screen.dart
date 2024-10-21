import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nfc_app/constants/appColors.dart';
import 'package:nfc_app/provider/social_app_provider.dart';
import 'package:nfc_app/responsive/device_dimensions.dart';
import 'package:nfc_app/utils/ui_mode_helper.dart';
import 'package:nfc_app/widgets/custom_loader_widget.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

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
        body: SingleChildScrollView(
          child: Consumer2<UserInfoFormStateProvider, SocialAppProvider>(
            builder: (context, userProvider, socialAppProvider, child) {
              return Column(
                children: [
                  Stack(
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 10.0, left: 5, right: 5),
                        child: SizedBox(
                          height: DeviceDimensions.screenHeight(context) * 0.40,
                          width: DeviceDimensions.screenWidth(context),
                          child: Image.asset(
                            "assets/images/profilecard.png",
                          ),
                        ),
                      ),
                      Positioned(
                        right: 30,
                        top: 60,
                        child: SvgPicture.asset("assets/icons/share.svg",
                            height: DeviceDimensions.responsiveSize(context) *
                                0.08),
                      ),
                      Positioned(
                        bottom: 15,
                        left: 0,
                        right: 0,
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 70,
                          child: CircleAvatar(
                            radius: 68,
                            backgroundColor: Colors.black54,
                            child: CachedNetworkImage(
                              imageUrl: userProvider.imageUrl!,
                              imageBuilder: (context, imageProvider) =>
                                  CircleAvatar(
                                radius: 68,
                                backgroundImage: imageProvider,
                              ),
                              placeholder: (context, url) => Center(
                                child: SmallThreeBounceLoader(),
                              ),
                              errorWidget: (context, url, error) => Image.asset(
                                  'assets/images/default_profile.jpg'),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "${userProvider.firstName} ${userProvider.lastName}",
                    style: TextStyle(
                      fontSize:
                          DeviceDimensions.responsiveSize(context) * 0.065,
                      fontFamily: 'Barlow-Bold',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(
                    child: Text(
                      "${userProvider.designation} at ${userProvider.companyName}",
                      style: TextStyle(
                        fontSize:
                            DeviceDimensions.responsiveSize(context) * 0.040,
                        fontFamily: 'Barlow-Regular',
                        color: const Color(0xFF909091),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(
                      width: DeviceDimensions.screenWidth(context) * 0.015),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        "assets/icons/dot.svg",
                        width: 5,
                      ),
                      SizedBox(
                          width: DeviceDimensions.screenWidth(context) * 0.015),
                      Text(
                        "${userProvider.selectedItem}",
                        style: TextStyle(
                            fontSize: DeviceDimensions.responsiveSize(context) *
                                0.045,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Barlow-Regular'),
                      ),
                    ],
                  ),
                  SizedBox(
                      height: DeviceDimensions.screenHeight(context) * 0.025),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 27.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            final phoneNumer = userProvider.contact;
                            final Uri url =
                                Uri(scheme: 'tel', path: phoneNumer);
                            if (await canLaunchUrl(url)) {
                              await launchUrl(url);
                            } else {
                              throw 'Could not launch $url';
                            }
                          },
                          child: Container(
                            width: DeviceDimensions.screenWidth(context) * 0.35,
                            height:
                                DeviceDimensions.screenHeight(context) * 0.052,
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
                                          fontSize:
                                              DeviceDimensions.responsiveSize(
                                                      context) *
                                                  0.035)),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                            width:
                                DeviceDimensions.screenWidth(context) * 0.050),
                        GestureDetector(
                          onTap: () async {
                            final email = userProvider.email;
                            final Uri emailUri = Uri(
                              scheme: 'mailto',
                              path: email,
                              query:
                                  'subject=Business Query&body=Hello ${userProvider.firstName}, How are you?',
                            );

                            if (await canLaunchUrl(emailUri)) {
                              await launchUrl(emailUri);
                            } else {
                              throw 'Could not launch $emailUri';
                            }
                          },
                          child: Container(
                            width: DeviceDimensions.screenWidth(context) * 0.35,
                            height:
                                DeviceDimensions.screenHeight(context) * 0.052,
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
                                  Text('Email',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize:
                                              DeviceDimensions.responsiveSize(
                                                      context) *
                                                  0.035)),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                      height: DeviceDimensions.screenHeight(context) * 0.025),
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Bio",
                        style: TextStyle(
                            fontSize: DeviceDimensions.responsiveSize(context) *
                                0.058,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Barlow-Bold'),
                      ),
                    ),
                  ),
                  SizedBox(
                      height: DeviceDimensions.screenHeight(context) * 0.010),
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0, right: 25),
                    child: Text(
                      userProvider.bio.isNotEmpty
                          ? userProvider.bio
                          : "What Software Quality Assurance Engineers and Testers Do. Design test plans, scenarios, scripts, or procedures. Document software defects, using a bug tracking system, and report defects to software developers. Identify, analyze, and document problems with program function, output, online screen, or content.",
                      style: TextStyle(
                        color: const Color(0xFF909091),
                        fontSize:
                            DeviceDimensions.responsiveSize(context) * 0.036,
                        fontFamily: 'Barlow-Regular',
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                  SizedBox(
                      height: DeviceDimensions.screenHeight(context) * 0.030),
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
                                DeviceDimensions.screenHeight(context) * 0.030),
                        const Text(
                          "All Links",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                            height:
                                DeviceDimensions.screenHeight(context) * 0.020),
                        if (socialAppProvider.filteredSocialApps.isEmpty)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Center(
                              child: Text(
                                'No Social apps is added',
                                style: TextStyle(fontFamily: 'Barlow-Regular'),
                              ),
                            ),
                          )
                        else
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount:
                                socialAppProvider.filteredSocialApps.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 20,
                              childAspectRatio: 2.1,
                            ),
                            itemBuilder: (BuildContext context, int index) {
                              final platform = socialAppProvider
                                      .filteredSocialApps[
                                  socialAppProvider.filteredSocialApps.length -
                                      1 -
                                      index];

                              return Row(
                                children: [
                                  SizedBox(
                                      width: DeviceDimensions.screenWidth(
                                              context) *
                                          0.050),
                                  GestureDetector(
                                    onTap: () async {
                                      {
                                        final Uri socialAppUrl = Uri.parse(
                                            platform.profileLink +
                                                platform.userName);
                                        if (await canLaunchUrl(socialAppUrl)) {
                                          await launchUrl(socialAppUrl);
                                        } else {
                                          throw 'Could not launch $socialAppUrl';
                                        }
                                      }
                                    },
                                    child: Container(
                                      width: 54,
                                      height: 54,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(35),
                                        color: Colors.black54,
                                        image: DecorationImage(
                                          image: CachedNetworkImageProvider(
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
                                    onTap: () async {
                                      {
                                        final Uri socialAppUrl = Uri.parse(
                                            platform.profileLink +
                                                platform.userName);
                                        if (await canLaunchUrl(socialAppUrl)) {
                                          await launchUrl(socialAppUrl);
                                        } else {
                                          throw 'Could not launch $socialAppUrl';
                                        }
                                      }
                                    },
                                    child: Text(
                                      platform.name,
                                      style: TextStyle(
                                        fontSize:
                                            DeviceDimensions.responsiveSize(
                                                    context) *
                                                0.037,
                                        fontFamily: 'Barlow-Regular',
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        SizedBox(
                            height:
                                DeviceDimensions.screenHeight(context) * 0.010),
                        GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/active-link');
                            },
                            child:
                                SvgPicture.asset("assets/icons/addlink.svg")),
                        SizedBox(
                            height:
                                DeviceDimensions.screenHeight(context) * 0.025),
                      ],
                    ),
                  ),
                  SizedBox(
                      height: DeviceDimensions.screenHeight(context) * 0.040),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
