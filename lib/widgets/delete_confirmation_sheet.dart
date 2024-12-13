// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nfc_app/constants/appColors.dart';
import 'package:nfc_app/provider/user_info_form_state_provider.dart';
import 'package:nfc_app/responsive/device_dimensions.dart';
import 'package:nfc_app/services/auth_service/auth_service.dart';
import 'package:nfc_app/services/firestore_service/delete_user.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nfc_app/widgets/custom_loader_widget.dart';
import 'package:nfc_app/widgets/custom_snackbar_widget.dart';
import 'package:provider/provider.dart';

class DeleteConfirmationSheet extends StatefulWidget {
  const DeleteConfirmationSheet({super.key});

  @override
  _DeleteConfirmationSheetState createState() =>
      _DeleteConfirmationSheetState();
}

class _DeleteConfirmationSheetState extends State<DeleteConfirmationSheet> {
  late String emailController;
  TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final AuthService authService = AuthService();
  bool isLoading = false;
  bool isObscure = true;

  @override
  void initState() {
    super.initState();
    emailController =
        Provider.of<UserInfoFormStateProvider>(context, listen: false).email;
  }

  @override
  void dispose() {
    passwordController.dispose();
    super.dispose();
  }

  Future<void> signInForDelete() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      final email = emailController;
      final password = passwordController.text.trim();
      try {
        // Authenticate the user
        final user = await authService.signInWithEmailPassword(email, password);
        if (user != null) {
          await DeleteUser().deleteUser(context);

          // Sign out and show success message on main screen
          await FirebaseAuth.instance.signOut();
          if (mounted) {
            CustomSnackbar().snakBarMessage(
                context, "Success, Account deleted. Best of Luck!");
            Navigator.pushReplacementNamed(context, '/login-screen');
          }
        } else {
          _showAlertDialog("Failed", "Invalid email or password.");
        }
      } catch (e) {
        if (mounted) {
          _showAlertDialog("Error", "An error occurred: $e");
        }
      } finally {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
      }
    }
  }

// Function to display an alert dialog
  void _showAlertDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text(
                "OK",
                style: TextStyle(
                    fontFamily: 'Barlow_regular',
                    color: AppColors.textColorBlue),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      onClosing: () {},
      builder: (BuildContext context) {
        return Stack(
          children: [
            SizedBox(
              width: DeviceDimensions.screenWidth(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                      height: DeviceDimensions.screenHeight(context) * 0.015),
                  Container(
                    width: DeviceDimensions.screenWidth(context) * 0.16,
                    height: DeviceDimensions.screenHeight(context) * 0.007,
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  SizedBox(
                      height: DeviceDimensions.screenHeight(context) * 0.025),
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "DELETE ACCOUNT?",
                        style: TextStyle(
                            fontSize: DeviceDimensions.responsiveSize(context) *
                                0.060,
                            fontFamily: 'Barlow-Bold',
                            color: AppColors.textColorBlue,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 25.0, top: 3, right: 25),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Enter email and password to confirm and delete your account.",
                        style: TextStyle(
                            fontSize: DeviceDimensions.responsiveSize(context) *
                                0.040,
                            fontFamily: 'Barlow-Regular',
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  SizedBox(
                      height: DeviceDimensions.screenHeight(context) * 0.035),
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 1.5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              border:
                                  Border.all(color: const Color(0xFFA9A9A9)),
                            ),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: SvgPicture.asset(
                                      "assets/icons/email.svg"), // Email icon
                                ),
                                Text(
                                  Provider.of<UserInfoFormStateProvider>(
                                          context)
                                      .email,
                                  style: TextStyle(
                                    color: const Color(0xFFA9A9A9),
                                    fontFamily: 'Barlow-Regular',
                                    fontWeight: FontWeight.w500,
                                    fontSize: DeviceDimensions.responsiveSize(
                                            context) *
                                        0.042,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                            height:
                                DeviceDimensions.screenHeight(context) * 0.020),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: TextFormField(
                            style: TextStyle(
                              height: DeviceDimensions.screenHeight(context) *
                                  0.0020,
                            ),
                            controller: passwordController,
                            obscureText: isObscure,
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
                                fontWeight:
                                    FontWeight.bold, // Weight of the error text
                              ),
                              suffixIcon: IconButton(
                                icon: Padding(
                                  padding: const EdgeInsets.only(right: 10.0),
                                  child: Icon(
                                    isObscure
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: const Color(0xFFA9A9A9),
                                  ),
                                ),
                                onPressed: () {
                                  setState(() {
                                    isObscure = !isObscure;
                                  });
                                },
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 11, horizontal: 10),
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
                              errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                      color: AppColors.errorFieldBorderColor)),
                              focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                      color: AppColors.errorFieldBorderColor)),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter Password';
                              }
                              if (value.length < 8) {
                                return 'Password must be at least 8 characters long';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                      height: DeviceDimensions.screenHeight(context) * 0.065),
                  ElevatedButton(
                    onPressed: () {
                      signInForDelete();
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal:
                            DeviceDimensions.screenWidth(context) * 0.32,
                        vertical: 11,
                      ),
                      backgroundColor: const Color(0xFFF86F6B),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: Text(
                      "Yes, Delete",
                      style: TextStyle(
                        fontSize:
                            DeviceDimensions.responsiveSize(context) * 0.045,
                        fontFamily: 'Barlow-Regular',
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(
                      height: DeviceDimensions.screenHeight(context) * 0.015),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal:
                            DeviceDimensions.screenWidth(context) * 0.36,
                        vertical: 11,
                      ),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                        side: const BorderSide(
                          color: Color(0xFFF86F6B),
                          width: 1,
                        ),
                      ),
                    ),
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                        fontSize:
                            DeviceDimensions.responsiveSize(context) * 0.045,
                        fontFamily: 'Barlow-Regular',
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFFF86F68),
                      ),
                    ),
                  ),
                  SizedBox(
                      height: DeviceDimensions.screenHeight(context) * 0.035),
                ],
              ),
            ),
            if (isLoading)
              Positioned(
                bottom: DeviceDimensions.screenHeight(context) * 0.25,
                left: 0,
                right: 0,
                child: Container(
                  color: Colors.white54,
                  child: Center(
                    child: DualRingLoader(),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
