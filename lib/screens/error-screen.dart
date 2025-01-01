import 'package:flutter/material.dart';
import 'package:nfc_app/constants/appColors.dart';

class ErrorScreen extends StatelessWidget {
  final String message;

  const ErrorScreen({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenBackground,
      body: Center(
          child: Text(
        message,
        style: TextStyle(
          fontFamily: 'Barlow-Regular',
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      )),
    );
  }
}
