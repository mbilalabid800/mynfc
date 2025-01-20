// ignore_for_file: use_build_context_synchronously, unnecessary_null_comparison, deprecated_member_use

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nfc_app/constants/appColors.dart';
import 'package:nfc_app/provider/authenticate_provider.dart';
import 'package:nfc_app/provider/forget_password_email_provider.dart';
import 'package:nfc_app/responsive/device_dimensions.dart';
import 'package:nfc_app/services/auth_service/auth_service.dart';
import 'package:nfc_app/shared/common_widgets/custom_loader_widget.dart';
import 'package:nfc_app/shared/common_widgets/my_button.dart';
import 'package:provider/provider.dart';

class SigninData extends StatefulWidget {
  const SigninData({super.key});

  @override
  State<SigninData> createState() => _SigninDataState();
}

class _SigninDataState extends State<SigninData> {
  @override
  void initState() {
    super.initState();
    Provider.of<AuthenticateProvider>(context, listen: false)
        .initializeData(context);
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthenticateProvider>(context);
    return Stack(
      children: [
        LayoutBuilder(builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    SizedBox(
                        height: DeviceDimensions.screenHeight(context) * 0.035),
                    Form(
                      key: authProvider.signinFormKey,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            child: TextFormField(
                              style: TextStyle(
                                  height:
                                      DeviceDimensions.screenHeight(context) *
                                          0.0026),
                              controller: authProvider.emailController,
                              decoration: InputDecoration(
                                hintText: "Email",
                                hintStyle: const TextStyle(
                                  color: Color(0xFFA9A9A9),
                                  fontFamily: 'Barlow-Regular',
                                  fontWeight: FontWeight.w500,
                                ),
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.all(13.0),
                                  child: SvgPicture.asset(
                                    "assets/icons/email.svg",
                                  ),
                                ),
                                errorStyle: const TextStyle(
                                  color: AppColors
                                      .errorColor, // Color of the error text
                                  fontSize: 14.0, // Size of the error text
                                  // fontWeight: FontWeight
                                  //     .bold, // Weight of the error text
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 11, horizontal: 10),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: const BorderSide(
                                      color: AppColors.textFieldBorder),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: const BorderSide(
                                    color: AppColors.appBlueColor,
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                        color:
                                            AppColors.errorFieldBorderColor)),
                                focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                        color:
                                            AppColors.errorFieldBorderColor)),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter your email';
                                }
                                final emailPattern =
                                    RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,5}$');
                                if (!emailPattern.hasMatch(value)) {
                                  return 'Please enter a valid email address';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(
                              height: DeviceDimensions.screenHeight(context) *
                                  0.020),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            child: TextFormField(
                              style: TextStyle(
                                height: DeviceDimensions.screenHeight(context) *
                                    0.0026,
                              ),
                              controller: authProvider.passwordController,
                              obscureText: authProvider.isObscure,
                              decoration: InputDecoration(
                                hintText: "Password",
                                hintStyle: const TextStyle(
                                    color: Color(0xFFA9A9A9),
                                    fontFamily: 'Barlow-Regular',
                                    fontWeight: FontWeight.w500),
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.all(13.0),
                                  child: SvgPicture.asset(
                                      "assets/icons/password.svg"),
                                ),
                                errorStyle: const TextStyle(
                                  color: AppColors
                                      .errorColor, // Color of the error text
                                  fontSize: 14.0, // Size of the error text
                                  // fontWeight: FontWeight
                                  //     .bold, // Weight of the error text
                                ),
                                suffixIcon: IconButton(
                                  icon: Padding(
                                    padding: const EdgeInsets.only(right: 10.0),
                                    child: Icon(
                                      authProvider.isObscure
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: const Color(0xFFA9A9A9),
                                    ),
                                  ),
                                  onPressed: () {
                                    authProvider.setIsObscure =
                                        !authProvider.isObscure;
                                  },
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 11, horizontal: 10),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: const BorderSide(
                                      color: AppColors.textFieldBorder),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: const BorderSide(
                                    color: AppColors.appBlueColor,
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                        color:
                                            AppColors.errorFieldBorderColor)),
                                focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                        color:
                                            AppColors.errorFieldBorderColor)),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter Password';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    //remove this sizebox if firstone is good
                    SizedBox(
                        height: DeviceDimensions.screenHeight(context) * 0.013),
                    Padding(
                      padding: const EdgeInsets.only(left: 18, right: 30),
                      child: Row(
                        children: [
                          Checkbox(
                              value: authProvider.isRememberMe,
                              activeColor: AppColors.appBlueColor,
                              onChanged: (value) {
                                authProvider.setRememberMe = value!;
                              }),
                          Text(
                            "Remember me",
                            style: TextStyle(
                                fontSize:
                                    DeviceDimensions.responsiveSize(context) *
                                        0.0350,
                                color: const Color(0xFFA9A9A9),
                                fontFamily: 'Barlow-Regular'),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () {
                              Provider.of<ForgetPasswordEmailProvider>(context,
                                      listen: false)
                                  .setEmail(
                                      authProvider.emailController.text.trim());
                              // Navigator.pushNamed(context, "/forget-password");
                              Navigator.pushNamed(context, "/forget-password");
                            },
                            child: Stack(
                              alignment: Alignment.centerLeft,
                              children: [
                                Text(
                                  "Forget Password?",
                                  style: TextStyle(
                                      fontSize: DeviceDimensions.responsiveSize(
                                              context) *
                                          0.035,
                                      color: AppColors.textColorBlue,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Barlow-Regular'),
                                ),
                                Positioned(
                                  bottom: -3,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    height: 4.4,
                                    color: const Color(0xFF202020),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                        height: DeviceDimensions.screenHeight(context) * 0.023),

                    MyButton(
                      text: 'Login',
                      onPressed: () {
                        authProvider.signInLogic(context);
                      },
                      width: DeviceDimensions.screenWidth(context) * 0.85,
                    ),
                    SizedBox(
                        height: DeviceDimensions.screenHeight(context) * 0.050),

                    Text(
                      "---------------- Or login with ----------------",
                      style: TextStyle(
                          fontSize:
                              DeviceDimensions.responsiveSize(context) * 0.040,
                          color: const Color(0xFFA9A9A9),
                          fontFamily: 'Barlow-Regular',
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                        height: DeviceDimensions.screenHeight(context) * 0.050),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            await authProvider.signInWithGoogleAccount(context);
                          },
                          child: Container(
                            width: DeviceDimensions.screenWidth(context) * .44,
                            height:
                                DeviceDimensions.screenHeight(context) * 0.060,
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
                                      fontSize: DeviceDimensions.responsiveSize(
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
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: () async {
                            User? user = await AuthService().signInWithApple();
                            if (user != null) {
                              Navigator.pushNamed(context, '/home');
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
                            width: DeviceDimensions.screenWidth(context) * .44,
                            height:
                                DeviceDimensions.screenHeight(context) * 0.060,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              // border:
                              //     Border.all(color: const Color(0xFFA9A9A9)),
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
                                    width:
                                        DeviceDimensions.screenWidth(context) *
                                            0.010),
                                Text(
                                  "Apple",
                                  style: TextStyle(
                                      fontSize: DeviceDimensions.responsiveSize(
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
                        height: DeviceDimensions.screenHeight(context) * 0.03),
                  ],
                ),
              ),
            ),
          );
        }),
        if (authProvider.isLoading)
          Container(
            color: Colors.white54,
            child: const Center(
              child: DualRingLoader(),
            ),
          ),
      ],
    );
  }
}
