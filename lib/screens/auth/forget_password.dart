// ignore_for_file: file_names, use_build_context_synchronously, deprecated_member_use, avoid_print
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nfc_app/constants/appColors.dart';
import 'package:nfc_app/provider/authenticate_provider.dart';
import 'package:nfc_app/responsive/device_dimensions.dart';
import 'package:nfc_app/shared/common_widgets/my_button.dart';

import 'package:provider/provider.dart';

import '../../shared/common_widgets/custom_loader_widget.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Consumer<AuthenticateProvider>(
          builder: (context, authProvider, child) => Stack(
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
                  height: DeviceDimensions.screenHeight(context) * 0.48,
                  width: DeviceDimensions.screenWidth(context),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 34),
                    child: Column(
                      children: [
                        SizedBox(
                            height:
                                DeviceDimensions.screenHeight(context) * 0.015),
                        Container(
                          width: DeviceDimensions.screenWidth(context) * 0.16,
                          height:
                              DeviceDimensions.screenHeight(context) * 0.007,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        SizedBox(
                            height:
                                DeviceDimensions.screenHeight(context) * 0.030),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Forgot password",
                            style: TextStyle(
                                fontSize:
                                    DeviceDimensions.responsiveSize(context) *
                                        0.068,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Barlow-Bold'),
                          ),
                        ),
                        SizedBox(
                            height:
                                DeviceDimensions.screenHeight(context) * 0.015),
                        Text(
                          "In order to reset password ,please provide us your email. We will send you an verification code momentarily.",
                          style: TextStyle(
                              fontSize:
                                  DeviceDimensions.responsiveSize(context) *
                                      0.033,
                              fontFamily: 'Barlow-Regular',
                              color: AppColors.appBlueColor),
                        ),
                        SizedBox(
                            height:
                                DeviceDimensions.screenHeight(context) * 0.050),
                        Form(
                          key: authProvider.forgetPassowrdFormKey,
                          child: TextFormField(
                            controller:
                                authProvider.forgetPasswordEmailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              hintText: "Email",
                              hintStyle: const TextStyle(
                                color: Color(0xFFA9A9A9),
                                fontFamily: 'Barlow-Regular',
                                fontWeight: FontWeight.w500,
                              ),
                              prefixIcon: Padding(
                                padding: const EdgeInsets.only(
                                    top: 12.0, bottom: 12, left: 20, right: 10),
                                child: SvgPicture.asset(
                                  "assets/icons/email.svg",
                                  height: 17,
                                  width: 17,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide:
                                    const BorderSide(color: Color(0xFFA9A9A9)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide:
                                    const BorderSide(color: Color(0xFFA9A9A9)),
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your email';
                              }
                              final emailPattern =
                                  RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                              if (!emailPattern.hasMatch(value)) {
                                return 'Please enter a valid email address';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(
                            height:
                                DeviceDimensions.screenHeight(context) * 0.065),
                        MyButton(
                          text: "Forget Password",
                          onPressed: () {
                            authProvider.resetPassword(context);
                          },
                          width: DeviceDimensions.screenWidth(context) * 0.82,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (authProvider.isLoading)
                Container(
                  color: Colors.white54,
                  child: Center(
                    child: const DualRingLoader(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
