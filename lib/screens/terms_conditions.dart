import 'package:flutter/material.dart';
import 'package:nfc_app/constants/appColors.dart';
import 'package:nfc_app/provider/app_data_provider.dart';
import 'package:nfc_app/responsive/device_dimensions.dart';
import 'package:nfc_app/shared/common_widgets/custom_app_bar_widget.dart';
import 'package:nfc_app/shared/common_widgets/custom_loader_widget.dart';

import 'package:provider/provider.dart';

class TermsConditions extends StatefulWidget {
  const TermsConditions({super.key});

  @override
  State<TermsConditions> createState() => _TermsConditionsState();
}

class _TermsConditionsState extends State<TermsConditions> {
  bool isChecked = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AppDataProvider>(context, listen: false)
          .fetchTermConditions();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppDataProvider>(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.screenBackground,
        body: Column(
          children: [
            SizedBox(
              height: DeviceDimensions.screenHeight(context) * 0.0001,
            ),
            AbsherAppBar3(
              title: 'Terms & Conditions',
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
            Expanded(
              child: Center(
                child: Container(
                  width: DeviceDimensions.screenWidth(context) * 0.90,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: provider.isLoading
                      ? const Center(child: BigThreeBounceLoader())
                      : provider.termsCondition.isEmpty
                          ? const Center(
                              child: Text(
                                "No Terms & Conditions available.",
                                style: TextStyle(fontSize: 16),
                              ),
                            )
                          : SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                      height: DeviceDimensions.screenHeight(
                                              context) *
                                          0.015),
                                  ...provider.termsCondition.map((terms) {
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 20.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${terms['title'] ?? 'No Title'}",
                                            style: TextStyle(
                                              fontSize: DeviceDimensions
                                                      .responsiveSize(context) *
                                                  0.048,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Barlow-Bold',
                                            ),
                                          ),
                                          SizedBox(
                                              height:
                                                  DeviceDimensions.screenHeight(
                                                          context) *
                                                      0.010),
                                          Text(
                                            terms['content'] ??
                                                'No Description',
                                            style: TextStyle(
                                              fontSize: DeviceDimensions
                                                      .responsiveSize(context) *
                                                  0.035,
                                              fontFamily: 'Barlow-Regular',
                                            ),
                                            textAlign: TextAlign.justify,
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Checkbox(
                                        value: isChecked,
                                        activeColor: AppColors.appBlueColor,
                                        onChanged: (value) {
                                          setState(() {
                                            isChecked = value ?? false;
                                          });
                                        },
                                      ),
                                      Expanded(
                                        child: Text(
                                          "I agree with Terms & Conditions",
                                          style: TextStyle(
                                            fontFamily: 'Barlow-Regular',
                                            fontSize:
                                                DeviceDimensions.responsiveSize(
                                                        context) *
                                                    0.037,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: SizedBox(
                height: DeviceDimensions.screenHeight(context) * 0.045,
                width: DeviceDimensions.screenWidth(context) * 0.70,
                child: ElevatedButton(
                  onPressed: isChecked ? () {} : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.appBlueColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: Text(
                    "Continue",
                    style: TextStyle(
                      fontSize:
                          DeviceDimensions.responsiveSize(context) * 0.038,
                      fontFamily: 'Barlow-Regular',
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
