import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nfc_app/constants/appColors.dart';
import 'package:nfc_app/provider/social_app_provider.dart';
import 'package:nfc_app/widgets/showLinkDialog_widget.dart';
import 'package:nfc_app/widgets/active_apps_widget.dart';
import 'package:nfc_app/shared/common_widgets/custom_app_bar_widget.dart';
import 'package:nfc_app/responsive/device_dimensions.dart';
import 'package:provider/provider.dart';

class ActiveLink extends StatelessWidget {
  const ActiveLink({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFEFEFEF),
        body: Column(
          children: [
            SizedBox(
              height: DeviceDimensions.screenHeight(context) * 0.0001,
            ),
            AbsherAppBar(
              title: 'Active Social Links',
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
              rightButton: Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                    width: DeviceDimensions.screenWidth(context) * 0.035),
              ),
            ),
            SizedBox(height: DeviceDimensions.screenHeight(context) * 0.020),
            Flexible(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 13.0, vertical: 10),
                  child: Consumer<SocialAppProvider>(
                    builder: (context, socialAppProvider, child) {
                      final addedSocialApps = socialAppProvider.addedSocialApps;

                      return Center(
                        child: Column(
                          children: [
                            ActiveAppsContainer(
                                appItemsWithLinks: addedSocialApps),
                            SizedBox(
                              height: DeviceDimensions.screenHeight(context) *
                                  0.030,
                            ),
                            Container(
                              width:
                                  DeviceDimensions.screenWidth(context) * 0.90,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 15.0,
                                      left: 18,
                                      bottom: 3,
                                    ),
                                    child: Text(
                                      'Recommended for you',
                                      style: TextStyle(
                                        fontFamily: 'Barlow-Bold',
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textColorBlue,
                                        fontSize:
                                            DeviceDimensions.responsiveSize(
                                                    context) *
                                                0.042,
                                      ),
                                    ),
                                  ),
                                  const Divider(
                                    color: Color(0xFFD7D9DD),
                                  ),
                                  if (socialAppProvider.socialApps.isEmpty)
                                    const Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 20),
                                      child: Center(
                                          child: Text('All Apps are added',
                                              style: TextStyle(
                                                  fontFamily: 'Barlow-Regular',
                                                  color:
                                                      AppColors.appBlueColor))),
                                    )
                                  else
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount:
                                          socialAppProvider.socialApps.length,
                                      itemBuilder: (context, index) {
                                        final appItem =
                                            socialAppProvider.socialApps[index];

                                        return Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20.0, right: 10),
                                          child: ListTile(
                                            contentPadding: EdgeInsets.zero,
                                            leading: Container(
                                              width: 35,
                                              height: 35,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(35),
                                                color: Colors.black54,
                                                image: DecorationImage(
                                                  image:
                                                      CachedNetworkImageProvider(
                                                    appItem.icon,
                                                  ),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            title: Text(appItem.name,
                                                style: TextStyle(
                                                  fontFamily: 'Barlow-Regular',
                                                  color:
                                                      AppColors.textColorBlue,
                                                  fontWeight: FontWeight.w600,
                                                )),
                                            trailing: IconButton(
                                              icon: SvgPicture.asset(
                                                  "assets/icons/addconnections.svg"),
                                              onPressed: () {
                                                showLinkBottomSheet(
                                                    context, appItem);
                                              },
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                ],
                              ),
                            ),
                            SizedBox(
                                height: DeviceDimensions.screenHeight(context) *
                                    0.030),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
