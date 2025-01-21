// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nfc_app/constants/appColors.dart';
import 'package:nfc_app/responsive/device_dimensions.dart';
import 'package:nfc_app/shared/common_widgets/custom_app_bar_widget.dart';

class GoogleMapsScreen extends StatefulWidget {
  const GoogleMapsScreen({super.key});

  @override
  State<GoogleMapsScreen> createState() => _GoogleMapsScreenState();
}

class _GoogleMapsScreenState extends State<GoogleMapsScreen> {
  GoogleMapController? _controller;
  // Initial camera position (latitude, longitude) for centering the map
  static const LatLng _initialPosition =
      LatLng(25.311720, 83.009760); // Example: San Francisco
  final Set<Marker> _markers = {}; // Set to hold the markers

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: AppColors.screenBackground,
          body: Column(
            children: [
              SizedBox(
                height: DeviceDimensions.screenHeight(context) * 0.0001,
              ),
              AbsherAppBar(title: 'Choose on Map'),
              SizedBox(height: DeviceDimensions.screenHeight(context) * 0.020),
              // SizedBox(
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Text('Select Your Pickup Point'),
                      Text(
                          'Set your exact pickup point  on map with machine name for order delivery as per your ease and conveniently nearby your location.'),
                      GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: _initialPosition,
                          zoom: 10.0,
                        ),
                        onMapCreated: (GoogleMapController controller) {
                          _controller = controller;
                        },
                        markers: _markers,
                        onTap: _handleTap,
                      )
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }

  void _handleTap(LatLng tappedPoint) {
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId(tappedPoint.toString()),
          position: tappedPoint,
          infoWindow: InfoWindow(
            title: 'New Location',
            snippet:
                'Lat: ${tappedPoint.latitude}, Lng: ${tappedPoint.longitude}',
          ),
        ),
      );
    });
  }

  // Optional: Method to move the map to a specific location
  Future<void> _goToMyLocation() async {
    final CameraPosition position = CameraPosition(
      target: LatLng(40.7128, -74.0060), // Example: New York City
      zoom: 12,
    );
    _controller?.animateCamera(CameraUpdate.newCameraPosition(position));
  }
}
