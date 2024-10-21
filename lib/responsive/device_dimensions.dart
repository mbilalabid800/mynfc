import 'package:flutter/widgets.dart';

class DeviceDimensions {
  static double screenWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;

  static double screenHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;

  static double responsiveSize(BuildContext context) =>
      MediaQuery.of(context).size.width;
}
