import 'package:flutter/material.dart';
import 'package:nfc_app/responsive/device_dimensions.dart';

class AddedConnectionsCountWidget extends StatelessWidget {
  final int totalConnections;

  const AddedConnectionsCountWidget(
      {super.key, required this.totalConnections});

  @override
  Widget build(BuildContext context) {
    return Text(
      '$totalConnections',
      style: TextStyle(
          fontSize: DeviceDimensions.responsiveSize(context) * 0.05,
          fontWeight: FontWeight.w600),
    );
  }
}
