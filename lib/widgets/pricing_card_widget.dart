import 'package:flutter/material.dart';
import 'package:nfc_app/constants/appColors.dart';
import 'package:nfc_app/models/pricing_plan_model.dart';
import 'package:nfc_app/responsive/device_dimensions.dart';

class PricingCard extends StatelessWidget {
  final PricingPlan plan;

  const PricingCard({super.key, required this.plan});

  Color _getTitleBackgroundColor(String category) {
    if (category.toLowerCase() == 'individuals') {
      return AppColors.individualCardColor;
    } else if (category.toLowerCase() == 'teams') {
      return AppColors.teamsCardColor;
    } else if (category.toLowerCase() == 'companies') {
      return AppColors.companiesCardColor;
    } else {
      return Colors.redAccent; // Default color
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize:
              MainAxisSize.min, // Ensure the card takes the size of its content
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
                color: _getTitleBackgroundColor(plan.category),
              ),
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(plan.icon),
                    Text(
                      textAlign: TextAlign.center,
                      plan.category,
                      style: TextStyle(
                        fontSize:
                            DeviceDimensions.responsiveSize(context) * 0.04,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: DeviceDimensions.screenHeight(context) * 0.001),
            Image.asset(plan.assetImagePath),

            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(plan.title,
                    style: TextStyle(
                        fontSize:
                            DeviceDimensions.responsiveSize(context) * 0.05,
                        fontWeight: FontWeight.w600)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Text(
                    plan.price,
                    style: TextStyle(
                        fontSize:
                            DeviceDimensions.responsiveSize(context) * 0.06,
                        fontWeight: FontWeight.w600,
                        color: AppColors.headingFontColor),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      plan.currency,
                      style: TextStyle(
                          fontSize:
                              DeviceDimensions.responsiveSize(context) * 0.05,
                          color: Colors.black54),
                    ),
                  ),
                ],
              ),
            ),

            //SizedBox(height: DeviceDimensions.screenHeight(context) * 0.02),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  plan.description,
                  //textAlign: TextAlign.center,
                  //softWrap: true,
                  overflow: TextOverflow.fade,
                  maxLines: 2,
                  style: TextStyle(
                      fontSize: DeviceDimensions.responsiveSize(context) * 0.03,
                      color: Colors.black54),
                ),
              ),
            ),
            SizedBox(height: DeviceDimensions.screenHeight(context) * 0.01),
            Column(
              children: plan.features
                  .map(
                    (feature) => Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4.0, horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Icon(Icons.check, color: Colors.green),
                          const SizedBox(width: 8),
                          SizedBox(
                            width: DeviceDimensions.screenWidth(context) * 0.6,
                            //height: DeviceDimensions.screenHeight(context) * 0.8,
                            child: Text(
                              feature,
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
            SizedBox(height: DeviceDimensions.screenHeight(context) * 0.02),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: _getTitleBackgroundColor(plan.category),
              ),
              width: DeviceDimensions.screenWidth(context) * 0.45,
              height: DeviceDimensions.screenHeight(context) * 0.06,
              child: Center(
                child: Text(
                  plan.buttonText,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: DeviceDimensions.responsiveSize(context) * 0.04,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
            SizedBox(height: DeviceDimensions.screenHeight(context) * 0.01),
          ],
        ),
      ),
    );
  }
}
