import 'package:flutter/material.dart';
import 'package:nfc_app/constants/appColors.dart';
import 'package:nfc_app/responsive/device_dimensions.dart';

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

class AbsherAppBar extends StatelessWidget {
  final String title;
  //final Widget? leftButton;
  final VoidCallback? onLeftButtonTap;
  final Widget? rightButton;

  const AbsherAppBar(
      {super.key,
      required this.title,
      //this.leftButton,
      this.onLeftButtonTap,
      this.rightButton});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          onLeftButtonTap != null
              ? GestureDetector(
                  onTap: onLeftButtonTap,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 9),
                    child:
                        Icon(Icons.arrow_back, color: AppColors.appBlueColor),
                  ),
                )
              : SizedBox.shrink(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: TextStyle(
                fontFamily: 'Barlow-Regular',
                fontSize: DeviceDimensions.responsiveSize(context) * 0.055,
                fontWeight: FontWeight.w600,
                //color: Colors.white
                color: AppColors.appBlueColor,
              ),
            ),
          ),
          rightButton ?? SizedBox.shrink()
        ],
      ),
    );
  }
}

class AbsherAppBar2 extends StatelessWidget {
  final String title;
  //final Widget? leftButton;
  final VoidCallback? onLeftButtonTap;
  final Widget? rightButton;

  const AbsherAppBar2(
      {super.key,
      required this.title,
      //this.leftButton,
      this.onLeftButtonTap,
      this.rightButton});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 9),
              child: Text("")),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: TextStyle(
                fontFamily: 'Barlow-Regular',
                fontSize: DeviceDimensions.responsiveSize(context) * 0.055,
                fontWeight: FontWeight.w600,
                //color: Colors.white
                color: AppColors.appBlueColor,
              ),
            ),
          ),
          rightButton ?? SizedBox.shrink()
        ],
      ),
    );
  }
}

class AbsherAppBar3 extends StatelessWidget {
  final String title;
  //final Widget? leftButton;
  final VoidCallback? onLeftButtonTap;
  final Widget? rightButton;

  const AbsherAppBar3(
      {super.key,
      required this.title,
      //this.leftButton,
      this.onLeftButtonTap,
      this.rightButton});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          onLeftButtonTap != null
              ? GestureDetector(
                  onTap: onLeftButtonTap,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 9),
                    child:
                        Icon(Icons.arrow_back, color: AppColors.appBlueColor),
                  ),
                )
              : SizedBox.shrink(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: TextStyle(
                fontFamily: 'Barlow-Regular',
                fontSize: DeviceDimensions.responsiveSize(context) * 0.055,
                fontWeight: FontWeight.w600,
                //color: Colors.white
                color: AppColors.appBlueColor,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5.0),
            child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 9),
                child: Text("")),
          ),
        ],
      ),
    );
  }
}
