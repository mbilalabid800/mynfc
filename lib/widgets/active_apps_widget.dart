import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nfc_app/constants/appColors.dart';
import 'package:nfc_app/models/social_app_model.dart';
import 'package:nfc_app/provider/social_app_provider.dart';
import 'package:nfc_app/responsive/device_dimensions.dart';
import 'package:nfc_app/widgets/showLinkDialog_widget.dart';
import 'package:provider/provider.dart';

class ActiveAppsContainer extends StatelessWidget {
  const ActiveAppsContainer({
    super.key,
    required this.appItemsWithLinks,
  });

  final List<SocialAppModel> appItemsWithLinks;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SocialAppProvider>(context);

    return Container(
      width: DeviceDimensions.screenWidth(context) * 0.90,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(30)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 14, top: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Active All',
                    style: TextStyle(
                      fontFamily: 'Barlow-Bold',
                      fontWeight: FontWeight.w600,
                      color: AppColors.textColorBlue,
                      fontSize:
                          DeviceDimensions.responsiveSize(context) * 0.042,
                    )),
                SizedBox(
                  height: 33,
                  width: 45,
                  child: FittedBox(
                    fit: BoxFit.fill,
                    child: Switch(
                      activeColor: Colors.white,
                      activeTrackColor: AppColors.appOrangeColor,
                      inactiveTrackColor: const Color(0xFFEFEFEF),
                      inactiveThumbColor: AppColors.appBlueColor,
                      value: provider.isViewAllActive,
                      onChanged: (value) {
                        provider.toggleViewAll(value);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(
            color: Color(0xFFD7D9DD),
          ),
          if (appItemsWithLinks.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: Text(
                  'No apps with Links',
                  style: TextStyle(fontFamily: 'Barlow-Regular'),
                ),
              ),
            )
          else
            ReorderableListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: appItemsWithLinks.length,
              onReorder: (oldIndex, newIndex) {
                final int reverseOldIndex =
                    appItemsWithLinks.length - 1 - oldIndex;
                if (newIndex > oldIndex) {
                  newIndex -= 1;
                }
                final int reverseNewIndex =
                    appItemsWithLinks.length - 1 - newIndex;
                Provider.of<SocialAppProvider>(context, listen: false)
                    .reorderSocialApps(reverseOldIndex, reverseNewIndex);
              },
              proxyDecorator:
                  (Widget child, int index, Animation<double> animation) {
                return AnimatedBuilder(
                  animation: animation,
                  builder: (BuildContext context, Widget? child) {
                    final double animValue =
                        Curves.easeInOut.transform(animation.value);
                    final double elevation = lerpDouble(1, 6, animValue)!;
                    final double scale = lerpDouble(1, 1.02, animValue)!;
                    return Transform.scale(
                      scale: scale,
                      child: Material(
                        elevation: elevation,
                        color: AppColors.appBar,
                        child: child,
                      ),
                    );
                  },
                  child: child,
                );
              },
              itemBuilder: (context, index) {
                final appItem =
                    appItemsWithLinks[appItemsWithLinks.length - 1 - index];
                // final appItem = appItemsWithLinks[index];
                return GestureDetector(
                  key: ValueKey(appItem.name),
                  onTap: () {
                    showLinkBottomSheet(context, appItem);
                  },
                  child: ListTile(
                    tileColor: Colors.grey.shade200.withOpacity(0.50),
                    contentPadding: EdgeInsets.zero,
                    leading: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(width: 8),
                        SvgPicture.asset("assets/icons/reorder.svg", width: 27),
                        const SizedBox(width: 10),
                        Container(
                          width: 35,
                          height: 35,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(35),
                            color: Colors.black54,
                            image: DecorationImage(
                              image: CachedNetworkImageProvider(appItem.icon),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                    title: Text(appItem.name,
                        style: TextStyle(
                          fontFamily: 'Barlow-Regular',
                          color: AppColors.textColorBlue,
                          fontWeight: FontWeight.w600,
                        )),
                    trailing: Padding(
                      padding: const EdgeInsets.only(right: 15.0),
                      child: SizedBox(
                        height: 33,
                        width: 45,
                        child: FittedBox(
                          fit: BoxFit.fill,
                          child: Switch(
                            activeColor: Colors.white,
                            activeTrackColor: AppColors.appOrangeColor,
                            inactiveTrackColor: const Color(0xFFEFEFEF),
                            inactiveThumbColor: AppColors.appBlueColor,
                            value: appItem.isVisible,
                            onChanged: (value) {
                              Provider.of<SocialAppProvider>(context,
                                      listen: false)
                                  .toggleAppVisibility(appItem);
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          SizedBox(height: DeviceDimensions.screenHeight(context) * 0.008),
        ],
      ),
    );
  }
}
