import 'package:flutter/material.dart';
import 'package:nfc_app/provider/authenticate_provider.dart';
import 'package:nfc_app/provider/connection_details_provider.dart';
import 'package:nfc_app/provider/connection_provider.dart';
import 'package:nfc_app/provider/loading_state_provider.dart';
import 'package:nfc_app/provider/social_app_provider.dart';
import 'package:nfc_app/provider/user_info_form_state_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClearAppData {
  static Future<void> clearAppData(BuildContext context) async {
    _clearProviders(context);
    await _clearSharedPreferences();
  }

  static void _clearProviders(BuildContext context) {
    Provider.of<AuthenticateProvider>(context, listen: false).clear();
    Provider.of<UserInfoFormStateProvider>(context, listen: false).clear();
    Provider.of<ConnectionDetailsProvider>(context, listen: false).clear();
    Provider.of<ConnectionProvider>(context, listen: false).clear();
    Provider.of<SocialAppProvider>(context, listen: false).clear();
    Provider.of<LoadingStateProvider>(context, listen: false).clear();
    // Add more providers here as needed
  }

  static Future<void> _clearSharedPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
