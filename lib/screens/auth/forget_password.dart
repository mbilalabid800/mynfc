// ignore_for_file: file_names, use_build_context_synchronously, deprecated_member_use, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nfc_app/constants/appColors.dart';
import 'package:nfc_app/responsive/device_dimensions.dart';
import 'package:nfc_app/services/api_service/app_api.dart';
import 'package:nfc_app/widgets/custom_snackbar_widget.dart';

import '../../widgets/custom_loader_widget.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final int _currentDot = 0;
  bool isLoading = false;

  Future<void> _resetPassword() async {
    setState(() {
      isLoading = true;
    });
    if (_formKey.currentState!.validate()) {
      String email = emailController.text.trim();

      try {
        QuerySnapshot<Map<String, dynamic>> userDocs =
            await FirebaseFirestore.instance.collection("users").get();

        String? uid;

        for (var userDoc in userDocs.docs) {
          DocumentSnapshot<Map<String, dynamic>> detailsSnapshot = await userDoc
              .reference
              .collection("userProfile")
              .doc("details")
              .get();

          if (detailsSnapshot.exists &&
              detailsSnapshot.data()?['email'] == email) {
            uid = detailsSnapshot.data()?['uid'];
            print("uid is $uid");
            break;
          }
        }

        if (uid != null) {
          Dio dio = Dio();
          Response response = await dio.post(
            ApiLink.sendOtp,
            data: {"uid": uid},
            options: Options(
              headers: {'Content-Type': 'application/json'},
            ),
          );

          if (response.statusCode == 200 &&
              response.data['message'] == 'OTP sent') {
            if (mounted) {
              CustomSnackbar()
                  .snakBarMessage(context, "Check your email for the OTP.");
              Navigator.pushReplacementNamed(
                  context, "/email-verify-forgot-password",
                  arguments: {"uid": uid});
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Failed to send OTP. Try again later.')),
              );
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Failed to send OTP.')),
            );
          }
        } else {
          CustomSnackbar().snakBarError(context, "Email does not exist");
        }
      } catch (e) {
        print("Error: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Error occurred while processing your request.')),
        );
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Stack(
        children: [
          Container(
            height: DeviceDimensions.screenHeight(context),
            width: DeviceDimensions.screenWidth(context),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  SizedBox(
                      height: DeviceDimensions.screenHeight(context) * 0.095),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      3,
                      (index) {
                        return AnimatedContainer(
                          margin: const EdgeInsets.symmetric(horizontal: 2.0),
                          duration: const Duration(milliseconds: 500),
                          width: 20,
                          height: 7.0,
                          decoration: BoxDecoration(
                            color: _currentDot == index
                                ? AppColors.appBlueColor
                                : Colors.grey,
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                      height: DeviceDimensions.screenHeight(context) * 0.060),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Forgot password",
                        style: TextStyle(
                            fontSize: DeviceDimensions.responsiveSize(context) *
                                0.068,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Barlow-Bold'),
                      ),
                      SizedBox(
                          height:
                              DeviceDimensions.screenHeight(context) * 0.015),
                      Text(
                        "In order to reset password ,please provide us your email. We will send you an verification code momentarily.",
                        style: TextStyle(
                            fontSize: DeviceDimensions.responsiveSize(context) *
                                0.033,
                            fontFamily: 'Barlow-Regular',
                            color: AppColors.appBlueColor),
                      ),
                      SizedBox(
                          height:
                              DeviceDimensions.screenHeight(context) * 0.050),
                      Form(
                        key: _formKey,
                        child: TextFormField(
                          controller: emailController,
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
                    ],
                  ),
                  SizedBox(
                      height: DeviceDimensions.screenHeight(context) * 0.065),
                  SizedBox(
                    width: DeviceDimensions.screenWidth(context) * 0.90,
                    height: DeviceDimensions.responsiveSize(context) * 0.1252,
                    child: ElevatedButton(
                      onPressed: () => _resetPassword(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.appBlueColor,
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
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isLoading)
            Container(
              color: Colors.white54,
              child: Center(
                child: DualRingLoader(),
              ),
            ),
        ],
      )),
    );
  }
}
