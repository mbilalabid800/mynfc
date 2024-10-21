import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class InternetCheckerProvider extends ChangeNotifier {
  final Connectivity _connectivity = Connectivity();
  bool _hasInternet = true;

  bool get hasInternet => _hasInternet;

  InternetCheckerProvider() {
    _checkInitialConnection();
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  // Check initial connection when the app starts
  Future<void> _checkInitialConnection() async {
    var connectivityResult = await _connectivity.checkConnectivity();
    _updateConnectionStatus(connectivityResult);
  }

  // Update connection status based on connectivity result
  void _updateConnectionStatus(List<ConnectivityResult> connectivityResult) {
    if (connectivityResult == ConnectivityResult.none) {
      _hasInternet = false;
      print("Internet is OFF");
    } else {
      _hasInternet = true;
      print("Internet is ON");
    }
    notifyListeners();
  }
}
