import 'package:flutter/material.dart';
import 'package:nfc_app/constants/appColors.dart';
import 'package:nfc_app/widgets/custom_app_bar_widget.dart';
import 'package:nfc_app/widgets/individual_widget.dart';
import 'package:nfc_app/widgets/teams_widget.dart';

import '../responsive/device_dimensions.dart';

class PricingPlan extends StatefulWidget {
  const PricingPlan({super.key});

  @override
  State<PricingPlan> createState() => _PricingPlanState();
}

class _PricingPlanState extends State<PricingPlan>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final Duration _animationDuration = const Duration(milliseconds: 500);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.screenBackground,
        appBar: const CustomAppBar(title: "Pricing Plan"),
        body: Column(
          children: [
            // SizedBox(height: DeviceDimensions.screenHeight(context) * 0.032),
            Container(
              height: DeviceDimensions.screenHeight(context) * 0.065,
              width: DeviceDimensions.screenWidth(context) * 0.895,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 239, 239, 239),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: TabBar(
                  controller: _tabController,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  labelColor: const Color(0xFF202020),
                  labelStyle: TextStyle(
                      fontSize:
                          DeviceDimensions.responsiveSize(context) * 0.045,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1),
                  unselectedLabelColor: const Color(0xFF727272),
                  unselectedLabelStyle: TextStyle(
                    fontSize: DeviceDimensions.responsiveSize(context) * 0.045,
                    fontWeight: FontWeight.normal,
                  ),
                  tabs: const [
                    Tab(
                      child: Text(
                        "Individual",
                        style: TextStyle(fontFamily: 'Barlow-Regular'),
                      ),
                    ),
                    Tab(
                      child: Text(
                        "Teams",
                        style: TextStyle(fontFamily: 'Barlow-Regular'),
                      ),
                    ),
                  ],
                  dividerColor: Colors.transparent,
                ),
              ),
            ),
            Expanded(
              child: AnimatedSwitcher(
                duration: _animationDuration,
                transitionBuilder: (Widget child, Animation<double> animation) {
                  final slideAnimation = Tween<Offset>(
                    begin: const Offset(0, 1.0),
                    end: Offset.zero,
                  ).animate(animation);

                  return SlideTransition(
                    position: slideAnimation,
                    child: FadeTransition(
                      opacity: animation,
                      child: child,
                    ),
                  );
                },
                child: _tabController.index == 0
                    ? const Individual(key: ValueKey<int>(0))
                    : const Teams(key: ValueKey<int>(1)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
