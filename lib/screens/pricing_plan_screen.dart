// import 'package:flutter/material.dart';
// import 'package:nfc_app/constants/appColors.dart';
// import 'package:nfc_app/provider/user_info_form_state_provider.dart';
// import 'package:nfc_app/shared/common_widgets/custom_app_bar_widget.dart';
// import 'package:nfc_app/widgets/individual_pricing_plan_widget.dart';
// import 'package:nfc_app/widgets/teams_pricing_plan_widget.dart';
// import 'package:provider/provider.dart';
// import '../responsive/device_dimensions.dart';

// class PricingPlan extends StatefulWidget {
//   const PricingPlan({super.key});

//   @override
//   State<PricingPlan> createState() => _PricingPlanState();
// }

// class _PricingPlanState extends State<PricingPlan>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   final Duration _animationDuration = const Duration(milliseconds: 500);

//   @override
//   void initState() {
//     super.initState();
//     final userInfoProvider = Provider.of<UserInfoFormStateProvider>(context, listen: false);
//     //Check profile type and set the correct tab index
//     bool isIndividual = userInfoProvider.profileType == 'Individual';

//     _tabController = TabController(length: 2, vsync: this);
//     _tabController.index = isIndividual ? 0 : 1;
//     _tabController.addListener(() {
//       setState(() {});
//     });
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final userInfoProvider = Provider.of<UserInfoFormStateProvider>(context);
//     String profileType = userInfoProvider.profileType;
//     bool isIndividual = profileType == "Individual";
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: AppColors.screenBackground,
//         body: Column(
//           children: [
//             SizedBox(
//               height: DeviceDimensions.screenHeight(context) * 0.0001,
//             ),
//             AbsherAppBar(
//               title: 'Pricing Plan',
//               onLeftButtonTap: () {
//                 Navigator.pop(context);
//               },
//               rightButton: Align(
//                 alignment: Alignment.centerRight,
//                 child: SizedBox(
//                     width: DeviceDimensions.screenWidth(context) * 0.035),
//               ),
//             ),
//             SizedBox(height: DeviceDimensions.screenHeight(context) * 0.020),
//             Flexible(
//               child: Column(
//                 children: [
//                   // SizedBox(height: DeviceDimensions.screenHeight(context) * 0.032),
//                   Container(
//                     height: DeviceDimensions.screenHeight(context) * 0.065,
//                     width: DeviceDimensions.screenWidth(context) * 0.895,
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(25),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(4.0),
//                       child: TabBar(
//                         controller: _tabController,
//                         indicatorSize: TabBarIndicatorSize.tab,
//                         indicator: BoxDecoration(
//                           color: AppColors.appBlueColor,
//                           borderRadius: BorderRadius.circular(25),
//                         ),
//                         labelColor: Colors.white,
//                         labelStyle: TextStyle(
//                             fontSize: DeviceDimensions.responsiveSize(context) *
//                                 0.045,
//                             fontWeight: FontWeight.w600,
//                             letterSpacing: 1),
//                         unselectedLabelColor: AppColors.appBlueColor,
//                         unselectedLabelStyle: TextStyle(
//                           fontSize:
//                               DeviceDimensions.responsiveSize(context) * 0.045,
//                           fontWeight: FontWeight.normal,
//                         ),
//                         tabs: const [
//                           Tab(
//                             child: Text(
//                               "Individual",
//                               style: TextStyle(
//                                 fontFamily: 'Barlow-Regular',
//                               ),
//                             ),
//                           ),
//                           Tab(
//                             child: Text(
//                               "Teams",
//                               style: TextStyle(
//                                 fontFamily: 'Barlow-Regular',
//                               ),
//                             ),
//                           ),
//                         ],
//                         dividerColor: Colors.transparent,
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                     child: AnimatedSwitcher(
//                         duration: _animationDuration,
//                         transitionBuilder:
//                             (Widget child, Animation<double> animation) {
//                           final slideAnimation = Tween<Offset>(
//                             begin: const Offset(0, 1.0),
//                             end: Offset.zero,
//                           ).animate(animation);

//                           return SlideTransition(
//                             position: slideAnimation,
//                             child: FadeTransition(
//                               opacity: animation,
//                               child: child,
//                             ),
//                           );
//                         },
//                         child: _tabController.index == 0
//                             ? const IndividualPricingPlanWidget(
//                                 key: ValueKey<int>(0))
//                             : const TeamsPricingPlanWidget(
//                                 key: ValueKey<int>(1))),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:nfc_app/constants/appColors.dart';
import 'package:nfc_app/provider/user_info_form_state_provider.dart';
import 'package:nfc_app/shared/common_widgets/custom_app_bar_widget.dart';
import 'package:nfc_app/widgets/individual_pricing_plan_widget.dart';
import 'package:nfc_app/widgets/teams_pricing_plan_widget.dart';
import 'package:provider/provider.dart';
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
    final userInfoProvider =
        Provider.of<UserInfoFormStateProvider>(context, listen: false);
    //Check profile type and set the correct tab index
    bool isIndividual = userInfoProvider.profileType == 'Individual';

    _tabController = TabController(length: 2, vsync: this);
    _tabController.index = isIndividual ? 0 : 1;
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
    final userInfoProvider = Provider.of<UserInfoFormStateProvider>(context);
    String profileType = userInfoProvider.profileType;
    bool isIndividual = profileType == "Individual";
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.screenBackground,
        body: Column(
          children: [
            SizedBox(
              height: DeviceDimensions.screenHeight(context) * 0.0001,
            ),
            AbsherAppBar(
              title: 'Pricing Plan',
              onLeftButtonTap: () {
                Navigator.pop(context);
              },
              rightButton: Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                    width: DeviceDimensions.screenWidth(context) * 0.035),
              ),
            ),
            SizedBox(height: DeviceDimensions.screenHeight(context) * 0.020),
            // Show TabBar only if both plans are accessible
            if (profileType == "Both")
              Container(
                height: DeviceDimensions.screenHeight(context) * 0.065,
                width: DeviceDimensions.screenWidth(context) * 0.895,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: TabBar(
                    controller: _tabController,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicator: BoxDecoration(
                      color: AppColors.appBlueColor,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    labelColor: Colors.white,
                    labelStyle: TextStyle(
                        fontSize:
                            DeviceDimensions.responsiveSize(context) * 0.045,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1),
                    unselectedLabelColor: AppColors.appBlueColor,
                    unselectedLabelStyle: TextStyle(
                      fontSize:
                          DeviceDimensions.responsiveSize(context) * 0.045,
                      fontWeight: FontWeight.normal,
                    ),
                    tabs: const [
                      Tab(
                        child: Text(
                          "Individual",
                          style: TextStyle(
                            fontFamily: 'Barlow-Regular',
                          ),
                        ),
                      ),
                      Tab(
                        child: Text(
                          "Teams",
                          style: TextStyle(
                            fontFamily: 'Barlow-Regular',
                          ),
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
                child: isIndividual
                    ? const IndividualPricingPlanWidget(key: ValueKey<int>(0))
                    : const TeamsPricingPlanWidget(key: ValueKey<int>(1)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
