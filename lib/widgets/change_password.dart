// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nfc_app/constants/appColors.dart';
import 'package:nfc_app/provider/user_info_form_state_provider.dart';
import 'package:nfc_app/responsive/device_dimensions.dart';
import 'package:nfc_app/services/auth_service/auth_service.dart';
import 'package:nfc_app/widgets/custom_loader_widget.dart';
import 'package:nfc_app/widgets/custom_snackbar_widget.dart';
import 'package:provider/provider.dart';
import '../utils/password_strength_helper.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final AuthService _authService = AuthService();

  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmNewPasswordController =
      TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool isOldPasswordObscure = true;
  bool isNewPasswordObscure = true;
  bool isConfirmNewPasswordObscure = true;

  Map<String, bool> passwordCriteria = {
    'length': false,
    'uppercase': false,
    'lowercase': false,
    'numbers': false,
    'specialChars': false,
  };
  String passwordStrength = '';
  String unmetCriterionMessage = "";

  @override
  void initState() {
    super.initState();
    newPasswordController.addListener(checkPasswordStrength);
  }

  void checkPasswordStrength() {
    setState(() {
      passwordCriteria =
          evaluatePasswordCriteria(newPasswordController.text.trim());
      passwordStrength = evaluatePasswordStrength(passwordCriteria);
      unmetCriterionMessage = getFirstUnmetCriterion(passwordCriteria);
    });
  }

  @override
  void dispose() {
    newPasswordController.removeListener(checkPasswordStrength);
    newPasswordController.dispose();
    oldPasswordController.dispose();
    confirmNewPasswordController.dispose();
    super.dispose();
  }

  Future<void> updatePassword() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      User? user = auth.currentUser;

      String email =
          Provider.of<UserInfoFormStateProvider>(context, listen: false).email;

      if (user != null) {
        try {
          AuthCredential credential = EmailAuthProvider.credential(
            email: email, // User's email
            password: oldPasswordController.text,
          );

          await user.reauthenticateWithCredential(credential);

          await user.updatePassword(newPasswordController.text);

          if (context.mounted) {
            CustomSnackbar()
                .snakBarMessage(context, "Password updated successfully");

            await _authService.signOut(context);
          }
        } on FirebaseAuthException catch (e) {
          if (context.mounted) {
            switch (e.code) {
              case 'wrong-password':
                CustomSnackbar().snakBarError(
                    context, "The old password you entered is incorrect.");
                break;
              case 'invalid-credential':
                CustomSnackbar().snakBarError(context,
                    "Invalid credential. Please check your email and password.");
                break;
              case 'too-many-requests':
                CustomSnackbar().snakBarError(
                    context, "Too many requests. Please try again later.");
                break;
              default:
                CustomSnackbar().snakBarError(
                    context, "An error occurred. Please try again.");
            }
          }
        } finally {
          setState(() {
            isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      backgroundColor: Colors.white,
      onClosing: () {},
      builder: (BuildContext context) {
        return Stack(
          children: [
            SizedBox(
              width: DeviceDimensions.screenWidth(context),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildTopBar(context),
                    _buildHeader(context),
                    _buildPasswordForm(context),
                    _buildUpdateButton(context),
                    _buildResetText(context),
                  ],
                ),
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

  // Top drag indicator
  Widget _buildTopBar(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: DeviceDimensions.screenHeight(context) * 0.015),
        Container(
          width: DeviceDimensions.screenWidth(context) * 0.16,
          height: DeviceDimensions.screenHeight(context) * 0.007,
          decoration: BoxDecoration(
              color: Colors.grey, borderRadius: BorderRadius.circular(12)),
        ),
        SizedBox(height: DeviceDimensions.screenHeight(context) * 0.040),
      ],
    );
  }

  // Header text with lock icon
  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset("assets/icons/lock2.svg"),
        SizedBox(width: DeviceDimensions.screenWidth(context) * 0.01),
        Text(
          "Change Password",
          style: TextStyle(
            fontSize: DeviceDimensions.responsiveSize(context) * 0.050,
            fontFamily: 'Barlow-Bold',
            fontWeight: FontWeight.w600,
            color: AppColors.textColorBlue,
          ),
        ),
      ],
    );
  }

  // Password form fields
  Widget _buildPasswordForm(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          SizedBox(height: DeviceDimensions.screenHeight(context) * 0.040),
          _buildPasswordField(
            context,
            "Enter old password",
            "Please enter the old password",
            oldPasswordController,
            isOldPasswordObscure,
            () {
              setState(() {
                isOldPasswordObscure = !isOldPasswordObscure;
              });
            },
          ),
          SizedBox(height: DeviceDimensions.screenHeight(context) * 0.020),
          _buildPasswordField(
            context,
            "Enter new password",
            "Please enter the new password",
            newPasswordController,
            isNewPasswordObscure,
            () {
              setState(() {
                isNewPasswordObscure = !isNewPasswordObscure;
              });
            },
            onChanged: (value) {
              checkPasswordStrength();
            },
          ),
          SizedBox(height: DeviceDimensions.screenHeight(context) * 0.020),
          _buildPasswordField(
              context,
              "Confirm new password",
              "Please confirm the new password",
              confirmNewPasswordController,
              isConfirmNewPasswordObscure, () {
            setState(() {
              isConfirmNewPasswordObscure = !isConfirmNewPasswordObscure;
            });
          }),
          SizedBox(height: DeviceDimensions.screenHeight(context) * 0.050),
        ],
      ),
    );
  }

  // Password TextFormField widget
  Widget _buildPasswordField(
    BuildContext context,
    String hintText,
    String infoText,
    TextEditingController controller,
    bool isObscure,
    VoidCallback toggleVisibility, {
    ValueChanged<String>? onChanged,
  }) {
    return TextFormField(
      style: TextStyle(height: DeviceDimensions.screenHeight(context) * 0.0020),
      controller: controller,
      obscureText: isObscure,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
            color: Color(0xFFA9A9A9),
            fontFamily: 'Barlow-Regular',
            fontWeight: FontWeight.w500),
        prefixIcon: Padding(
          padding: const EdgeInsets.all(13.0),
          child: SvgPicture.asset("assets/icons/password.svg"),
        ),
        errorStyle: const TextStyle(
          color: AppColors.errorColor,
          fontSize: 14.0,
          fontWeight: FontWeight.bold,
        ),
        suffixIcon: IconButton(
          icon: Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: Icon(
              isObscure ? Icons.visibility_off : Icons.visibility,
              color: const Color(0xFFA9A9A9),
            ),
          ),
          onPressed: toggleVisibility,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 11, horizontal: 10),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Color(0xFFA9A9A9)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Color(0xFFA9A9A9)),
        ),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                const BorderSide(color: AppColors.errorFieldBorderColor)),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                const BorderSide(color: AppColors.errorFieldBorderColor)),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return infoText;
        }
        if (controller == newPasswordController &&
            unmetCriterionMessage.isNotEmpty) {
          return unmetCriterionMessage;
        }
        if (controller == confirmNewPasswordController &&
            value != newPasswordController.text) {
          return "Passwords do not match";
        }
        return null;
      },
    );
  }

  // Update password button
  Widget _buildUpdateButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        await updatePassword();
      },
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(
          horizontal: DeviceDimensions.screenWidth(context) * 0.24,
          vertical: 12,
        ),
        backgroundColor: AppColors.appBlueColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
      ),
      child: Text(
        "Update Password",
        style: TextStyle(
          fontSize: DeviceDimensions.responsiveSize(context) * 0.045,
          fontFamily: 'Barlow-Regular',
          fontWeight: FontWeight.w600,
          color: Colors.white,
          letterSpacing: 1,
        ),
      ),
    );
  }

  // Reset password text
  Widget _buildResetText(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: DeviceDimensions.screenHeight(context) * 0.030),
        Text(
          "If you can’t remember your current password,",
          style: TextStyle(
            fontSize: DeviceDimensions.responsiveSize(context) * 0.033,
            fontFamily: 'Barlow-Regular',
            fontWeight: FontWeight.w500,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "you can reset it by ",
              style: TextStyle(
                fontSize: DeviceDimensions.responsiveSize(context) * 0.033,
                fontFamily: 'Barlow-Regular',
                fontWeight: FontWeight.w500,
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/forget-password');
              },
              child: Text(
                "clicking here.",
                style: TextStyle(
                  fontSize: DeviceDimensions.responsiveSize(context) * 0.033,
                  fontFamily: 'Barlow-Regular',
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.underline,
                  color: AppColors.textColorBlue,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: DeviceDimensions.screenHeight(context) * 0.040),
      ],
    );
  }
}
