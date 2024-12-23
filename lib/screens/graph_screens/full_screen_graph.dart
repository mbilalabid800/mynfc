import 'package:flutter/material.dart';
import 'package:nfc_app/constants/appColors.dart';

import 'package:nfc_app/shared/common_widgets/custom_app_bar_widget.dart';

class FullScreenGraph extends StatelessWidget {
  const FullScreenGraph({super.key});

  @override
  Widget build(BuildContext context) {
    final Widget graphWidget =
        ModalRoute.of(context)?.settings.arguments as Widget;
    return Scaffold(
      appBar: const CustomAppBar(title: 'Statistics'),
      backgroundColor: AppColors.screenBackground,
      body: Center(
        child: graphWidget, // Display the passed graph widget
      ),
    );
  }
}
