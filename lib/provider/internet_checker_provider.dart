import 'dart:async';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class InternetCheckerProvider with ChangeNotifier {
  bool _isConnected = true;
  bool get isConnected => _isConnected;

  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  // Start listening to connectivity changes
  void startListeningToConnectivity() {
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> result) {
      _updateConnectionStatus(result[0]);
    });
  }

  // Update connection status based on the connectivity result
  void _updateConnectionStatus(ConnectivityResult result) {
    if (result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi) {
      _isConnected = true;
    } else {
      _isConnected = false;
    }
    notifyListeners(); // Notify listeners of the change
  }

  // Stop listening to connectivity changes
  void stopListeningToConnectivity() {
    _connectivitySubscription.cancel();
  }
}
