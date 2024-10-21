import 'package:flutter/material.dart';
import 'package:nfc_app/constants/appColors.dart';
import 'package:nfc_app/responsive/device_dimensions.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget> actions;
  final Function? onBackPressed;
  //final Widget leading;

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions = const [],
    this.onBackPressed,
    //this.leading = const Icon(Icons.menu),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: AppBar(
        title: Text(title,
            style: TextStyle(
                fontFamily: 'Barlow-Regular',
                fontSize: DeviceDimensions.responsiveSize(context) * 0.055,
                fontWeight: FontWeight.w600)),
        centerTitle: true,
        //leading: leading,
        actions: actions,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            color: AppColors
                .screenBackground, // Apply background color or gradient
            // gradient: LinearGradient(
            //   colors: [Colors.black, Colors.grey],
            //   begin: Alignment.topLeft,
            //   end: Alignment.bottomRight,
            // ),
          ),
        ),
        elevation: 0,
        backgroundColor: AppColors.screenBackground,
        // flexibleSpace: Container(
        //     // decoration: const BoxDecoration(
        //     //   gradient: LinearGradient(
        //     //       colors: [Colors.blue, Colors.purple],
        //     //       begin: Alignment.topLeft,
        //     //       end: Alignment.topRight),
        //     // ),
        //     ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
        leading: IconButton(
          onPressed: () {
            if (onBackPressed != null) {
              onBackPressed!();
            } else {
              Navigator.of(context).pop(); // Default pop behavior
            }
          },
          icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                  //shape: BoxShape.circle,
                  //color: Colors.white,
                  ),
              child: const Icon(Icons.arrow_back, color: Colors.black)),
        ),
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(82);
}
