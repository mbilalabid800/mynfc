// ignore_for_file: file_names, use_build_context_synchronously, deprecated_member_use, avoid_print
import 'package:flutter/material.dart';
import 'package:nfc_app/constants/appColors.dart';
import 'package:nfc_app/provider/authenticate_provider.dart';
import 'package:nfc_app/provider/user_info_form_state_provider.dart';
import 'package:nfc_app/responsive/device_dimensions.dart';
import 'package:nfc_app/shared/common_widgets/my_button.dart';
import 'package:nfc_app/shared/common_widgets/my_textfield.dart';
import 'package:nfc_app/shared/utils/no_back_button_observer.dart';

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
      child: GlobalBackButtonHandler(
        child: Scaffold(
          body: Consumer2<AuthenticateProvider, UserInfoFormStateProvider>(
            builder: (context, authProvider, userProvider, child) => Stack(
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
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 21),
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
                        ),
                        SizedBox(
                            height:
                                DeviceDimensions.screenHeight(context) * 0.015),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 21),
                          child: Text(
                            "In order to reset password ,please provide us your email. We will send you an verification code momentarily.",
                            style: TextStyle(
                                fontSize:
                                    DeviceDimensions.responsiveSize(context) *
                                        0.033,
                                fontFamily: 'Barlow-Regular',
                                color: AppColors.appBlueColor),
                          ),
                        ),
                        SizedBox(
                            height:
                                DeviceDimensions.screenHeight(context) * 0.050),
                        Form(
                          key: authProvider.forgetPasswordFormKey,
                          child: MyTextfield(
                              controller:
                                  authProvider.forgetPasswordEmailController,
                              hintText: 'Email',
                              iconPath: 'assets/icons/email.svg',
                              errorText: userProvider.emailError,
                              onChanged: (value) {
                                userProvider.validateEmail(value);
                              },
                              validator: (value) {
                                if (value?.isEmpty ?? true) {
                                  return 'Please enter an email address';
                                }
                                return userProvider.emailError;
                              }),
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
      ),
    );
  }
}
