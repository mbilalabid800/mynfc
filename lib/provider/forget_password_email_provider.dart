import 'package:flutter/material.dart';

class ForgetPasswordEmailProvider with ChangeNotifier {
  String _email = '';

  String get email => _email;

  void setEmail(String email) {
    _email = email;
    notifyListeners();
  }
}
