// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nfc_app/provider/internet_checker_provider.dart';

class InternetStatusHandler extends StatelessWidget {
  final Widget child;

  const InternetStatusHandler({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Consumer<InternetCheckerProvider>(
      builder: (context, internetChecker, _) {
        if (!internetChecker.hasInternet) {
          Future.microtask(() {
            if (ModalRoute.of(context)?.settings.name != '/internet-error') {
              Navigator.of(context).pushReplacementNamed('/internet-error');
            }
          });
        }

        return child; // Return the main app if internet is available
      },
    );
  }
}
