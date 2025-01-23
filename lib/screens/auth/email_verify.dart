// ignore_for_file: file_names, use_build_context_synchronously

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nfc_app/constants/appColors.dart';
import 'package:nfc_app/provider/authenticate_provider.dart';
import 'package:nfc_app/provider/resent_email.dart';
import 'package:nfc_app/responsive/device_dimensions.dart';
import 'package:nfc_app/services/auth_service/auth_service.dart';
import 'package:nfc_app/services/shared_preferences_service/shared_preferences_services.dart';
import 'package:nfc_app/shared/utils/ui_mode_helper.dart';
import 'package:provider/provider.dart';
import 'package:nfc_app/provider/user_info_form_state_provider.dart';

class EmailVerify extends StatefulWidget {
  const EmailVerify({super.key});

  @override
  State<EmailVerify> createState() => _EmailVerifyState();
}

class _EmailVerifyState extends State<EmailVerify> {
  Timer? _timer;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    loadEmailFromPrefs();
    enableImmersiveStickyMode();
    startEmailVerificationCheck();
  }

  void loadEmailFromPrefs() async {
    SharedPreferencesServices prefsService = SharedPreferencesServices();
    String? email = await prefsService.getEmail();

    // Use the email as needed, for example, assign it to a provider
    // Assuming you're using a provider to hold the email
    Provider.of<UserInfoFormStateProvider>(context, listen: false)
        .setEmail(email!);
  }

  void startEmailVerificationCheck() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      User? user = _auth.currentUser;
      await user?.reload();
      if (user != null && user.emailVerified) {
        _timer?.cancel();
        Navigator.pushNamed(context, "/email-verified");
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            SizedBox(
              height: DeviceDimensions.screenHeight(context) * 0.70,
              width: DeviceDimensions.screenWidth(context),
              child: Image.asset(
                "assets/images/verifyemail2.png",
                fit: BoxFit.cover,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: DeviceDimensions.screenHeight(context) * 0.42,
                width: DeviceDimensions.screenWidth(context),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    SizedBox(
                        height: DeviceDimensions.screenHeight(context) * 0.015),
                    Container(
                      width: 80,
                      height: 7.0,
                      decoration: BoxDecoration(
                        color: AppColors.appBlueColor,
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    SizedBox(
                        height: DeviceDimensions.screenHeight(context) * 0.030),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 34),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Verify your email",
                            style: TextStyle(
                                fontSize:
                                    DeviceDimensions.responsiveSize(context) *
                                        0.073,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Barlow-Bold',
                                color: AppColors.textColorBlue),
                          ),
                          SizedBox(
                              height: DeviceDimensions.screenHeight(context) *
                                  0.015),
                          Text(
                            "Please check your inbox and tap the link in the email we’ve just sent to:",
                            style: TextStyle(
                                fontSize:
                                    DeviceDimensions.responsiveSize(context) *
                                        0.038,
                                fontFamily: 'Barlow-Regular',
                                color: AppColors.textColorBlue),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                        height: DeviceDimensions.screenHeight(context) * 0.050),
                    Consumer<UserInfoFormStateProvider>(
                        builder: (context, provider, child) {
                      return Text(
                        provider.email,
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: DeviceDimensions.responsiveSize(context) *
                                0.0473,
                            fontFamily: 'Barlow-Regular',
                            color: AppColors.textColorBlue),
                      );
                    }),
                    SizedBox(
                        height: DeviceDimensions.screenHeight(context) * 0.025),
                    SizedBox(
                      width: DeviceDimensions.screenWidth(context) * 0.8,
                      child: Consumer<ResentButtonProvider>(
                        builder: (context, provider, child) {
                          return ElevatedButton(
                            onPressed: provider.isButtonEnabled
                                ? () {
                                    provider.resentEmail();
                                    AuthService().sendVerificationEmail(
                                        context: context);
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.appBlueColor,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                            child: Text(
                              'Resend it',
                              style: TextStyle(
                                  fontSize:
                                      DeviceDimensions.responsiveSize(context) *
                                          0.0445,
                                  color: Colors.white,
                                  fontFamily: 'Barlow-Regular',
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                        height: DeviceDimensions.screenHeight(context) * 0.025),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Email is wrong??",
                          style: TextStyle(
                            fontFamily: 'Barlow-Regular',
                            color: AppColors.textColorBlue,
                          ),
                        ),
                        SizedBox(
                            width:
                                DeviceDimensions.screenWidth(context) * 0.015),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacementNamed(
                                context, "/login-screen");
                            Provider.of<AuthenticateProvider>(context,
                                    listen: false)
                                .clear();
                          },
                          child: Text(
                            "click here",
                            style: TextStyle(
                              fontFamily: 'Barlow-Regular',
                              fontWeight: FontWeight.bold,
                              color: AppColors.textColorBlue,
                              fontSize:
                                  DeviceDimensions.responsiveSize(context) *
                                      0.040,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
