import 'package:flutter/material.dart';

class FormValidationProvider with ChangeNotifier {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  //Stores form errors and values
  final Map<String, String?> _errors = {};
  final Map<String, String> _values = {};

  // Expose values and errors
  String? getError(String field) => _errors[field];
  String getValue(String field) => _values[field] ?? '';

  // Update field value with validation
  void updateField({
    required String field,
    required String value,
    required String? Function(String) validator,
  }) {
    final trimmedValue = value.trim();
    final error = validator(trimmedValue);

    if (error != null) {
      _errors[field] = error; // Set the error
    } else {
      _errors.remove(field); // Clear the error
      _values[field] = trimmedValue; // Update valid value
    }

    notifyListeners();
  }

  // Clear all form data
  void resetForm() {
    _errors.clear();
    _values.clear();
    notifyListeners();
  }

  // Form validation check
  bool validateForm() {
    return _errors.isEmpty; // True if no errors
  }

  // First name validation
  // String? validateFirstName(String firstName) {
  //   final regex = RegExp(r'^[a-zA-Z]+$');
  //   if (firstName.startsWith(' ')) {
  //     return 'First name cannot start with a space';
  //   } else if (firstName.isEmpty) {
  //     return 'First name cannot be empty';
  //   } else if (firstName.length < 2) {
  //     return 'First name must be at least 2 characters';
  //   } else if (firstName.length > 20) {
  //     return 'First name must not exceed 20 characters';
  //   } else if (!regex.hasMatch(firstName)) {
  //     return 'Only letters are allowed';
  //   }
  //   return null; // No errors
  // }

  // // Last name validation
  // String? validateLastName(String lastName) {
  //   final regex = RegExp(r'^[a-zA-Z]+$');
  //   if (lastName.startsWith(' ')) {
  //     return 'Last name cannot start with a space';
  //   } else if (lastName.isEmpty) {
  //     return 'Last name cannot be empty';
  //   } else if (lastName.length < 2) {
  //     return 'Last name must be at least 2 characters';
  //   } else if (lastName.length > 20) {
  //     return 'Last name must not exceed 20 characters';
  //   } else if (!regex.hasMatch(lastName)) {
  //     return 'Only letters are allowed';
  //   }
  //   return null; // No errors
  // }
}
