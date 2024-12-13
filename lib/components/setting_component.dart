// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nfc_app/constants/appColors.dart';
import 'package:nfc_app/responsive/device_dimensions.dart';

class SettingListComponent extends StatelessWidget {
  final String icons;
  final String title;
  final String icons2;
  final bool showDivider;
  final VoidCallback callBack;
  final Widget? trailing;

  const SettingListComponent({
    super.key,
    required this.icons,
    required this.title,
    this.icons2 = "assets/icons/more4.svg",
    this.showDivider = false,
    required this.callBack,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6),
          child: InkWell(
            onTap: callBack,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: SvgPicture.asset(
                    icons,
                    height: 20,
                  ),
                ),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: DeviceDimensions.responsiveSize(context) * 0.040,
                    fontFamily: 'Barlow-Regular',
                    fontWeight: FontWeight.w600,
                    color: AppColors.textColorBlue,
                  ),
                ),
                const Spacer(),
                if (trailing != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: trailing, // Show trailing widget if provided
                  )
                else
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: SvgPicture.asset(
                      icons2,
                      height: 15,
                      color: const Color(0xFF95989A),
                    ),
                  ),
              ],
            ),
          ),
        ),
        if (showDivider) const Divider(color: Color(0xFFE0E0E0)),
      ],
    );
  }
}
