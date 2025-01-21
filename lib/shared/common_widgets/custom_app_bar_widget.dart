import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nfc_app/constants/appColors.dart';
import 'package:nfc_app/responsive/device_dimensions.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions; // Additional widgets for actions
  final Function? onBackPressed; // Custom back button behavior
  final String? icon; // Path to the optional SVG icon
  final Function? onIconPressed; // Callback for SVG icon tap

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.onBackPressed,
    this.icon,
    this.onIconPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Text(
          title,
          style: TextStyle(
            fontFamily: 'Barlow-Regular',
            fontSize: DeviceDimensions.responsiveSize(context) * 0.055,
            fontWeight: FontWeight.w600,
            color: AppColors.appBlueColor,
          ),
        ),
      ),
      centerTitle: true,
      elevation: 0,
      backgroundColor: AppColors.screenBackground.withOpacity(1),
      //foregroundColor: AppColors.screenBackground,
      leading: IconButton(
        onPressed: () {
          if (onBackPressed != null) {
            onBackPressed!(); // Custom back button behavior
          } else {
            Navigator.of(context).pop(); // Default pop behavior
          }
        },
        icon: const Icon(Icons.arrow_back, color: AppColors.appBlueColor),
      ),
      actions: [
        if (icon != null) // Show the SVG icon if `iconPath` is provided
          Padding(
            padding: const EdgeInsets.only(right: 10.0, top: 5),
            child: IconButton(
              icon: SvgPicture.asset(
                icon!, // Load icon from provided path
                width: 33,
                height: 33,
              ),
              onPressed: () {
                // Handle SVG icon tap, if needed
                if (onIconPressed != null) {
                  onIconPressed!(); // Trigger the custom callback
                }
              },
            ),
          ),
        if (actions != null)
          ...actions! // Append additional actions if provided
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(65);
}

class CustomAppBarTwo extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget> actions;
  final Function? onBackPressed;
  final TabController tabController;

  const CustomAppBarTwo({
    super.key,
    required this.title,
    required this.tabController,
    this.actions = const [],
    this.onBackPressed,
  });

  @override
  State<CustomAppBarTwo> createState() => _CustomAppBarTwoState();

  @override
  Size get preferredSize => const Size.fromHeight(130);
}

class _CustomAppBarTwoState extends State<CustomAppBarTwo>
    with SingleTickerProviderStateMixin {
  //late TabController _tabController;

  // @override
  // void initState() {
  //   super.initState();
  //   _tabController = TabController(length: 3, vsync: this);
  // }

  // @override
  // void dispose() {
  //   _tabController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: AppBar(
        bottom: PreferredSize(
          preferredSize:
              Size.fromHeight(DeviceDimensions.responsiveSize(context) * 0.15),
          child: TabBar(
            controller: widget.tabController,
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorColor: AppColors.appBlueColor,
            labelColor: const Color(0xFF202020),
            labelStyle: TextStyle(
              fontSize: DeviceDimensions.responsiveSize(context) * 0.038,
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
            ),
            unselectedLabelColor: const Color(0xFF727272),
            unselectedLabelStyle: TextStyle(
              fontSize: DeviceDimensions.responsiveSize(context) * 0.038,
              fontWeight: FontWeight.normal,
            ),
            tabs: const [
              Tab(text: 'Active'),
              Tab(text: 'Completed'),
              Tab(text: 'Cancelled'),
            ],
          ),
        ),
        title: Text(widget.title,
            style: TextStyle(
              fontFamily: 'Barlow-Regular',
              fontSize: DeviceDimensions.responsiveSize(context) * 0.055,
              fontWeight: FontWeight.w600,
              color: AppColors.appBlueColor,
            )),
        centerTitle: true,
        actions: widget.actions,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            color: AppColors.screenBackground,
          ),
        ),
        elevation: 0,
        backgroundColor: AppColors.screenBackground,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
        leading: IconButton(
          onPressed: () {
            if (widget.onBackPressed != null) {
              widget.onBackPressed!();
            } else {
              Navigator.of(context).pop();
            }
          },
          icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(),
              child:
                  const Icon(Icons.arrow_back, color: AppColors.appBlueColor)),
        ),
      ),
    );
  }
}

class NavBar_AppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  // final List<Widget>? actions; // Additional widgets for actions
  // final Function? onBackPressed; // Custom back button behavior
  // final String? icon; // Path to the optional SVG icon
  // final Function? onIconPressed; // Callback for SVG icon tap

  const NavBar_AppBar({
    super.key,
    required this.title,
    // this.actions,
    // this.onBackPressed,
    // this.icon,
    // this.onIconPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Text(
          title,
          style: TextStyle(
            fontFamily: 'Barlow-Regular',
            fontSize: DeviceDimensions.responsiveSize(context) * 0.055,
            fontWeight: FontWeight.w600,
            color: AppColors.appBlueColor,
          ),
        ),
      ),
      centerTitle: true,
      elevation: 0,
      backgroundColor: AppColors.screenBackground.withOpacity(1),
      //foregroundColor: AppColors.screenBackground,
      // leading: IconButton(
      //   onPressed: () {
      //     if (onBackPressed != null) {
      //       onBackPressed!(); // Custom back button behavior
      //     } else {
      //       Navigator.of(context).pop(); // Default pop behavior
      //     }
      //   },
      //   icon: const Icon(Icons.arrow_back, color: AppColors.appBlueColor),
      // ),
      // actions: [
      //   if (icon != null) // Show the SVG icon if `iconPath` is provided
      //     Padding(
      //       padding: const EdgeInsets.only(right: 10.0, top: 5),
      //       child: IconButton(
      //         icon: SvgPicture.asset(
      //           icon!, // Load icon from provided path
      //           width: 33,
      //           height: 33,
      //         ),
      //         onPressed: () {
      //           // Handle SVG icon tap, if needed
      //           if (onIconPressed != null) {
      //             onIconPressed!(); // Trigger the custom callback
      //           }
      //         },
      //       ),
      //     ),
      //   if (actions != null)
      //     ...actions! // Append additional actions if provided
      // ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(65);
}

class AbsherAppBar extends StatelessWidget {
  final String title;
  final Widget? leftButton;
  final Widget? rightButton;
  const AbsherAppBar(
      {super.key, required this.title, this.leftButton, this.rightButton});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12, top: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          leftButton ?? SizedBox.shrink(),
          Text(
            title,
            style: TextStyle(
              fontFamily: 'Barlow-Regular',
              fontSize: DeviceDimensions.responsiveSize(context) * 0.055,
              fontWeight: FontWeight.w600,
              color: AppColors.appBlueColor,
            ),
          ),
          rightButton ?? SizedBox.shrink()
        ],
      ),
    );
  }
}
