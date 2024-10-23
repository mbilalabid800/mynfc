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
              decoration: const BoxDecoration(),
              child: const Icon(Icons.arrow_back, color: Colors.black)),
        ),
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(82);
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
            indicatorColor: Colors.black,
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
                fontWeight: FontWeight.w600)),
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
              child: const Icon(Icons.arrow_back, color: Colors.black)),
        ),
      ),
    );
  }
}
