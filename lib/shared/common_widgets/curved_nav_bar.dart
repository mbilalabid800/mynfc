// ignore_for_file: library_private_types_in_public_api, deprecated_member_use

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nfc_app/constants/appColors.dart';
import 'package:nfc_app/shared/utils/ui_mode_helper.dart';

class CustomCurvedNavigationBar extends StatefulWidget {
  final int initialIndex;
  final Function(int) onTap;

  const CustomCurvedNavigationBar({
    super.key,
    this.initialIndex = 0,
    required this.onTap,
  });

  @override
  _CustomCurvedNavigationBarState createState() =>
      _CustomCurvedNavigationBarState();
}

class _CustomCurvedNavigationBarState extends State<CustomCurvedNavigationBar> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    enableImmersiveStickyMode();
    _selectedIndex = widget.initialIndex; // Set initial index
  }

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      index: _selectedIndex,
      // height: 50.0,
      height: 55.0,

      items: <Widget>[
        _buildNavBarItem("assets/icons/home.svg", 0),
        _buildNavBarItem("assets/icons/graph.svg", 1),
        _buildNavBarItem("assets/icons/plus.svg", 2),
        _buildNavBarItem("assets/icons/chat.svg", 3),
        _buildNavBarItem("assets/icons/setting.svg", 4),
      ],
      color: Colors.white,
      buttonBackgroundColor: AppColors.appBlueColor,
      backgroundColor: Colors.transparent,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 600),
      onTap: (index) {
        setState(() {
          _selectedIndex = index;
        });
        widget.onTap(index);
      },
      letIndexChange: (index) => true,
    );
  }

  Widget _buildNavBarItem(String asset, int index) {
    return SvgPicture.asset(
      asset,
      color: _selectedIndex == index ? Colors.white : AppColors.appBlueColor,
      height: _selectedIndex == index ? 40.0 : 35.0,
      width: _selectedIndex == index ? 40.0 : 35.0,
    );
  }
}
