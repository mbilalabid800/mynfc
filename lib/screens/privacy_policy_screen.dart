import 'package:flutter/material.dart';
import 'package:nfc_app/constants/appColors.dart';
import 'package:nfc_app/responsive/device_dimensions.dart';
import 'package:nfc_app/widgets/custom_app_bar_widget.dart';

class PrivacyPolicy extends StatefulWidget {
  const PrivacyPolicy({super.key});

  @override
  State<PrivacyPolicy> createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: const CustomAppBar(title: "Privacy Policy"),
        backgroundColor: AppColors.screenBackground,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: DeviceDimensions.screenHeight(context) * 0.020),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    width: DeviceDimensions.screenWidth(context) * 0.90,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                            height:
                                DeviceDimensions.screenHeight(context) * 0.020),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Expanded(
                            child: SingleChildScrollView(
                              child: Text(
                                "Your privacy is important to us. It is Brainstorming's policy to respect your privacy regarding any information we may collect from you across our website, and other sites we own and operate.\n\n"
                                "We only ask for personal information when we truly need it to provide a service to you. We collect it by fair and lawful means, with your knowledge and consent. We also let you know why we’re collecting it and how it will be used.\n\n"
                                "We only retain collected information for as long as necessary to provide you with your requested service. What data we store, we’ll protect within commercially acceptable means to prevent loss and theft, as well as unauthorized access, disclosure, copying, use or modification.\n\n"
                                "We don’t share any personally identifying information publicly or with third-parties, except when required to by law.\n\n"
                                "What data we store, we’ll protect within commercially acceptable means to prevent loss and theft, as well as unauthorized access, disclosure, copying, use or modification.\n\n"
                                "We don’t share any personally identifying information publicly or with third-parties, except when required to by law.What data we store, we’ll protect within commercially acceptable means to prevent loss and theft, as well as unauthorized access, disclosure, copying, use or modification.",
                                style: TextStyle(
                                    fontSize: DeviceDimensions.responsiveSize(
                                            context) *
                                        0.035,
                                    fontFamily: 'Barlow-Regular'),
                                textAlign: TextAlign.justify,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                            height:
                                DeviceDimensions.screenHeight(context) * 0.020),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: DeviceDimensions.screenHeight(context) * 0.020),
            ],
          ),
        ),
      ),
    );
  }
}
