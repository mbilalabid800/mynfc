// screens/subscription_plan_screen.dart

import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:nfc_app/constants/appColors.dart';
import 'package:nfc_app/models/pricing_plan_model.dart';
import 'package:nfc_app/services/pricing_plan_service.dart';
import 'package:nfc_app/widgets/custom_app_bar_widget.dart';
import 'package:nfc_app/widgets/pricing_card_widget.dart';
import 'package:nfc_app/responsive/device_dimensions.dart';

class PricingPlansScreen extends StatelessWidget {
  final PricingPlanService pricingPlanService = PricingPlanService();

  PricingPlansScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<PricingPlan> plans = pricingPlanService.getPlans();

    return SafeArea(
      child: Scaffold(
        appBar: const CustomAppBar(title: "Select Your Plan"),
        backgroundColor: AppColors.screenBackground,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Swiper(
                itemCount: plans.length,
                itemBuilder: (BuildContext context, int index) {
                  return PricingCard(plan: plans[index]);
                },
                //pagination: const SwiperPagination(),
                //control: const SwiperControl(),
                viewportFraction: 0.8,
                itemWidth: DeviceDimensions.screenWidth(context) *
                    0.8, // Define width for cards
                itemHeight: DeviceDimensions.screenHeight(context) *
                    0.8, // Define height for cards
                scale: 0.8,
                loop: false,
                layout: SwiperLayout.STACK,
                scrollDirection: Axis.horizontal,
                axisDirection: AxisDirection.right,
              ),
              SizedBox(
                height: DeviceDimensions.screenHeight(context) * 0.05,
              )
            ],
          ),
        ),
      ),
    );
  }
}
