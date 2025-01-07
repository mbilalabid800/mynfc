// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nfc_app/models/connection_details_model.dart';
import 'package:nfc_app/models/social_app_model.dart';

class ConnectionDetailsProvider extends ChangeNotifier {
  ConnectionDetailsModel? _connectionDetails;
  bool _isLoading = false;

  ConnectionDetailsModel? get connectionDetails => _connectionDetails;
  bool get isLoading => _isLoading;

  Future<void> loadConnectionDetails(String uid) async {
    try {
      _isLoading = true;
      notifyListeners();

      // Increment profile views
      await incrementProfileViews(uid);

      // Fetch the user's connection details
      DocumentSnapshot<Map<String, dynamic>> docSnapshot =
          await FirebaseFirestore.instance.collection("users").doc(uid).get();
      if (docSnapshot.exists) {
        final connectionDetails =
            ConnectionDetailsModel.fromFirestore(docSnapshot);

        // Fetch social links
        QuerySnapshot<Map<String, dynamic>> socialAppsSnapshot =
            await FirebaseFirestore.instance
                .collection("users")
                .doc(uid)
                .collection("socialLinks")
                .orderBy("index")
                .get();

        // Map and filter only visible social apps
        final socialApps = socialAppsSnapshot.docs
            .map((doc) => SocialAppModel.fromFirestore(doc.data()))
            .where((socialApp) => socialApp.isVisible)
            .toList();

        // Update connection details with filtered social apps
        _connectionDetails = connectionDetails.copyWith(socialApps: socialApps);
      } else {
        debugPrint("Connection with uid $uid does not exist.");
        _connectionDetails = null;
      }
    } catch (e) {
      debugPrint("Error loading connection details: $e");
      _connectionDetails = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> incrementProfileViews(String uid) async {
    try {
      final profileViewsRef = FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .collection("chartsData")
          .doc("profileViews");

      final logRef = FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .collection("chartsData")
          .doc("profileViewsLog")
          .collection("logs")
          .doc(); // Automatically generate a unique document ID

      // Perform both actions in parallel for efficiency
      await Future.wait([
        // Increment the total views
        profileViewsRef.set({
          'totalViews': FieldValue.increment(1),
          'lastUpdated': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true)),

        // Log the individual view with timestamp
        logRef.set({
          'viewCount': 1, // Each view is recorded as a single count
          'timestamp': FieldValue.serverTimestamp(), // Current server time
        }),
      ]);

      debugPrint("Profile view handled successfully for $uid");
    } catch (e) {
      debugPrint("Error handling profile view for $uid: $e");
    }
  }

  void clear() {
    _connectionDetails = null;
    notifyListeners();
  }
}
