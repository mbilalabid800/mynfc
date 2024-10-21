import 'package:flutter/material.dart';
import 'package:nfc_app/constants/appColors.dart';

String evaluatePasswordStrength(Map<String, bool> criteria) {
  int score = criteria.values.where((passed) => passed).length;

  if (score <= 2) {
    return 'Weak';
  } else if (score == 3 || score == 4) {
    return 'Medium';
  } else {
    return 'Strong';
  }
}

String getFirstUnmetCriterion(Map<String, bool> criteria) {
  if (!criteria['uppercase']!) {
    return 'Please include at least one uppercase letter.';
  }
  if (!criteria['lowercase']!) {
    return 'Please include at least one lowercase letter.';
  }
  if (!criteria['numbers']!) return 'Please include at least one number.';
  if (!criteria['specialChars']!) {
    return 'Please include at least one special character.';
  }
  if (!criteria['length']!) {
    return 'Password must be at least 8 characters long.';
  }
  return '';
}

double getPasswordStrengthValue(String strength) {
  switch (strength) {
    case 'Weak':
      return 0.33;
    case 'Medium':
      return 0.66;
    case 'Strong':
      return 1.0;
    case 'Enter Password':
      return 0.0;
    default:
      return 0.0;
  }
}

Color getPasswordStrengthColor(String strength) {
  switch (strength) {
    case 'Weak':
      return AppColors.weakPassword;
    case 'Medium':
      return AppColors.mediumPassword;
    case 'Strong':
      return AppColors.strongPassword;
    case 'Enter password':
      return Colors.grey;
    default:
      return Colors.grey;
  }
}

Map<String, bool> evaluatePasswordCriteria(String password) {
  return {
    'length': password.length >= 8,
    'uppercase': password.contains(RegExp(r'[A-Z]')),
    'lowercase': password.contains(RegExp(r'[a-z]')),
    'numbers': password.contains(RegExp(r'[0-9]')),
    'specialChars': password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]')),
  };
}
