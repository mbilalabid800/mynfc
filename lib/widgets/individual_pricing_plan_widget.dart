import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nfc_app/constants/appColors.dart';
import 'package:nfc_app/provider/individual_pricing_plan_provider.dart';
import 'package:nfc_app/responsive/device_dimensions.dart';
import 'package:nfc_app/shared/common_widgets/custom_loader_widget.dart';
import 'package:nfc_app/shared/common_widgets/custom_snackbar_widget.dart';
import 'package:nfc_app/widgets/monthly_subscription_plan_widget.dart';
import 'package:provider/provider.dart';
import '../models/price_feature_model.dart';

class IndividualPricingPlanWidget extends StatefulWidget {
  const IndividualPricingPlanWidget({super.key});

  @override
  State<IndividualPricingPlanWidget> createState() =>
      _IndividualPricingPlanWidgetState();
}

class _IndividualPricingPlanWidgetState
    extends State<IndividualPricingPlanWidget> {
  int? selectedContainer;
  String? selectedPlanName;
  //bool isLoading = false;
  bool isFetchingPlans = false;
  bool isSavingPlan = false;
  List<Map<String, dynamic>> plans = [];

  @override
  void initState() {
    super.initState();
    // fetchPlansFromFireStore();
  }

  @override
  Widget build(BuildContext context) {
    final individualPricingPlanProvider =
        Provider.of<IndividualPricingProvider>(context);
    return Scaffold(
      backgroundColor: AppColors.screenBackground,
      body: Stack(children: [
        Center(
          child: Column(
            children: [
              Container(
                width: DeviceDimensions.screenWidth(context) * 0.90,
                height: DeviceDimensions.screenHeight(context) * 0.065,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30)),
                child: Center(
                  child: Text(
                    'Individual Pricing Plan',
                    style: TextStyle(
                        color: AppColors.appBlueColor,
                        fontWeight: FontWeight.w500,
                        fontSize:
                            DeviceDimensions.responsiveSize(context) * 0.05),
                  ),
                ),
              ),
              SizedBox(height: DeviceDimensions.screenHeight(context) * 0.020),
              Expanded(
                child: individualPricingPlanProvider.isFetchingPlans
                    ? SmallThreeBounceLoader()
                    : individualPricingPlanProvider.plans.isEmpty
                        ? Text('No Plans available')
                        : ListView.builder(
                            padding: EdgeInsets.only(
                                bottom: DeviceDimensions.screenHeight(context) *
                                    0.08),
                            itemCount:
                                individualPricingPlanProvider.plans.length,
                            itemBuilder: (context, index) {
                              final plan =
                                  individualPricingPlanProvider.plans[index];
                              return _buildPricingContainer(
                                //context,
                                index: index,
                                title: plan['title'],
                                oldPrice: plan['oldPrice'],
                                newPrice: plan['newPrice'],
                                features: (plan['features'] as List)
                                    .map((feature) => PriceFeatureModel(
                                        iconPath: feature['iconPath'],
                                        description: feature['description']))
                                    .toList(),
                                selected: individualPricingPlanProvider
                                        .selectedContainer ==
                                    index,
                                onTap: () => individualPricingPlanProvider
                                    .selectPlan(index, plan['title']),
                                onLearnMore: () => showModalBottomSheet(
                                  context: context,
                                  backgroundColor: Colors.white,
                                  isScrollControlled: true,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(25)),
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
                                          child:
                                              MonthlySubscriptionPlanWidget(),
                                        );
                                      },
                                    );
                                  },
                                ),
                              );
                            },
                          ),
              ),
            ],
          ),
        ),
        Positioned(
            bottom: 20,
            left: 33,
            child: SizedBox(
              width: DeviceDimensions.screenWidth(context) * 0.8,
              height: 49,
              child: ElevatedButton(
                onPressed: isSavingPlan
                    ? null
                    : () async {
                        if (selectedPlanName != null &&
                            selectedPlanName!.isNotEmpty) {
                          setState(() {
                            isSavingPlan = true;
                          });

                          await individualPricingPlanProvider
                              .savePlanToFirebase(context);
                          if (context.mounted) {
                            Navigator.pop(context);
                          }
                          setState(() {
                            isSavingPlan = false; // Hide loader
                          });
                        } else {
                          CustomSnackbar().snakBarError(
                              context, "Please select a plan first");
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.appBlueColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                child: isSavingPlan
                    ? SmallThreeBounceLoader()
                    : Text(
                        'Upgrade Now',
                        style: TextStyle(
                            fontSize: DeviceDimensions.responsiveSize(context) *
                                0.042,
                            color: Colors.white,
                            fontFamily: 'Barlow-Regular',
                            letterSpacing: 1,
                            fontWeight: FontWeight.w600),
                      ),
              ),
            ))
      ]),
    );
  }

  Widget _buildPricingContainer({
    required int index,
    required String title,
    String? oldPrice,
    required String newPrice,
    required List<PriceFeatureModel> features,
    required bool selected,
    required VoidCallback onTap,
    required VoidCallback onLearnMore,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: DeviceDimensions.screenWidth(context) * 0.90,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.white,
              border: Border.all(
                width: 2,
                color:
                    selected ? AppColors.appBlueColor : const Color(0xFFD9D9D9),
              ),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
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
                            fontSize: DeviceDimensions.responsiveSize(context) *
                                0.060,
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
                  SizedBox(
                      height: DeviceDimensions.screenHeight(context) * 0.0030),
                  Text(
                    oldPrice ?? '',
                    style: TextStyle(
                      fontFamily: 'Barlow-Regular',
                      fontSize:
                          DeviceDimensions.responsiveSize(context) * 0.035,
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                  SizedBox(
                      height: DeviceDimensions.screenHeight(context) * 0.0030),
                  Text(
                    newPrice,
                    style: TextStyle(
                        fontFamily: 'Barlow-Bold',
                        fontSize:
                            DeviceDimensions.responsiveSize(context) * 0.055,
                        fontWeight: FontWeight.w500),
                  ),
                  const Divider(
                    color: Color(0xFFD9D9D9),
                  ),
                  SizedBox(
                      height: DeviceDimensions.screenHeight(context) * 0.007),
                  ...features.map(
                    (feature) => Row(
                      children: [
                        if (feature.iconPath.startsWith('http'))
                          CachedNetworkImage(
                            imageUrl: feature.iconPath,
                            width: 22,
                            height: 22,
                            placeholder: (context, url) => SizedBox(
                              width: 22,
                              height: 22,
                              child: SmallThreeBounceLoader(),
                            ),
                            //SmallThreeBounceLoader(),
                            errorWidget: (context, url, error) => Icon(
                                Icons.image_not_supported,
                                color: Colors.grey),
                            fadeInDuration: const Duration(milliseconds: 500),
                            fadeOutDuration: const Duration(milliseconds: 500),
                          )
                        else
                          SvgPicture.asset(
                            feature.iconPath,
                            width: 22,
                            height: 22,
                            placeholderBuilder: (context) => SizedBox(
                                width: 22,
                                height: 22,
                                child: SmallThreeBounceLoader()),
                          ),
                        // SvgPicture.asset(
                        //   feature.iconPath,
                        //   width: 22,
                        //   height: 22,
                        // ),
                        SizedBox(
                          width: DeviceDimensions.screenWidth(context) * 0.030,
                        ),
                        Expanded(
                          child: Text(
                            feature.description,
                            style: TextStyle(
                              fontFamily: 'Barlow-Regular',
                              fontSize:
                                  DeviceDimensions.responsiveSize(context) *
                                      0.038,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        SizedBox(
                            height:
                                DeviceDimensions.screenHeight(context) * 0.035),
                      ],
                    ),
                  ),
                  SizedBox(
                      height: DeviceDimensions.screenHeight(context) * 0.015),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: GestureDetector(
                      onTap: onLearnMore,
                      child: Text(
                        "Learn more",
                        style: TextStyle(
                            fontFamily: 'Barlow-Regular',
                            fontSize: DeviceDimensions.responsiveSize(context) *
                                0.045,
                            fontWeight: FontWeight.w600,
                            wordSpacing: 4,
                            decoration: TextDecoration.underline,
                            decorationThickness: 2),
                      ),
                    ),
                  ),
                  SizedBox(
                      height: DeviceDimensions.screenHeight(context) * 0.010),
                ],
              ),
            ),
          ),
          SizedBox(
            height: DeviceDimensions.screenHeight(context) * 0.02,
          ),
          // if (index == plans.length - 1)
          //   Padding(
          //     padding: EdgeInsets.only(
          //         bottom: DeviceDimensions.screenHeight(context) * 0.12),
          //   )
          //SizedBox(height: DeviceDimensions.screenHeight(context) * 0.1),
        ],
      ),
    );
  }
}
