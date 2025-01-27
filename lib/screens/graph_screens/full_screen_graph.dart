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
            AbsherAppBar(
              title: 'Statistics',
              leftButton: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 9),
                    decoration: const BoxDecoration(
                        //color: Color(0xFFFFFFFF),
                        //shape: BoxShape.circle,
                        ),
                    child:
                        Icon(Icons.arrow_back, color: AppColors.appBlueColor)),
              ),
              rightButton: Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                    width: DeviceDimensions.screenWidth(context) * 0.035),
              ),
            ),
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
