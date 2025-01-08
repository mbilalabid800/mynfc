import 'package:flutter/material.dart';
import 'package:nfc_app/screens/internet_error_screen.dart';
import 'package:provider/provider.dart';
import 'package:nfc_app/provider/internet_checker_provider.dart';

class InternetStatusHandler extends StatelessWidget {
  final Widget child;

  const InternetStatusHandler({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<InternetCheckerProvider>(
      builder: (context, internetCheckerProvider, child) {
        // If no internet, show the internet error screen
        if (!internetCheckerProvider.isConnected) {
          return const InternetError();
        }
        // Otherwise, show the main app
        return child!;
      },
      child: child,
    );
  }
}
