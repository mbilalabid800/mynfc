// ignore_for_file: file_names, use_build_context_synchronously, avoid_print, deprecated_member_use

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nfc_app/constants/appColors.dart';
import 'package:nfc_app/provider/authenticate_provider.dart';
import 'package:nfc_app/provider/user_info_form_state_provider.dart';
import 'package:nfc_app/responsive/device_dimensions.dart';
import 'package:nfc_app/services/auth_service/auth_service.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nfc_app/services/shared_preferences_service/shared_preferences_services.dart';
import 'package:nfc_app/utils/password_strength_helper.dart';
import 'package:nfc_app/widgets/custom_loader_widget.dart';
import 'package:nfc_app/widgets/custom_snackbar_widget.dart';
import 'package:provider/provider.dart';

class RegisterData extends StatefulWidget {
  const RegisterData({super.key});

  @override
  State<RegisterData> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterData> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  final AuthService _authService = AuthService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool _isObscurePassword = true;
  bool _isObscureConfirmPassword = true;
  String _passwordStrength = '';
  String _unmetCriterionMessage = '';
  // String password = '';

  @override
  void initState() {
    super.initState();
    passwordController.addListener(_checkPasswordStrength);
  }

  void _checkPasswordStrength() {
    setState(() {
      _passwordCriteria =
          evaluatePasswordCriteria(passwordController.text.trim());
      _passwordStrength = evaluatePasswordStrength(_passwordCriteria);
      _unmetCriterionMessage = getFirstUnmetCriterion(_passwordCriteria);
    });
  }

  @override
  void dispose() {
    passwordController.removeListener(_checkPasswordStrength);
    passwordController.dispose();
    super.dispose();
  }

  Future<void> registerLogic() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      final email = emailController.text.trim();
      final password = passwordController.text.trim();
      //final confirmPassword = confirmPasswordController.text.trim();

      try {
        final user = await _authService.registerWithEmailPassword(
          email,
          password,
        );

        if (user != null) {
          Provider.of<UserInfoFormStateProvider>(context, listen: false)
              .setEmail(email);

          SharedPreferencesServices prefsService = SharedPreferencesServices();
          await prefsService.saveEmail(email);

          Navigator.pushReplacementNamed(context, '/user-info');
        } else {
          CustomSnackbar().snakBarError(
              context, "Registration failed, Email already exists");
        }
      } catch (e) {
        CustomSnackbar().snakBarError(context, "Registration failed: $e");
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Map<String, bool> _passwordCriteria = {
    'length': false,
    'uppercase': false,
    'lowercase': false,
    'numbers': false,
    'specialChars': false,
  };

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
                        key: _formKey,
                        child: Column(
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25),
                              child: TextFormField(
                                style: TextStyle(
                                    height:
                                        DeviceDimensions.screenHeight(context) *
                                            0.0026),
                                controller: emailController,
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
                                        "assets/icons/email.svg"),
                                  ),
                                  errorStyle: const TextStyle(
                                    color: AppColors
                                        .errorColor, // Color of the error text
                                    fontSize: 14.0, // Size of the error text
                                    fontWeight: FontWeight
                                        .bold, // Weight of the error text
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
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: const BorderSide(
                                        color: AppColors.appBlueColor),
                                  ),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter your email';
                                  }
                                  final emailPattern = RegExp(
                                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25),
                              child: TextFormField(
                                style: TextStyle(
                                    height:
                                        DeviceDimensions.screenHeight(context) *
                                            0.0026),
                                controller: passwordController,
                                obscureText: _isObscurePassword,
                                onChanged: (password) {
                                  _checkPasswordStrength();
                                },
                                decoration: InputDecoration(
                                  hintText: "Password",
                                  hintStyle: const TextStyle(
                                    color: Color(0xFFA9A9A9),
                                    fontFamily: 'Barlow-Regular',
                                    fontWeight: FontWeight.w500,
                                  ),

                                  //helperText: 'Password Strength: $_passwordStrength',
                                  prefixIcon: Padding(
                                    padding: const EdgeInsets.all(13.0),
                                    child: SvgPicture.asset(
                                        "assets/icons/password.svg"),
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Padding(
                                      padding:
                                          const EdgeInsets.only(right: 10.0),
                                      child: Icon(
                                        _isObscurePassword
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                        color: const Color(0xFFA9A9A9),
                                      ),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _isObscurePassword =
                                            !_isObscurePassword;
                                      });
                                    },
                                  ),
                                  errorStyle: const TextStyle(
                                    color: AppColors
                                        .errorColor, // Color of the error text
                                    fontSize: 14.0, // Size of the error text
                                    fontWeight: FontWeight
                                        .bold, // Weight of the error text
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 11, horizontal: 10),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                        color: AppColors.textFieldBorder),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                        color: AppColors.appBlueColor),
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
                                  if (value.length < 8) {
                                    return 'Password must be at least 8 characters long';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            if (_unmetCriterionMessage.isNotEmpty)
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(top: 8.0, left: 30),
                                  child: Text(
                                    _unmetCriterionMessage,
                                    style: const TextStyle(color: Colors.red),
                                  ),
                                ),
                              ),
                            SizedBox(
                                height: DeviceDimensions.screenHeight(context) *
                                    0.020),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25),
                              child: TextFormField(
                                style: TextStyle(
                                    height:
                                        DeviceDimensions.screenHeight(context) *
                                            0.0026),
                                controller: confirmPasswordController,
                                obscureText: _isObscureConfirmPassword,
                                onChanged: (password) {
                                  // Update _passwordStrength based on your logic
                                  setState(() {
                                    _checkPasswordStrength();
                                  });
                                },
                                decoration: InputDecoration(
                                  hintText: "Confirm Password",
                                  hintStyle: const TextStyle(
                                    color: Color(0xFFA9A9A9),
                                    fontFamily: 'Barlow-Regular',
                                    fontWeight: FontWeight.w500,
                                  ),
                                  prefixIcon: Padding(
                                    padding: const EdgeInsets.all(13.0),
                                    child: SvgPicture.asset(
                                        "assets/icons/password.svg"),
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Padding(
                                      padding:
                                          const EdgeInsets.only(right: 10.0),
                                      child: Icon(
                                        _isObscureConfirmPassword
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                        color: const Color(0xFFA9A9A9),
                                      ),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _isObscureConfirmPassword =
                                            !_isObscureConfirmPassword;
                                      });
                                    },
                                  ),
                                  errorStyle: const TextStyle(
                                    color: AppColors
                                        .errorColor, // Color of the error text
                                    fontSize: 14.0, // Size of the error text
                                    fontWeight: FontWeight
                                        .bold, // Weight of the error text
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 11, horizontal: 10),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                        color: AppColors.textFieldBorder),
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
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                        color: AppColors.appBlueColor),
                                  ),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please confirm your password';
                                  }
                                  if (value.length < 8) {
                                    return 'Password must be at least 8 characters long';
                                  }
                                  if (value != passwordController.text.trim()) {
                                    return 'Passwords do not match';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(
                                height: DeviceDimensions.screenHeight(context) *
                                    0.020),
                          ],
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
                            if (_passwordStrength == 'Strong') {
                              registerLogic();
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Please use a stronger password')));
                            }
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
        if (isLoading)
          Container(
            color: Colors.white54,
            child: Center(child: DualRingLoader()),
          ),
      ],
    );
  }
}
