import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';
import 'package:nfc_app/constants/appColors.dart';
import 'package:nfc_app/provider/connection_provider.dart';
import 'package:provider/provider.dart';

class DualRingLoader2 extends StatelessWidget {
  const DualRingLoader2({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset(
        'assets/animations/loader.json', // Path to your Lottie JSON file
        width: 100, // Adjust the width as needed
        height: 100, // Adjust the height as needed
        fit: BoxFit.contain, // Fit the animation in the container
      ),
    );
  }
}

class DualRingLoader extends StatelessWidget {
  const DualRingLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SpinKitHourGlass(
        color: AppColors.appOrangeColor, // Set your preferred color
        size: 50.0, // Adjust the size as needed
        duration: Duration(milliseconds: 1200), // Customize the animation speed
      ),
    );
  }
}

class SmallThreeBounceLoader extends StatelessWidget {
  const SmallThreeBounceLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SpinKitHourGlass(
        color: AppColors.appOrangeColor, // Set your preferred color
        size: 30.0, // Adjust the size as needed
        duration: Duration(milliseconds: 1200), // Customize the animation speed
      ),
    );
  }
}

class BigThreeBounceLoader extends StatelessWidget {
  const BigThreeBounceLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SpinKitThreeBounce(
        color: AppColors.appOrangeColor, // Set your preferred color
        size: 40.0, // Adjust the size as needed
        duration: Duration(milliseconds: 1200), // Customize the animation speed
      ),
    );
  }
}

// class HourGlassLoader extends StatelessWidget {
//   const HourGlassLoader({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const Center(
//       child: SpinKitHourGlass(
//         color: AppColors.appOrangeColor, // Set your preferred color
//         size: 40.0, // Adjust the size as needed
//         duration: Duration(milliseconds: 1200), // Customize the animation speed
//       ),
//     );
//   }
// }

class ScreenLoader extends StatelessWidget {
  const ScreenLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SpinKitHourGlass(
        color: AppColors.appOrangeColor, // Set your preferred color
        size: 50.0, // Adjust the size as needed
        duration: Duration(milliseconds: 1200), // Customize the animation speed
      ),
    );
  }
}

class OrderLoader extends StatelessWidget {
  const OrderLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SpinKitFoldingCube(
        color: AppColors.appOrangeColor, // Set your preferred color
        size: 50.0, // Adjust the size as needed
        duration: Duration(milliseconds: 1200), // Customize the animation speed
      ),
    );
  }
}

class ConnectionLoader extends StatelessWidget {
  const ConnectionLoader({super.key});

  @override
  Widget build(BuildContext context) {
    final showCompanyConnections =
        Provider.of<ConnectionProvider>(context).showCompanyConnections;

    return Center(
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.center, // Center the content vertically
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SpinKitHourGlass(
            color: AppColors.appOrangeColor, // Set your preferred color
            size: 40.0, // Adjust the size as needed
            duration: const Duration(
                milliseconds: 1200), // Customize the animation speed
          ),
          SizedBox(height: 20),
          Text(
            showCompanyConnections
                ? 'Loading Company Connections...'
                : 'Loading All Connections...',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              fontFamily: 'Barlow-Regular',
              color: AppColors.appOrangeColor,
            ), // Adjust text style as needed
          ),
        ],
      ),
    );
  }
}

class CardLoader extends StatelessWidget {
  const CardLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SpinKitHourGlass(
        color: AppColors.appOrangeColor, // Set your preferred color
        size: 50.0, // Adjust the size as needed
        duration: Duration(seconds: 2), // Customize the animation speed
      ),
    );
  }
}
