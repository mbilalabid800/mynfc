// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:nfc_app/provider/user_info_form_state_provider.dart';
import 'package:nfc_app/services/auth_service/auth_service.dart';
import 'package:nfc_app/shared/common_widgets/custom_snackbar_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'biometric_handler_provider.dart';

class AuthenticateProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Private variables
  bool _isLoading = false;
  bool _isObscure = true;
  bool _rememberMe = false;

  // Getters
  bool get isLoading => _isLoading;
  bool get isObscure => _isObscure;
  bool get isRememberMe => _rememberMe;

  // Setters
  set setIsLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  set setIsObscure(bool value) {
    _isObscure = value;
    notifyListeners();
  }

  set setRememberMe(bool value) {
    _rememberMe = value;
    notifyListeners();
  }

  Future<void> initializeData(BuildContext context) async {
    await _loadUserData();
    await triggerFingerprintAuthenticationIfEnabled(context);
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setRememberMe = prefs.getBool('rememberMe') ?? false;
    if (isRememberMe) {
      emailController.text = prefs.getString('email') ?? '';
    }
  }

  Future<void> triggerFingerprintAuthenticationIfEnabled(
      BuildContext context) async {
    setIsLoading = true;

    try {
      final biometricProvider =
          Provider.of<BiometricHandlerProvider>(context, listen: false);

      await biometricProvider.loadFingerprintPreference();

      if (biometricProvider.isFingerprintEnabled) {
        bool isAuthenticated =
            await biometricProvider.authenticateWithFingerprint();

        if (isAuthenticated) {
          await _signInUsingFingerprint(context);
        } else {
          CustomSnackbar().snakBarError(
              context, 'Fingerprint authentication failed. Please try again.');
        }
      }
    } catch (e) {
      debugPrint('Error: $e');
      CustomSnackbar().snakBarError(
          context, 'An error occurred during fingerprint authentication.');
    } finally {
      setIsLoading = false;
    }
  }

  Future<void> _signInUsingFingerprint(BuildContext context) async {
    setIsLoading = true;

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? email = prefs.getString('email');
      String? password = prefs.getString('password');

      if (email != null && password != null) {
        final user =
            await _authService.signInWithEmailPassword(email, password);
        if (user != null) {
          await _navigateBasedOnUserStatus(context, user);
        } else {
          CustomSnackbar().snakBarError(
              context, 'Fingerprint login failed: Invalid stored credentials.');
        }
      } else {
        CustomSnackbar().snakBarError(
            context, 'No saved credentials found. Please log in manually.');
      }
    } catch (e) {
      debugPrint('Error during fingerprint login: $e');
      CustomSnackbar()
          .snakBarError(context, 'An error occurred during fingerprint login.');
    } finally {
      setIsLoading = false;
    }
  }

  Future<void> signInLogic(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      setIsLoading = true;

      try {
        final email = emailController.text.trim();
        final password = passwordController.text.trim();
        final user =
            await _authService.signInWithEmailPassword(email, password);

        if (user != null) {
          await _saveUserData();
          await _navigateBasedOnUserStatus(context, user);
        } else {
          CustomSnackbar().snakBarError(
              context, 'Login failed: Invalid email or password.');
        }
      } catch (e) {
        debugPrint('Error during login: $e');
        CustomSnackbar().snakBarError(
            context, 'Error during login. Please try again later.');
      } finally {
        setIsLoading = false;
      }
    }
  }

  Future<void> _navigateBasedOnUserStatus(
      BuildContext context, User user) async {
    setIsLoading = true;

    try {
      await user.reload();

      final userDoc = await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .get();

      if (user.emailVerified) {
        if (userDoc.exists) {
          Navigator.of(context).pushNamedAndRemoveUntil(
              '/mainNav-screen', (Route<dynamic> route) => false);
        } else {
          Navigator.of(context).pushNamedAndRemoveUntil(
              '/user-info', (Route<dynamic> route) => false);
        }
      } else {
        if (!userDoc.exists) {
          Navigator.of(context).pushNamedAndRemoveUntil(
              '/user-info', (Route<dynamic> route) => false);
        } else {
          Navigator.of(context).pushNamedAndRemoveUntil(
              '/email-verify', (Route<dynamic> route) => false);
        }
      }
    } catch (e) {
      debugPrint('Error in navigating based on user status: $e');
      CustomSnackbar().snakBarError(
          context, 'An error occurred while processing your login.');
    } finally {
      setIsLoading = false;
    }
  }

  Future<void> _saveUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('rememberMe', isRememberMe);
    if (isRememberMe) {
      prefs.setString('email', emailController.text);
      prefs.setString('password', passwordController.text);
    }
  }

//google signin
  Future<void> signInWithGoogleAccount(BuildContext context) async {
    setIsLoading = true;
    try {
      final result = await _authService.signInWithGoogle();
      if (result != null) {
        User? user = result['user'];
        bool isNew = result['isNew'];

        if (await _isEmailRegisteredWithPassword(user!.email)) {
          CustomSnackbar().snakBarError(
            context,
            'This email is already registered with an email/password account. Please use that method to log in.',
          );
          return;
        }

        if (isNew) {
          // New user, save email and navigate to the User Info page
          Provider.of<UserInfoFormStateProvider>(context, listen: false)
              .setEmail(user.email ?? '');
          Navigator.pushNamed(context, '/user-info');
        } else {
          // Returning user, navigate directly to the main screen
          Navigator.pushReplacementNamed(context, '/mainNav-screen');
        }
      }
    } catch (error) {
      CustomSnackbar().snakBarError(
        context,
        'Error signing in with Google: ${error.toString()}',
      );
    } finally {
      setIsLoading = false;
    }
  }

  Future<bool> _isEmailRegisteredWithPassword(String? email) async {
    if (email == null || email.isEmpty) return false;

    try {
      final signInMethods =
          await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
      return signInMethods.contains('password');
    } catch (e) {
      debugPrint('Error checking email sign-in methods: $e');
      return false;
    }
  }
}
