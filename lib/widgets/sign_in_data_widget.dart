// ignore_for_file: use_build_context_synchronously, unnecessary_null_comparison

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nfc_app/constants/appColors.dart';
import 'package:nfc_app/provider/biometric_handler_provider.dart';
import 'package:nfc_app/provider/forget_password_email_provider.dart';
import 'package:nfc_app/provider/user_info_form_state_provider.dart';
import 'package:nfc_app/responsive/device_dimensions.dart';
import 'package:nfc_app/services/auth_service/auth_service.dart';
import 'package:nfc_app/widgets/custom_loader_widget.dart';
import 'package:nfc_app/widgets/custom_snackbar_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SigninData extends StatefulWidget {
  const SigninData({super.key});

  @override
  State<SigninData> createState() => _SigninDataState();
}

class _SigninDataState extends State<SigninData> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();
  bool isLoading = false;
  bool _isObscure = true;
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await _loadUserData();
    await _triggerFingerprintAuthenticationIfEnabled();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _rememberMe = prefs.getBool('rememberMe') ?? false;
      if (_rememberMe) {
        emailController.text = prefs.getString('email') ?? '';
      }
    });
  }

  Future<void> _triggerFingerprintAuthenticationIfEnabled() async {
    final biometricProvider = context.read<BiometricHandlerProvider>();

    setState(() {
      isLoading = true;
    });

    try {
      // Ensure preferences are loaded
      await biometricProvider.loadFingerprintPreference();

      // Trigger fingerprint authentication if enabled
      if (biometricProvider.isFingerprintEnabled) {
        bool isAuthenticated =
            await biometricProvider.authenticateWithFingerprint();

        if (isAuthenticated) {
          await _signInUsingFingerprint();
        } else {
          CustomSnackbar().snakBarError(
            context,
            'Fingerprint authentication failed. Please try again.',
          );
        }
      }
    } catch (e) {
      debugPrint('Error during fingerprint authentication: $e');
      CustomSnackbar().snakBarError(
        context,
        'An error occurred during fingerprint authentication.',
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _signInUsingFingerprint() async {
    setState(() {
      isLoading = true;
    });

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? email = prefs.getString('email');
      String? password = prefs.getString('password');

      if (email != null && password != null) {
        final user =
            await _authService.signInWithEmailPassword(email, password);

        if (user != null) {
          _navigateBasedOnUserStatus(user);
        } else {
          CustomSnackbar().snakBarError(
            context,
            'Fingerprint login failed: Invalid stored credentials.',
          );
        }
      } else {
        CustomSnackbar().snakBarError(
          context,
          'No saved credentials found. Please log in manually.',
        );
      }
    } catch (e) {
      debugPrint('Error during fingerprint login: $e');
      CustomSnackbar().snakBarError(
        context,
        'An error occurred during fingerprint login.',
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Handle manual login
  Future<void> signInLogic() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      try {
        final email = emailController.text.trim();
        final password = passwordController.text.trim();

        final user =
            await _authService.signInWithEmailPassword(email, password);

        if (user != null) {
          _saveUserData();
          _navigateBasedOnUserStatus(user);
        } else {
          CustomSnackbar().snakBarError(
            context,
            'Login failed: Invalid email or password.',
          );
        }
      } catch (e) {
        debugPrint('Error during login: $e');
        CustomSnackbar().snakBarError(
          context,
          'Error during login. Please try again later.',
        );
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void _navigateBasedOnUserStatus(User user) async {
    setState(() {
      isLoading = true;
    });
    try {
      // Reload user data to ensure the latest status
      await user.reload();

      // Fetch user document from Firestore
      final userDoc = await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .collection('userProfile')
          .doc('details')
          .get();

      if (user.emailVerified) {
        if (userDoc.exists) {
          // User email is verified and profile exists, navigate to the main screen
          Navigator.of(context).pushNamedAndRemoveUntil(
            '/mainNav-screen', // Main screen route
            (Route<dynamic> route) => false, // Remove all previous routes
          );
        } else {
          // User email is verified but profile does not exist, navigate to user info screen
          Provider.of<UserInfoFormStateProvider>(context, listen: false)
              .setEmail(user.email ?? '');
          Navigator.of(context).pushNamedAndRemoveUntil(
            '/user-info', // User info screen route
            (Route<dynamic> route) => false, // Remove all previous routes
          );
        }
      } else {
        if (!userDoc.exists) {
          // Email not verified and profile does not exist, navigate to user info screen
          Provider.of<UserInfoFormStateProvider>(context, listen: false)
              .setEmail(user.email ?? '');
          Navigator.of(context).pushNamedAndRemoveUntil(
            '/user-info', // User info screen route
            (Route<dynamic> route) => false, // Remove all previous routes
          );
        } else {
          // Email not verified but profile exists, navigate to email verification screen
          Provider.of<UserInfoFormStateProvider>(context, listen: false)
              .setEmail(user.email ?? '');
          Navigator.of(context).pushNamedAndRemoveUntil(
            '/email-verify', // Email verification screen route
            (Route<dynamic> route) => false, // Remove all previous routes
          );
        }
      }
    } catch (e) {
      // Handle errors gracefully and notify the user
      debugPrint('Error in navigating based on user status: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('An error occurred while processing your login.'),
        ),
      );
    } finally {
      // Delay turning off the loader to ensure navigation completes
      Future.delayed(Duration(milliseconds: 300), () {
        setState(() {
          isLoading = false;
        });
      });
    }
  }

  Future<void> _saveUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('rememberMe', _rememberMe);
    if (_rememberMe) {
      prefs.setString('email', emailController.text);
      prefs.setString('password', passwordController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                      key: _formKey,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25),
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
                                    "assets/icons/email.svg",
                                  ),
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
                              controller: passwordController,
                              obscureText: _isObscure,
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
                                  fontWeight: FontWeight
                                      .bold, // Weight of the error text
                                ),
                                suffixIcon: IconButton(
                                  icon: Padding(
                                    padding: const EdgeInsets.only(right: 10.0),
                                    child: Icon(
                                      _isObscure
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: const Color(0xFFA9A9A9),
                                    ),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isObscure = !_isObscure;
                                    });
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
                    //remove this sizebox if firstone is good
                    SizedBox(
                        height: DeviceDimensions.screenHeight(context) * 0.013),
                    Padding(
                      padding: const EdgeInsets.only(left: 18, right: 30),
                      child: Row(
                        children: [
                          Checkbox(
                              value: _rememberMe,
                              activeColor: AppColors.appBlueColor,
                              onChanged: (value) {
                                setState(() {
                                  _rememberMe = value!;
                                });
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
                                  .setEmail(emailController.text.trim());
                              // Navigator.pushNamed(context, "/forget-password");
                              Navigator.pushNamed(context, "/forget2");
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
                    // SizedBox(
                    //     height: DeviceDimensions.screenHeight(context) * 0.013),
                    SizedBox(
                        height: DeviceDimensions.screenHeight(context) * 0.023),
                    SizedBox(
                      width: DeviceDimensions.screenWidth(context) * 0.85,
                      height: DeviceDimensions.screenHeight(context) * 0.06,
                      child: ElevatedButton(
                        onPressed: () {
                          signInLogic();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.buttonColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        child: Text(
                          'Login',
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
                        height: DeviceDimensions.screenHeight(context) * 0.050),
                    // SizedBox(
                    //     height: DeviceDimensions.screenHeight(context) * 0.023),
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
                            setState(() {
                              isLoading = true;
                            });
                            try {
                              final result =
                                  await AuthService().signInWithGoogle();
                              if (result != null) {
                                User? user = result['user'];
                                bool isNew = result['isNew'];

                                if (isNew) {
                                  // New user, save email and navigate to the User Info page
                                  Provider.of<UserInfoFormStateProvider>(
                                          context,
                                          listen: false)
                                      .setEmail(user!.email ?? '');
                                  Navigator.pushNamed(context, '/user-info');
                                } else {
                                  // Returning user, navigate directly to the main screen
                                  Navigator.pushNamed(
                                      context, '/mainNav-screen');
                                }
                              }
                            } catch (error) {
                              CustomSnackbar().snakBarError(context,
                                  'Error signing in with Google: ${error.toString()}');
                            } finally {
                              setState(() {
                                isLoading =
                                    false; // Hide loader after navigation or error
                              });
                            }
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
        if (isLoading)
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
