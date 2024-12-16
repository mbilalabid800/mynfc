import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nfc_app/constants/appColors.dart';
import 'package:nfc_app/models/social_app_model.dart';
import 'package:nfc_app/provider/social_app_provider.dart';
import 'package:nfc_app/responsive/device_dimensions.dart';
import 'package:provider/provider.dart';

class HorizontalScrollAppIcons extends StatelessWidget {
  const HorizontalScrollAppIcons({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SocialAppProvider>(
      builder: (context, socialAppProvider, child) {
        if (socialAppProvider.filteredSocialApps.isEmpty) {
          return Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                ),
                height: DeviceDimensions.screenHeight(context) * 0.15,
                child: const Padding(
                  padding: EdgeInsets.all(18.0),
                  child: Center(
                      child: Text(
                    'No social apps added yet',
                    softWrap: true,
                  )),
                ),
              ),
            ],
          );
        }

        return Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
              ),
              width: DeviceDimensions.screenWidth(context) * 0.48,
              padding: const EdgeInsets.all(10),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(
                          maxHeight:
                              DeviceDimensions.screenHeight(context) * 0.05),
                      child: Stack(
                        children: socialAppProvider.filteredSocialApps
                            .asMap()
                            .entries
                            .where((entry) {
                          int index = entry.key;
                          int totalCount =
                              socialAppProvider.filteredSocialApps.length;

                          // Skip the first icons based on total count
                          return (totalCount <= 7) ||
                              (totalCount > 7 && index >= totalCount - 7);
                        }).map((entry) {
                          int index = entry.key;
                          SocialAppModel appItem = entry.value;
                          double leftOffset =
                              (socialAppProvider.filteredSocialApps.length -
                                      index -
                                      1) *
                                  18.0;

                          return Positioned(
                            left: leftOffset,
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 17,
                              child: Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(35),
                                  color: Colors.black54,
                                  image: DecorationImage(
                                    image: CachedNetworkImageProvider(
                                        appItem.icon),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    Text(
                      '${socialAppProvider.filteredSocialApps.length}',
                      style: TextStyle(
                        fontSize:
                            DeviceDimensions.responsiveSize(context) * 0.08,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textColorBlue,
                      ),
                    ),
                    Text(
                      'Active Social Links',
                      style: TextStyle(
                        fontFamily: 'Barlow',
                        color: Colors.grey,
                        fontSize:
                            DeviceDimensions.responsiveSize(context) * 0.04,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
