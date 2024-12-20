// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nfc_app/provider/user_info_form_state_provider.dart';
import 'package:nfc_app/services/auth_service/auth_service.dart';
import 'package:nfc_app/widgets/custom_snackbar_widget.dart';
import 'package:provider/provider.dart';

class AuthenticateProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  bool isLoading = false;

  Future<void> signInWithGoogleAccount(BuildContext context) async {
    isLoading = true;
    notifyListeners();

    try {
      final result = await _authService.signInWithGoogle();
      if (result != null) {
        User? user = result['user'];
        bool isNew = result['isNew'];

        if (isNew) {
          // New user, save email and navigate to the User Info page
          Provider.of<UserInfoFormStateProvider>(context, listen: false)
              .setEmail(user!.email ?? '');
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
      isLoading = false;
      notifyListeners();
    }
  }
}
