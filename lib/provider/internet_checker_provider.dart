// ignore_for_file: depend_on_referenced_packages, unrelated_type_equality_checks, avoid_print

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class InternetCheckerProvider extends ChangeNotifier {
  final Connectivity _connectivity = Connectivity();
  bool _hasInternet = true;

  bool get hasInternet => _hasInternet;

  InternetCheckerProvider() {
    _checkInitialConnection();
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  Future<void> _checkInitialConnection() async {
    var connectivityResult = await _connectivity.checkConnectivity();
    _updateConnectionStatus(connectivityResult);
  }

  // Update connection status based on connectivity result
  Future<void> _updateConnectionStatus(
      List<ConnectivityResult> connectivityResult) async {
    if (connectivityResult == ConnectivityResult.none) {
      _hasInternet = false;
    } else {
      // Perform a ping to verify actual internet connectivity
      _hasInternet = await _pingInternet();
    }
    debugPrint('Internet status updated: $_hasInternet');
    notifyListeners();
  }

  // Ping Google to verify internet connectivity
  Future<bool> _pingInternet() async {
    try {
      final result = await http.get(Uri.parse('https://google.com')).timeout(
            const Duration(seconds: 5),
          );
      return result.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
