// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:nfc_app/shared/common_widgets/custom_snackbar_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlLauncherHelper {
  static Future<void> launchPhone(
      BuildContext context, String phoneNumber) async {
    if (phoneNumber.isEmpty) {
      CustomSnackbar().snakBarError(context, 'Phone number is not available.');
      return;
    }

    final Uri telUri = Uri(scheme: 'tel', path: phoneNumber);

    try {
      final bool launched = await launchUrl(
        telUri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched) {
        CustomSnackbar()
            .snakBarError(context, "'Could not open the phone dialer.'");
      }
    } catch (e) {
      CustomSnackbar()
          .snakBarError(context, 'An error occurred while opening the dialer.');
    }
  }

  static Future<void> launchEmail(
    BuildContext context,
    String email, {
    String? subject,
    String? body,
  }) async {
    if (email.isEmpty) {
      CustomSnackbar().snakBarError(context, 'Email is not available.');
      return;
    }

    // Encode subject and body if provided
    final String encodedSubject =
        subject != null ? Uri.encodeComponent(subject) : '';
    final String encodedBody = body != null ? Uri.encodeComponent(body) : '';

    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      query: 'subject=$encodedSubject&body=$encodedBody',
    );

    try {
      final bool launched = await launchUrl(
        emailUri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched) {
        CustomSnackbar().snakBarError(context, 'Could not open the email app.');
      }
    } catch (e) {
      CustomSnackbar().snakBarError(
          context, 'An error occurred while opening the email app.');
    }
  }

  static Future<void> launchSocialApps(BuildContext context, String url) async {
    if (url.isEmpty) {
      CustomSnackbar().snakBarError(context, 'URL is not available.');
      return;
    }

    final Uri webUri = Uri.parse(url);

    try {
      final bool launched = await launchUrl(
        webUri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched) {
        CustomSnackbar().snakBarError(context, 'Could not open the URL.');
      }
    } catch (e) {
      CustomSnackbar()
          .snakBarError(context, 'An error occurred while opening the URL.');
    }
  }
}
