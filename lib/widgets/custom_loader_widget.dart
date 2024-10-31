import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:nfc_app/provider/connection_provider.dart';
import 'package:provider/provider.dart';

class DualRingLoader extends StatelessWidget {
  const DualRingLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SpinKitDualRing(
        color: Color.fromARGB(255, 0, 0, 0), // Set your preferred color
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
      child: SpinKitThreeBounce(
        color: Color.fromARGB(255, 0, 0, 0), // Set your preferred color
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
        color: Color.fromARGB(255, 0, 0, 0), // Set your preferred color
        size: 40.0, // Adjust the size as needed
        duration: Duration(milliseconds: 1200), // Customize the animation speed
      ),
    );
  }
}

class ScreenLoader extends StatelessWidget {
  const ScreenLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SpinKitChasingDots(
        color: Color.fromARGB(255, 0, 0, 0), // Set your preferred color
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
        color: Color.fromARGB(255, 0, 0, 0), // Set your preferred color
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
          SpinKitChasingDots(
            color: Color.fromARGB(255, 0, 0, 0), // Set your preferred color
            size: 40.0, // Adjust the size as needed
            duration:
                Duration(milliseconds: 1200), // Customize the animation speed
          ),
          SizedBox(height: 20),
          Text(
            showCompanyConnections
                ? 'Loading Company Connections...'
                : 'Loading All Connections...',
            style: const TextStyle(
              fontSize: 14,
              fontFamily: 'Barlow-Regular',
              color: Colors.black,
            ), // Adjust text style as needed
          ),
        ],
      ),
    );
  }
}
