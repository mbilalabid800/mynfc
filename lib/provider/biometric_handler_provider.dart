// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:nfc_app/shared/common_widgets/custom_snackbar_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BiometricHandlerProvider with ChangeNotifier {
  bool _isFingerprintEnabled = false;
  final LocalAuthentication _localAuth = LocalAuthentication();

  bool get isFingerprintEnabled => _isFingerprintEnabled;

  Future<void> toggleFingerprint(bool value, BuildContext context) async {
    bool isBiometricAvailable = await _localAuth.canCheckBiometrics;

    if (!isBiometricAvailable) {
      CustomSnackbar().snakBarError(
        context,
        "Fingerprint is not available on this device.",
      );
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFingerprintEnabled', value);

    _isFingerprintEnabled = value;
    notifyListeners();

    CustomSnackbar().snakBarMessage(
      context,
      value ? "Fingerprint enabled." : "Fingerprint disabled.",
    );
  }

  Future<bool> authenticateWithFingerprint() async {
    try {
      return await _localAuth.authenticate(
        localizedReason: 'Authenticate to access your account',
        options: const AuthenticationOptions(biometricOnly: true),
      );
    } catch (e) {
      debugPrint('Error during fingerprint authentication: $e');
      return false;
    }
  }

  Future<void> loadFingerprintPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isFingerprintEnabled = prefs.getBool('isFingerprintEnabled') ?? false;
    notifyListeners();
  }
}
