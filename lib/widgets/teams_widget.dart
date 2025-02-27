import 'package:flutter/material.dart';
import 'package:nfc_app/constants/appColors.dart';
import 'package:nfc_app/shared/utils/no_back_button_observer.dart';

class Teams extends StatefulWidget {
  const Teams({super.key});

  @override
  State<Teams> createState() => _TeamsState();
}

class _TeamsState extends State<Teams> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.screenBackground,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text("Coming soon. Stay connected."),
            ],
          ),
        ),
      ),
    );
  }
}
