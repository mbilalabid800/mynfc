// ignore_for_file: file_names, use_build_context_synchronously, avoid_print, deprecated_member_use

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nfc_app/constants/appColors.dart';
import 'package:nfc_app/provider/authenticate_provider.dart';
import 'package:nfc_app/provider/password_validation_provider.dart';
import 'package:nfc_app/provider/user_info_form_state_provider.dart';
import 'package:nfc_app/responsive/device_dimensions.dart';
import 'package:nfc_app/services/auth_service/auth_service.dart';
import 'package:nfc_app/shared/common_widgets/my_textfield.dart';
import 'package:nfc_app/shared/common_widgets/custom_loader_widget.dart';
import 'package:provider/provider.dart';

class RegisterData extends StatefulWidget {
  const RegisterData({super.key});

  @override
  State<RegisterData> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterData> {
  TextEditingController confirmPasswordController = TextEditingController();
  FocusNode emailFocusNode = FocusNode();

  @override
  void dispose() {
    emailFocusNode.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthenticateProvider>(context);
    return Stack(
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      SizedBox(
                          height:
                              DeviceDimensions.screenHeight(context) * 0.035),
                      Form(
                        key: authProvider.registerFormKey,
                        child: Consumer2<UserInfoFormStateProvider,
                            PasswordValidationProvider>(
                          builder: (context, userInfoFormStateProvider,
                              passwordValidationProvider, child) {
                            return Column(
                              children: [
                                MyTextfield(
                                    controller:
                                        authProvider.registerEmailController,
                                    hintText: 'Email',
                                    iconPath: 'assets/icons/email.svg',
                                    errorText:
                                        userInfoFormStateProvider.emailError,
                                    onChanged: (value) {
                                      userInfoFormStateProvider
                                          .validateEmail(value);
                                    },
                                    validator: (value) {
                                      if (value?.isEmpty ?? true) {
                                        return 'Enter a valid email address';
                                      }
                                      return userInfoFormStateProvider
                                          .emailError;
                                    }),
                                SizedBox(
                                    height:
                                        DeviceDimensions.screenHeight(context) *
                                            0.020),
                                MyTextfield(
                                  controller:
                                      authProvider.registerPasswordController,
                                  hintText: 'Password',
                                  iconPath: 'assets/icons/password.svg',
                                  isPasswordField: true,
                                  passwordVisibilityNotifier: ValueNotifier(
                                      passwordValidationProvider
                                          .isObscurePassword),
                                  errorText: passwordValidationProvider
                                      .unmetCriterionMessage,
                                  onChanged: (password) {
                                    passwordValidationProvider
                                        .checkPasswordStrength(password);
                                  },
                                  validator: (value) {
                                    if (value?.isEmpty ?? true) {
                                      return 'Password is required';
                                    }
                                    return passwordValidationProvider
                                        .unmetCriterionMessage;
                                  },
                                ),
                                SizedBox(
                                    height:
                                        DeviceDimensions.screenHeight(context) *
                                            0.020),
                                MyTextfield(
                                  controller: confirmPasswordController,
                                  hintText: 'Confirm Password',
                                  iconPath: 'assets/icons/password.svg',
                                  isPasswordField: true,
                                  passwordVisibilityNotifier: ValueNotifier(
                                    passwordValidationProvider
                                        .isObscureConfirmPassword,
                                  ),
                                  errorText: passwordValidationProvider
                                      .confirmPasswordErrorMessage,
                                  onChanged: (password) {
                                    passwordValidationProvider
                                        .checkConfirmPassword(
                                            authProvider
                                                .registerPasswordController
                                                .text,
                                            password);
                                  },
                                  validator: (value) {
                                    if (value?.isEmpty ?? true) {
                                      return 'Confirm password is required';
                                    }
                                    return passwordValidationProvider
                                        .confirmPasswordErrorMessage;
                                  },
                                ),
                                SizedBox(
                                    height:
                                        DeviceDimensions.screenHeight(context) *
                                            0.020),
                              ],
                            );
                          },
                        ),
                      ),
                      SizedBox(
                          height:
                              DeviceDimensions.screenHeight(context) * 0.020),
                      SizedBox(
                        width: DeviceDimensions.screenWidth(context) * 0.85,
                        height: DeviceDimensions.screenHeight(context) * 0.06,
                        child: ElevatedButton(
                          onPressed: () {
                            authProvider.registerWithEmailPassword(
                                context: context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.buttonColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                          child: Text(
                            'Register',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize:
                                    DeviceDimensions.responsiveSize(context) *
                                        0.045,
                                fontFamily: 'Barlow-Regular',
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      SizedBox(
                          height:
                              DeviceDimensions.screenHeight(context) * 0.035),
                      Text(
                        "-------------- Or continue with --------------",
                        style: TextStyle(
                            fontSize: DeviceDimensions.responsiveSize(context) *
                                0.040,
                            color: const Color(0xFFA9A9A9),
                            fontFamily: 'Barlow-Regular',
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                          height:
                              DeviceDimensions.screenHeight(context) * 0.035),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              await authProvider
                                  .signInWithGoogleAccount(context);
                            },
                            child: Container(
                              width:
                                  DeviceDimensions.screenWidth(context) * .44,
                              height: DeviceDimensions.screenHeight(context) *
                                  0.060,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color.fromARGB(26, 0, 0, 0)
                                        .withOpacity(0.2),
                                    spreadRadius: 0,
                                    blurRadius: 4,
                                    offset: const Offset(0, 1),
                                  ),
                                ],
                                color: Colors.white,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "assets/icons/google.png",
                                    height: 37,
                                  ),
                                  Text(
                                    "Google",
                                    style: TextStyle(
                                        fontSize:
                                            DeviceDimensions.responsiveSize(
                                                    context) *
                                                0.053,
                                        color: AppColors.textColorBlue,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Barlow-Regular'),
                                  )
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          GestureDetector(
                            onTap: () async {
                              User? user =
                                  await AuthService().signInWithApple();
                              if (user != null) {
                                Navigator.pushNamed(context, '/user-info');
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text("No Apple account is signed in"),
                                  ),
                                );
                              }
                            },
                            child: Container(
                              width:
                                  DeviceDimensions.screenWidth(context) * .44,
                              height: DeviceDimensions.screenHeight(context) *
                                  0.060,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color.fromARGB(26, 0, 0, 0)
                                        .withOpacity(0.2),
                                    spreadRadius: 0,
                                    blurRadius: 4,
                                    offset: const Offset(0, 1),
                                  ),
                                ],
                                color: Colors.white,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 9.0, top: 7),
                                    child: Image.asset("assets/icons/apple.png",
                                        height: 37),
                                  ),
                                  SizedBox(
                                      width: DeviceDimensions.screenWidth(
                                              context) *
                                          0.010),
                                  Text(
                                    "Apple",
                                    style: TextStyle(
                                        fontSize:
                                            DeviceDimensions.responsiveSize(
                                                    context) *
                                                0.053,
                                        color: AppColors.appBlueColor,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Barlow-Regular'),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                          height:
                              DeviceDimensions.screenHeight(context) * 0.03),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        if (authProvider.isLoading)
          Container(
            color: Colors.white54,
            child: Center(child: DualRingLoader()),
          ),
      ],
    );
  }
}
