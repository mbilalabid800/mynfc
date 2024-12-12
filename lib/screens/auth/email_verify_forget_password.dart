// ignore_for_file: file_names, deprecated_member_use, use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nfc_app/constants/appColors.dart';
import 'package:nfc_app/responsive/device_dimensions.dart';
import 'package:nfc_app/services/api_service/app_api.dart';
import 'package:nfc_app/widgets/custom_snackbar_widget.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../widgets/custom_loader_widget.dart';

class EmailVerifyForgetPassword extends StatefulWidget {
  const EmailVerifyForgetPassword({super.key});

  @override
  State<EmailVerifyForgetPassword> createState() =>
      _EmailVerifyForgetPasswordState();
}

class _EmailVerifyForgetPasswordState extends State<EmailVerifyForgetPassword> {
  final int _currentDot = 1;
  final otpController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String uid;
  bool isOTPComplete = false;
  bool isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final Map<String, dynamic> arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    uid = arguments['uid'];
  }

  Future<void> _verifyOtp() async {
    setState(() {
      isLoading = true;
    });
    if (_formKey.currentState!.validate()) {
      try {
        Dio dio = Dio();
        int otp = int.parse(otpController.text);
        Response response = await dio.post(
          ApiLink.verifyOtp,
          data: {
            'uid': uid,
            'otp': otp,
          },
          options: Options(
            headers: {'Content-Type': 'application/json'},
          ),
        );

        if (response.statusCode == 200 &&
            response.data['message'] == 'OTP verified') {
          if (mounted) {
            Navigator.pushReplacementNamed(context, "/set-password");
          }
        } else {
          CustomSnackbar().snakBarError(context, "Invalid OTP");
        }
      } catch (e) {
        if (e is DioError) {
          if (e.response != null && e.response?.statusCode == 400) {
            CustomSnackbar().snakBarError(context, "Invalid OTP");
          } else {
            CustomSnackbar().snakBarError(
                context, "Error occurred while verifying the OTP.");
          }
        }
      } finally {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
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
            SingleChildScrollView(
              child: Container(
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
                          height:
                              DeviceDimensions.screenHeight(context) * 0.095),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          3,
                          (index) {
                            return AnimatedContainer(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 2.0),
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
                          height:
                              DeviceDimensions.screenHeight(context) * 0.060),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Verify your email",
                            style: TextStyle(
                                fontSize:
                                    DeviceDimensions.responsiveSize(context) *
                                        0.068,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Barlow-Bold'),
                          ),
                          SizedBox(
                              height: DeviceDimensions.screenHeight(context) *
                                  0.015),
                          Text(
                            "A verification code has been sent to your email address:\n[provider's email address].\nPlease enter the code below to verify your email.",
                            style: TextStyle(
                              fontSize:
                                  DeviceDimensions.responsiveSize(context) *
                                      0.034,
                              fontFamily: 'Barlow-Regular',
                              color: AppColors.appBlueColor,
                            ),
                          ),
                          SizedBox(
                              height: DeviceDimensions.screenHeight(context) *
                                  0.060),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Form(
                              key: _formKey,
                              child: PinCodeTextField(
                                controller: otpController,
                                appContext: context,
                                length: 6,
                                onChanged: (value) {
                                  setState(() {
                                    isOTPComplete = value.length == 6;
                                  });
                                },
                                keyboardType: TextInputType.number,
                                pinTheme: PinTheme(
                                  shape: PinCodeFieldShape.box,
                                  borderRadius: BorderRadius.circular(10),
                                  fieldHeight: 50,
                                  fieldWidth: 45,
                                  activeColor: AppColors.appBlueColor,
                                  selectedColor: AppColors.appBlueColor,
                                  inactiveColor: AppColors.appBlueColor,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                          height:
                              DeviceDimensions.screenHeight(context) * 0.020),
                      const Text(
                        "Didn't receive the code?",
                        style: TextStyle(
                            color: Color(0xFF777777),
                            fontFamily: 'Barlow-Regular'),
                      ),
                      SizedBox(
                          height:
                              DeviceDimensions.screenHeight(context) * 0.065),
                      SizedBox(
                        width: DeviceDimensions.screenWidth(context) * 0.90,
                        height: 45,
                        child: ElevatedButton(
                          onPressed: isOTPComplete ? () => _verifyOtp() : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.appBlueColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                          child: Text(
                            'Verify',
                            style: TextStyle(
                              fontSize:
                                  DeviceDimensions.responsiveSize(context) *
                                      0.0445,
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
            ),
            if (isLoading)
              Container(
                color: Colors.white54,
                child: const Center(
                  child: BigThreeBounceLoader(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
