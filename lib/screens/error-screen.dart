// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:nfc_app/constants/appColors.dart';
import 'package:url_launcher/url_launcher.dart';

class ErrorScreen extends StatelessWidget {
  final String message;

  const ErrorScreen({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenBackground,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Barlow-Regular',
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textColorBlue,
                ),
              ),
              const SizedBox(height: 60),
              Text(
                "Create your own Profile on Absher",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Barlow-Regular',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textColorBlue,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Replace with your Play Store app link
                  const playStoreUrl =
                      "https://play.google.com/store/apps/details?id=com.example.app";
                  _launchURL(playStoreUrl);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.appBlueColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
                ),
                child: const Text(
                  'Download App',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }
}
