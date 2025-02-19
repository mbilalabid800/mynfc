import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nfc_app/constants/appColors.dart';
import 'package:nfc_app/responsive/device_dimensions.dart';
import 'package:nfc_app/widgets/monthly_subscription_plan_widget.dart';
import 'package:nfc_app/widgets/three_month_subscription_plan_widget.dart';
import 'package:nfc_app/widgets/yearly_subscription_plan_widget.dart';

import '../models/price_feature_model.dart';

class IndividualSubscriptionWidget extends StatefulWidget {
  const IndividualSubscriptionWidget({super.key});

  @override
  State<IndividualSubscriptionWidget> createState() =>
      _IndividualSubscriptionWidgetState();
}

class _IndividualSubscriptionWidgetState
    extends State<IndividualSubscriptionWidget> {
  int? selectedContainer;

  // Default selected plan

  void _selectContainer(int index, String planName) {
    setState(() {
      selectedContainer = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenBackground,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 33.0),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            width: DeviceDimensions.screenWidth(context) * 0.8,
            height: 49,
            child: ElevatedButton(
              onPressed: () {
                //dummy link
                Navigator.pushNamed(context, '/card-details');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.appBlueColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              child: Text(
                'Upgrade Now',
                style: TextStyle(
                    fontSize: DeviceDimensions.responsiveSize(context) * 0.042,
                    color: Colors.white,
                    fontFamily: 'Barlow-Regular',
                    letterSpacing: 1,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: DeviceDimensions.screenHeight(context) * 0.020),
              _buildPricingContainer(
                index: 0,
                title: "Free",
                oldPrice: "",
                newPrice: "0",
                features: [
                  PriceFeatureModel(
                      iconPath: 'assets/icons/monthly1.svg',
                      description: '20 Card Scans per month'),
                  PriceFeatureModel(
                      iconPath: 'assets/icons/monthly2.svg',
                      description: 'Contact Sharing'),
                  // PriceFeatureModel(
                  //     iconPath: 'assets/icons/monthly3.svg',
                  //     description: 'Analytics & Insights'),
                  // PriceFeatureModel(
                  //     iconPath: 'assets/icons/monthly4.svg',
                  //     description: 'Private Profile'),
                  PriceFeatureModel(
                      iconPath: 'assets/icons/monthly2.svg',
                      description: '10 Connections allowed'),
                  PriceFeatureModel(
                      iconPath: 'assets/icons/monthly5.svg',
                      description: '3 Card Templates'),
                  PriceFeatureModel(
                      iconPath: 'assets/icons/monthly3.svg',
                      description: '5 Card Writes'),
                ],
                selected: selectedContainer == 0,
                onTap: () => _selectContainer(0, "Free"),
                onLearnMore: () => showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.white,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(25)),
                  ),
                  builder: (context) {
                    return DraggableScrollableSheet(
                      expand: false,
                      initialChildSize: 0.9,
                      minChildSize: 0.5,
                      maxChildSize: 0.9,
                      builder: (context, scrollController) {
                        return Container(
                          padding: const EdgeInsets.all(15),
                          child: const MonthlySubscriptionPlanWidget(),
                        );
                      },
                    );
                  },
                ),
              ),
              SizedBox(height: DeviceDimensions.screenHeight(context) * 0.020),
              _buildPricingContainer(
                index: 1,
                title: "Monthly",
                oldPrice: "1632.00 OMR",
                newPrice: "1032.00 OMR",
                features: [
                  PriceFeatureModel(
                      iconPath: 'assets/icons/monthly1.svg',
                      description: '20 Card Scans per month'),
                  PriceFeatureModel(
                      iconPath: 'assets/icons/monthly2.svg',
                      description: 'Contact Sharing'),
                  PriceFeatureModel(
                      iconPath: 'assets/icons/monthly3.svg',
                      description: 'Analytics & Insights'),
                  PriceFeatureModel(
                      iconPath: 'assets/icons/monthly4.svg',
                      description: 'Private Profile'),
                  PriceFeatureModel(
                      iconPath: 'assets/icons/monthly2.svg',
                      description: '10 Connections allowed'),
                  PriceFeatureModel(
                      iconPath: 'assets/icons/monthly5.svg',
                      description: '3 Card Templates'),
                  PriceFeatureModel(
                      iconPath: 'assets/icons/monthly3.svg',
                      description: '5 Card Writes'),
                ],
                selected: selectedContainer == 1,
                onTap: () => _selectContainer(1, "Monthly"),
                onLearnMore: () => showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.white,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(25)),
                  ),
                  builder: (context) {
                    return DraggableScrollableSheet(
                      expand: false,
                      initialChildSize: 0.9,
                      minChildSize: 0.5,
                      maxChildSize: 0.9,
                      builder: (context, scrollController) {
                        return Container(
                          padding: const EdgeInsets.all(15),
                          child: const MonthlySubscriptionPlanWidget(),
                        );
                      },
                    );
                  },
                ),
              ),
              SizedBox(height: DeviceDimensions.screenHeight(context) * 0.020),
              _buildPricingContainer(
                index: 2,
                title: "3 Months",
                oldPrice: "6025.00 OMR",
                newPrice: "5503.00 OMR",
                features: [
                  PriceFeatureModel(
                      iconPath: 'assets/icons/monthly1.svg',
                      description: '100 Card Scans per month'),
                  PriceFeatureModel(
                      iconPath: 'assets/icons/monthly2.svg',
                      description: 'Contact Sharing'),
                  PriceFeatureModel(
                      iconPath: 'assets/icons/monthly3.svg',
                      description: 'Detailed Analytics & Insights'),
                  PriceFeatureModel(
                      iconPath: 'assets/icons/monthly4.svg',
                      description: 'Private Profile'),
                  PriceFeatureModel(
                      iconPath: 'assets/icons/monthly2.svg',
                      description: '30 Connections allowed'),
                  PriceFeatureModel(
                      iconPath: 'assets/icons/monthly5.svg',
                      description: '20 Card Templates'),
                  PriceFeatureModel(
                      iconPath: 'assets/icons/monthly3.svg',
                      description: '20 Card Writes'),
                ],
                selected: selectedContainer == 2,
                onTap: () => _selectContainer(2, "3 Monthly"),
                onLearnMore: () => showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.white,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(25)),
                  ),
                  builder: (context) {
                    return DraggableScrollableSheet(
                      expand: false,
                      initialChildSize: 0.9,
                      minChildSize: 0.5,
                      maxChildSize: 0.9,
                      builder: (context, scrollController) {
                        return Container(
                          padding: const EdgeInsets.all(15),
                          child: const ThreeMonthSubscriptionPlanWidget(),
                        );
                      },
                    );
                  },
                ),
              ),
              SizedBox(height: DeviceDimensions.screenHeight(context) * 0.020),
              _buildPricingContainer(
                index: 3,
                title: "Yearly",
                oldPrice: "14025.00 OMR",
                newPrice: "12025.00 OMR",
                features: [
                  PriceFeatureModel(
                      iconPath: 'assets/icons/monthly1.svg',
                      description: 'Unlimited Card Scans per month'),
                  PriceFeatureModel(
                      iconPath: 'assets/icons/monthly2.svg',
                      description: 'Contact Sharing'),
                  PriceFeatureModel(
                      iconPath: 'assets/icons/monthly3.svg',
                      description: 'Add to digital wallets'),
                  PriceFeatureModel(
                      iconPath: 'assets/icons/monthly3.svg',
                      description: 'Detailed Analytics & Insights'),
                  PriceFeatureModel(
                      iconPath: 'assets/icons/monthly4.svg',
                      description: 'Private Profile'),
                  PriceFeatureModel(
                      iconPath: 'assets/icons/monthly2.svg',
                      description: 'Unlimited Connections allowed'),
                  PriceFeatureModel(
                      iconPath: 'assets/icons/monthly5.svg',
                      description: 'Unlimited Card Templates'),
                  PriceFeatureModel(
                      iconPath: 'assets/icons/monthly3.svg',
                      description: 'Unlimited Card Writes'),
                  PriceFeatureModel(
                      iconPath: 'assets/icons/3monthly9.svg',
                      description: 'Verified Account'),
                ],
                selected: selectedContainer == 3,
                onTap: () => _selectContainer(3, "Yearly"),
                onLearnMore: () => showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.white,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(25)),
                  ),
                  builder: (context) {
                    return DraggableScrollableSheet(
                      expand: false,
                      initialChildSize: 0.9,
                      minChildSize: 0.5,
                      maxChildSize: 0.9,
                      builder: (context, scrollController) {
                        return Container(
                          padding: const EdgeInsets.all(15),
                          child: const YearlySubscriptionPlanWidget(),
                        );
                      },
                    );
                  },
                ),
              ),
              SizedBox(height: DeviceDimensions.screenHeight(context) * 0.065),
              SizedBox(height: DeviceDimensions.screenHeight(context) * 0.020),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPricingContainer({
    required int index,
    required String title,
    required String oldPrice,
    required String newPrice,
    required List<PriceFeatureModel> features,
    required bool selected,
    required VoidCallback onTap,
    required VoidCallback onLearnMore,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: DeviceDimensions.screenWidth(context) * 0.90,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.white,
          border: Border.all(
            width: 2,
            color: selected ? AppColors.appBlueColor : const Color(0xFFD9D9D9),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                        fontFamily: 'Barlow-Bold',
                        fontSize:
                            DeviceDimensions.responsiveSize(context) * 0.060,
                        fontWeight: FontWeight.w600),
                  ),
                  Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: selected
                          ? AppColors.appBlueColor
                          : Colors.transparent,
                      border: Border.all(
                        color: const Color(0xFF000000),
                        width: 2.0,
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: DeviceDimensions.screenHeight(context) * 0.0030),
              Text(
                oldPrice,
                style: TextStyle(
                  fontFamily: 'Barlow-Regular',
                  fontSize: DeviceDimensions.responsiveSize(context) * 0.035,
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
              SizedBox(height: DeviceDimensions.screenHeight(context) * 0.0030),
              Text(
                newPrice,
                style: TextStyle(
                    fontFamily: 'Barlow-Bold',
                    fontSize: DeviceDimensions.responsiveSize(context) * 0.055,
                    fontWeight: FontWeight.w500),
              ),
              const Divider(
                color: Color(0xFFD9D9D9),
              ),
              SizedBox(height: DeviceDimensions.screenHeight(context) * 0.007),
              ...features.map(
                (feature) => Row(
                  children: [
                    SvgPicture.asset(
                      feature.iconPath,
                      width: 22,
                      height: 22,
                    ),
                    SizedBox(
                      width: DeviceDimensions.screenWidth(context) * 0.030,
                    ),
                    Expanded(
                      child: Text(
                        feature.description,
                        style: TextStyle(
                          fontFamily: 'Barlow-Regular',
                          fontSize:
                              DeviceDimensions.responsiveSize(context) * 0.038,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    SizedBox(
                        height: DeviceDimensions.screenHeight(context) * 0.035),
                  ],
                ),
              ),
              SizedBox(height: DeviceDimensions.screenHeight(context) * 0.015),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: GestureDetector(
                  onTap: onLearnMore,
                  child: Text(
                    "Learn more",
                    style: TextStyle(
                        fontFamily: 'Barlow-Regular',
                        fontSize:
                            DeviceDimensions.responsiveSize(context) * 0.045,
                        fontWeight: FontWeight.w600,
                        wordSpacing: 4,
                        decoration: TextDecoration.underline,
                        decorationThickness: 2),
                  ),
                ),
              ),
              SizedBox(height: DeviceDimensions.screenHeight(context) * 0.010),
            ],
          ),
        ),
      ),
    );
  }
}
