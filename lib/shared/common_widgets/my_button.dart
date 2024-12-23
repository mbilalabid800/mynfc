import 'package:flutter/material.dart';
import 'package:nfc_app/constants/appColors.dart';
import 'package:nfc_app/responsive/device_dimensions.dart';

class MyButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double width;
  final double height;
  final Color backgroundColor;
  final TextStyle? textStyle;
  final FontWeight fontWeight;
  final BorderRadiusGeometry borderRadius;

  const MyButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.width = double.infinity,
    this.height = 49.0,
    this.backgroundColor = AppColors.buttonColor,
    this.textStyle,
    this.fontWeight = FontWeight.w500,
    this.borderRadius = const BorderRadius.all(
      Radius.circular(30.0),
    ),
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius,
          ),
        ),
        child: Text(
          text,
          style: textStyle ??
              TextStyle(
                color: Colors.white,
                fontSize: DeviceDimensions.responsiveSize(context) * 0.053,
                fontWeight: fontWeight,
                fontFamily: 'Barlow-Regular',
              ),
        ),
      ),
    );
  }
}
