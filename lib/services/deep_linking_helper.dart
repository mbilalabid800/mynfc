// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:nfc_app/screens/error-screen.dart';
import '../screens/connection_profile_preview_screen.dart';

class DeepLinkingHelper {
  StreamSubscription<Uri>? _sub;
  final AppLinks _appLinks = AppLinks();

  void initializeDeepLinking(BuildContext context) {
    _sub = _appLinks.uriLinkStream.listen(
      (Uri? uri) {
        if (uri != null) {
          handleDeepLink(context, uri);
        }
      },
      onError: (err) {
        debugPrint("Failed to receive link: $err");
      },
    );
  }

  void handleDeepLink(BuildContext context, Uri uri) {
    if (uri.pathSegments.isNotEmpty && uri.pathSegments.first == 'profile') {
      final userId = uri.pathSegments.length > 1 ? uri.pathSegments[1] : null;
      if (userId != null && userId.isNotEmpty) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ConnectionProfilePreview(userId: userId),
          ),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ErrorScreen(message: "Page not found"),
          ),
        );
      }
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ErrorScreen(message: "Page not found"),
        ),
      );
    }
  }

  void dispose() {
    _sub?.cancel();
  }
}
