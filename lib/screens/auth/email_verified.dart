// ignore_for_file: file_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:nfc_app/provider/connection_provider.dart';
import 'package:nfc_app/provider/social_app_provider.dart';
import 'package:nfc_app/provider/user_info_form_state_provider.dart';
import 'package:nfc_app/responsive/device_dimensions.dart';
import 'package:provider/provider.dart';

class EmailVerified extends StatefulWidget {
  const EmailVerified({super.key});

  @override
  State<EmailVerified> createState() => _EmailVerifyState();
}

class _EmailVerifyState extends State<EmailVerified> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            children: [
              SizedBox(height: DeviceDimensions.screenHeight(context) * 0.28),
              Image.asset(
                "assets/images/emailsent.png",
                height: 65,
                width: 65,
              ),
              SizedBox(height: DeviceDimensions.screenHeight(context) * 0.010),
              const Text(
                "Email verified",
                style: TextStyle(
                  fontSize: 24,
                  fontFamily: 'Barlow-Bold',
                ),
              ),
              SizedBox(height: DeviceDimensions.screenHeight(context) * 0.015),
              Text(
                "Your email address has been verified\nsuccessfully",
                style: TextStyle(
                    fontSize: DeviceDimensions.responsiveSize(context) * 0.040,
                    fontFamily: 'Barlow-Regular',
                    color: Colors.black),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              SizedBox(
                width: DeviceDimensions.screenWidth(context) * 0.80,
                height: 45,
                child: ElevatedButton(
                  onPressed: () async {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      '/mainNav-screen', // Your route name
                      (Route<dynamic> route) =>
                          false, // Remove all previous routes
                    );
                    await Provider.of<UserInfoFormStateProvider>(context,
                            listen: false)
                        .loadUserData();
                    await Provider.of<ConnectionProvider>(context,
                            listen: false)
                        .loadConnections();
                    await Provider.of<SocialAppProvider>(context, listen: false)
                        .loadSocialApps();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  child: Text(
                    'Continue',
                    style: TextStyle(
                        fontSize:
                            DeviceDimensions.responsiveSize(context) * 0.0445,
                        color: Colors.white,
                        fontFamily: 'Barlow-Regular',
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1),
                  ),
                ),
              ),
              SizedBox(height: DeviceDimensions.screenHeight(context) * 0.035),
            ],
          ),
        ),
      ),
    );
  }
}
