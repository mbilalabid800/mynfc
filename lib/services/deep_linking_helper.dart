// import 'dart:async';

// import 'package:app_links/app_links.dart';
// import 'package:flutter/material.dart';
// import 'package:nfc_app/screens/connection_profile_preview_screen.dart';

// class DeepLinkingHelper {
//   StreamSubscription<Uri>? _sub;
//   final AppLinks _appLinks = AppLinks();

//   void initializeDeepLinking(BuildContext context) {
//     _sub = _appLinks.uriLinkStream.listen(
//       (Uri? uri) {
//         if (uri != null) {
//           handleDeepLink(context, uri);
//         }
//       },
//       onError: (err) {
//         debugPrint("Failed to receive link: $err");
//       },
//     );
//   }

//   void handleDeepLink(BuildContext context, Uri uri) {
//     if (uri.pathSegments.isNotEmpty && uri.pathSegments.first == 'profile') {
//       final userId = uri.pathSegments.length > 1 ? uri.pathSegments[1] : null;
//       if (userId != null && userId.isNotEmpty) {
//         // Push to profile preview screen using the extracted userId
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => ConnectionProfilePreview(userId: userId),
//           ),
//         );
//       } else {
//         debugPrint("Invalid or missing userId");
//       }
//     } else {
//       debugPrint("Invalid path segment");
//     }
//   }

//   void dispose() {
//     _sub?.cancel();
//   }
// }
