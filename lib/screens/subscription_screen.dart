// screens/subscription_plan_screen.dart

import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:nfc_app/constants/appColors.dart';
import 'package:nfc_app/models/pricing_plan_model.dart';
import 'package:nfc_app/services/pricing_plan_service.dart';
import 'package:nfc_app/shared/common_widgets/custom_app_bar_widget.dart';
import 'package:nfc_app/widgets/pricing_card_widget.dart';
import 'package:nfc_app/responsive/device_dimensions.dart';

class PricingPlansScreen extends StatelessWidget {
  final PricingPlanService pricingPlanService = PricingPlanService();
  PricingPlansScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Retrieve card arguments
    final Map<String, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final selectedCard = args?['selectedCard'];
    final selectedColorOption = args?['selectedColorOption'];
    final Future<List<PricingPlan>> plans =
        pricingPlanService.getPlans(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.screenBackground,
        //   body: Column(
        //     children: [
        //       SizedBox(
        //         height: DeviceDimensions.screenHeight(context) * 0.0001,
        //       ),
        //       AbsherAppBar(
        //         title: 'Select Your Plan',
        //         leftButton: GestureDetector(
        //           onTap: () {
        //             Navigator.pop(context);
        //           },
        //           child: Container(
        //               padding: const EdgeInsets.symmetric(
        //                   horizontal: 12.0, vertical: 9),
        //               decoration: const BoxDecoration(
        //                   //color: Color(0xFFFFFFFF),
        //                   //shape: BoxShape.circle,
        //                   ),
        //               child:
        //                   Icon(Icons.arrow_back, color: AppColors.appBlueColor)),
        //         ),
        //         rightButton: Align(
        //           alignment: Alignment.centerRight,
        //           child: SizedBox(
        //               width: DeviceDimensions.screenWidth(context) * 0.035),
        //         ),
        //       ),
        //       SizedBox(height: DeviceDimensions.screenHeight(context) * 0.020),
        //       Flexible(
        //         child: SingleChildScrollView(
        //           child: Column(
        //             children: [
        //               Swiper(
        //                 itemCount: plans.length,
        //                 itemBuilder: (BuildContext context, int index) {
        //                   return PricingCard(
        //                     plan: plans[index],
        //                     selectedCard: selectedCard,
        //                     selectedColorOption: selectedColorOption,
        //                   );
        //                 },
        //                 //pagination: const SwiperPagination(),
        //                 //control: const SwiperControl(),
        //                 viewportFraction: 0.8,
        //                 itemWidth: DeviceDimensions.screenWidth(context) *
        //                     0.8, // Define width for cards
        //                 itemHeight: DeviceDimensions.screenHeight(context) *
        //                     0.85, // Define height for cards
        //                 scale: 0.8,
        //                 loop: false,
        //                 layout: SwiperLayout.STACK,
        //                 scrollDirection: Axis.horizontal,
        //                 axisDirection: AxisDirection.right,
        //               ),
        //               SizedBox(
        //                 height: DeviceDimensions.screenHeight(context) * 0.05,
        //               )
        //             ],
        //           ),
        //         ),
        //       ),
        //     ],
        //   ),

        body: Column(
          children: [
            SizedBox(height: DeviceDimensions.screenHeight(context) * 0.0001),
            AbsherAppBar(
              title: 'Select Your Plan',
              leftButton: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 9),
                    child:
                        Icon(Icons.arrow_back, color: AppColors.appBlueColor)),
              ),
              rightButton: Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                    width: DeviceDimensions.screenWidth(context) * 0.035),
              ),
            ),
            SizedBox(height: DeviceDimensions.screenHeight(context) * 0.020),
            Flexible(
              child: FutureBuilder<List<PricingPlan>>(
                future: pricingPlanService.getPlans(context),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No Plans Available'));
                  } else {
                    final plans = snapshot.data!;
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          Swiper(
                            itemCount: plans.length,
                            itemBuilder: (BuildContext context, int index) {
                              return PricingCard(
                                plan: plans[index],
                                selectedCard: selectedCard,
                                selectedColorOption: selectedColorOption,
                              );
                            },
                            viewportFraction: 0.8,
                            itemWidth:
                                DeviceDimensions.screenWidth(context) * 0.8,
                            itemHeight:
                                DeviceDimensions.screenHeight(context) * 0.85,
                            scale: 0.8,
                            loop: false,
                            layout: SwiperLayout.STACK,
                            scrollDirection: Axis.horizontal,
                            axisDirection: AxisDirection.right,
                          ),
                          SizedBox(
                              height: DeviceDimensions.screenHeight(context) *
                                  0.05),
                        ],
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
