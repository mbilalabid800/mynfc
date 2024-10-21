import 'package:flutter/material.dart';
import 'package:nfc_app/components/features_card.dart';
import 'package:nfc_app/responsive/device_dimensions.dart';

class ThreeMonthSubscriptionPlanWidget extends StatefulWidget {
  const ThreeMonthSubscriptionPlanWidget({super.key});

  @override
  State<ThreeMonthSubscriptionPlanWidget> createState() =>
      _ThreeMonthlySubscriptionPlanWidgetState();
}

class _ThreeMonthlySubscriptionPlanWidgetState
    extends State<ThreeMonthSubscriptionPlanWidget> {
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
                      "Your PRO Features",
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
                  title1: "Customized Sharing",
                  description1:
                      "Tailor te information you share based on the specific context or recipient.",
                  image: "assets/images/yearlysubscriptionplan1.png",
                  title2: "Custom QR code",
                  description2:
                      "Get your QR code personalized, add your logo, change colors and more.",
                ),
                const FeaturesCard(
                  title1: "Scan Physical Business Cards",
                  description1:
                      "Enables users to digitize traditional business cards using their smart phone’s camera.",
                  image: "assets/images/yearlysubscriptionplan2.png",
                  title2: "Business card scanner",
                  description2:
                      "Effortlessly build your contact list with our convenient scan feature.",
                ),
                const FeaturesCard(
                  title1: "Personalized Profiles",
                  description1:
                      "Allows users to create highly customizable digital profiles that go beyond basic contact information.",
                  image: "assets/images/yearlysubscriptionplan3.png",
                  title2: "Personal & Business Profiles",
                  description2:
                      "Have more than one profiles and tailor your presence for every occasion, and have your account verified.",
                ),
                const FeaturesCard(
                  title1: "50+ more links",
                  description1:
                      "Maximize your networking opportunities with our PRO plan and unlimited PRO links",
                  image: "assets/images/yearlysubscriptionplan4.png",
                  title2: "Unlimited Pro Links",
                  description2:
                      "Maximize your networking opportunities with our PRO plan and unlimited PRO links",
                ),
                const FeaturesCard(
                  title1: "Offline Sharing Mode",
                  description1:
                      "No internet? No problem, use our in-app QR code to stay connected.",
                  image: "assets/images/yearlysubscriptionplan5.png",
                  title2: "Offline Sharing Mode",
                  description2:
                      "No internet? No problem, use our in-app QR code to stay connected.",
                ),
                const FeaturesCard(
                  title1: "Color Customization",
                  description1:
                      "Create unique icons for your links! Setting up better icons can help with engagement rate.",
                  image: "assets/images/yearlysubscriptionplan6.png",
                  title2: "Color Customization",
                  description2:
                      "Create unique icons for your links! Setting up better icons can help with engagement rate.",
                ),
                const FeaturesCard(
                  title1: "Home Screen Widget",
                  description1:
                      "Home widget allows you to scan directly from highly customizable widgets, which can include your logo.",
                  image: "assets/images/yearlysubscriptionplan7.png",
                  title2: "Home Screen Widget",
                  description2:
                      "Home widget allows you to scan directly from highly customizable widgets, which can include your logo.",
                ),
                const FeaturesCard(
                  title1: "Track Your Performance",
                  description1:
                      "Stay ahead by monitoring your performance metrics, views, and taps.",
                  image: "assets/images/yearlysubscriptionplan8.png",
                  title2: "Track You Performance",
                  description2:
                      "Get insights into your networking performance with our powerful analytics.",
                ),
                const FeaturesCard(
                  title1: "Verified Account",
                  description1:
                      "Get your account verified and increase credibility.",
                  image: "assets/images/yearlysubscriptionplan9.png",
                  title2: "Verified Account",
                  description2:
                      "Get your account verified and increase credibility.",
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
