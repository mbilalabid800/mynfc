import 'package:flutter/material.dart';
import 'package:nfc_app/shared/utils/password_strength_helper.dart';

class PasswordValidationProvider with ChangeNotifier {
  bool isObscurePassword = true;
  bool isObscureConfirmPassword = true;
  String passwordStrength = '';
  String unmetCriterionMessage = '';
  String confirmPasswordErrorMessage = '';

  Map<String, bool> passwordCriteria = {
    'length': false,
    'uppercase': false,
    'lowercase': false,
    'numbers': false,
    'specialChars': false,
  };

  void togglePasswordVisibility() {
    isObscurePassword = !isObscurePassword;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    isObscureConfirmPassword = !isObscureConfirmPassword;
    notifyListeners();
  }

  void checkPasswordStrength(String password) {
    if (password.isEmpty) {
      unmetCriterionMessage = '';
    } else {
      passwordCriteria = evaluatePasswordCriteria(password.trim());
      passwordStrength = evaluatePasswordStrength(passwordCriteria);
      unmetCriterionMessage = getFirstUnmetCriterion(passwordCriteria);
    }
    notifyListeners();
  }

  void checkConfirmPassword(String password, String confirmPassword) {
    if (password != confirmPassword) {
      confirmPasswordErrorMessage = 'Passwords do not match';
    } else {
      confirmPasswordErrorMessage = '';
    }
    notifyListeners();
  }
}
