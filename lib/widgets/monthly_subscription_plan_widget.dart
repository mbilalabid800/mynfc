import 'package:flutter/material.dart';
import 'package:nfc_app/components/features_card.dart';
import 'package:nfc_app/responsive/device_dimensions.dart';

class MonthlySubscriptionPlanWidget extends StatefulWidget {
  const MonthlySubscriptionPlanWidget({super.key});

  @override
  State<MonthlySubscriptionPlanWidget> createState() =>
      _MonthlySubscriptionPlanWidgetState();
}

class _MonthlySubscriptionPlanWidgetState
    extends State<MonthlySubscriptionPlanWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(""),
              Padding(
                padding: const EdgeInsets.only(left: 17.0),
                child: Container(
                  width: DeviceDimensions.screenWidth(context) * 0.16,
                  height: DeviceDimensions.screenHeight(context) * 0.007,
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
              GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(Icons.close)),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, top: 10.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "PRO+",
                      style: TextStyle(
                          fontFamily: "Barlow-Bold",
                          fontSize:
                              DeviceDimensions.responsiveSize(context) * 0.055,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                SizedBox(
                    height: DeviceDimensions.screenHeight(context) * 0.015),
                const FeaturesCard(
                  title1: "All PRO Features",
                  description1:
                      "Enjoy more than 20+ features of the PRO plan in addition to the new PRO+ features.",
                  image: "assets/images/monthlysubscriptionplan1.png",
                  title2: "All in PRO",
                  description2:
                      "Enjoy more than 20+ features of the PRO plan in addition to extra exclusive features.",
                ),
                const FeaturesCard(
                  title1: "Create up to 5 Profiles",
                  description1:
                      "Build and manage 5 different profiles with all features and capabilities.",
                  image: "assets/images/monthlysubscriptionplan2.png",
                  title2: "Create up to 5 profiles",
                  description2:
                      "Build and manage 5 different profiles with all features and capabilities.",
                ),
                const FeaturesCard(
                  title1: "Add to Apple Wallet",
                  description1:
                      "Easily share your cards through our integration with Apple Wallet.",
                  image: "assets/images/monthlysubscriptionplan3.png",
                  title2: "Add to digital wallets",
                  description2:
                      "Easily share your cards through our integration with Mobile digital Wallets.",
                ),
                const FeaturesCard(
                  title1: "Tailored Exchange",
                  description1:
                      "When scanned on an iPhone, your branded card instantly displays on their device.",
                  image: "assets/images/monthlysubscriptionplan4.png",
                  title2: "Tailored Exchange",
                  description2:
                      "When scanned on an iPhone, your branded card instantly displays on their device.",
                ),
                const FeaturesCard(
                  title1: "Exclusive Link Types",
                  description1:
                      "Access exclusive link types such as images carousel and video embeds.",
                  image: "assets/images/monthlysubscriptionplan5.png",
                  title2: "Exclusive Link Types",
                  description2:
                      "Access exclusive link types such as images carousel and video embeds.",
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
