// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:nfc_app/constants/appColors.dart';
import 'package:nfc_app/provider/app_data_provider.dart';
import 'package:nfc_app/responsive/device_dimensions.dart';
import 'package:nfc_app/widgets/custom_app_bar_widget.dart';
import 'package:nfc_app/widgets/custom_loader_widget.dart';
import 'package:provider/provider.dart';

class PrivacyPolicy extends StatefulWidget {
  const PrivacyPolicy({super.key});

  @override
  State<PrivacyPolicy> createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => Provider.of<AppDataProvider>(context, listen: false)
        .fetchPrivacyPolicy());
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppDataProvider>(context);

    return SafeArea(
      child: Scaffold(
        appBar: const CustomAppBar(title: "Privacy Policy"),
        backgroundColor: AppColors.screenBackground,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: provider.isLoading
                    ? const Center(child: BigThreeBounceLoader())
                    : provider.privacyPolicy.isEmpty
                        ? Container(
                            width: DeviceDimensions.screenWidth(context) * 0.90,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Center(
                              child: Text(
                                "No Privacy Policy available.",
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          )
                        : SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 20.0),
                              child: Container(
                                width: DeviceDimensions.screenWidth(context) *
                                    0.90,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Column(
                                  children: [
                                    SizedBox(
                                        height: DeviceDimensions.screenHeight(
                                                context) *
                                            0.015),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: provider.privacyPolicy
                                            .asMap()
                                            .entries
                                            .map(
                                          (entry) {
                                            final index =
                                                entry.key + 1; // 1-based index
                                            final policy = entry.value;

                                            return Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "$index. ${policy.title}",
                                                  style: TextStyle(
                                                    fontSize: DeviceDimensions
                                                            .responsiveSize(
                                                                context) *
                                                        0.048,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'Barlow-Bold',
                                                  ),
                                                ),
                                                SizedBox(
                                                    height: DeviceDimensions
                                                            .screenHeight(
                                                                context) *
                                                        0.010),
                                                Text(
                                                  policy.descriptions,
                                                  style: TextStyle(
                                                    fontSize: DeviceDimensions
                                                            .responsiveSize(
                                                                context) *
                                                        0.035,
                                                    fontFamily:
                                                        'Barlow-Regular',
                                                  ),
                                                  textAlign: TextAlign.justify,
                                                ),
                                                SizedBox(
                                                    height: DeviceDimensions
                                                            .screenHeight(
                                                                context) *
                                                        0.020),
                                              ],
                                            );
                                          },
                                        ).toList(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
