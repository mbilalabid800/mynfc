import 'package:flutter/material.dart';
import 'package:nfc_app/shared/utils/password_strength_helper.dart';

class PasswordValidationProvider with ChangeNotifier {
  bool isObscurePassword = false;
  bool isObscureConfirmPassword = false;
  String passwordStrength = '';
  String? unmetCriterionMessage;
  String? confirmPasswordErrorMessage;

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
      unmetCriterionMessage = null;
    } else {
      passwordCriteria = evaluatePasswordCriteria(password.trim());
      passwordStrength = evaluatePasswordStrength(passwordCriteria);
      unmetCriterionMessage = getFirstUnmetCriterion(passwordCriteria);

      // If all criteria are met, set the error message to null
      if (unmetCriterionMessage == '') {
        unmetCriterionMessage = null;
      }
    }
    notifyListeners();
  }

  void checkConfirmPassword(String password, String confirmPassword) {
    if (password.isEmpty || confirmPassword.isEmpty) {
      confirmPasswordErrorMessage = null;
    } else if (password != confirmPassword) {
      confirmPasswordErrorMessage = 'Passwords do not match';
    } else {
      confirmPasswordErrorMessage = null;
    }
    notifyListeners();
  }
}
