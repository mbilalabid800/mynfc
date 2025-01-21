import 'package:flutter/material.dart';
import 'package:nfc_app/constants/appColors.dart';
import 'package:nfc_app/responsive/device_dimensions.dart';

import 'package:nfc_app/shared/common_widgets/custom_app_bar_widget.dart';

class FullScreenGraph extends StatelessWidget {
  const FullScreenGraph({super.key});

  @override
  Widget build(BuildContext context) {
    final Widget graphWidget =
        ModalRoute.of(context)?.settings.arguments as Widget;
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.screenBackground,
        body: Column(
          children: [
            SizedBox(
              height: DeviceDimensions.screenHeight(context) * 0.0001,
            ),
            AbsherAppBar(title: 'Statistics'),
            SizedBox(height: DeviceDimensions.screenHeight(context) * 0.020),
            Flexible(
              child: graphWidget,
            ),
          ],
        ),
      ),
    );
  }
}
