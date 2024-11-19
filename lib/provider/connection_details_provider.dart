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
      await incrementProfileViews(uid);
      DocumentSnapshot<Map<String, dynamic>> docSnapshot =
          await FirebaseFirestore.instance
              .collection("users")
              .doc(uid)
              .collection("userProfile")
              .doc("details")
              .get();
      if (docSnapshot.exists) {
        final connectionDetails =
            ConnectionDetailsModel.fromFirestore(docSnapshot);
        QuerySnapshot<Map<String, dynamic>> socialAppsSnapshot =
            await FirebaseFirestore.instance
                .collection("users")
                .doc(uid)
                .collection("socialLinks")
                .orderBy("index")
                .get();

        final socialApps = socialAppsSnapshot.docs
            .map((doc) => SocialAppModel.fromFirestore(doc.data()))
            .toList();

        _connectionDetails = connectionDetails.copyWith(socialApps: socialApps)
            as ConnectionDetailsModel?;
      } else {
        print("Connection with uid $uid does not exist.");
        _connectionDetails = null;
      }
    } catch (e) {
      print("Error loading connection details: $e");
      _connectionDetails = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Future<void> incrementProfileViews(String uid) async {
  //   try {
  //     final userDocRef = FirebaseFirestore.instance
  //         .collection("users")
  //         .doc(uid)
  //         .collection("chartsData")
  //         .doc("profileViews");
  //     await userDocRef.set({
  //       'viewCount': FieldValue.increment(1),
  //       'timestamp':
  //           FieldValue.serverTimestamp(), // Add the current server time
  //     }, SetOptions(merge: true));
  //   } catch (e) {
  //     print("Error incrementing profile views for $uid: $e");
  //   }
  // }
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

      print("Profile view handled successfully for $uid");
    } catch (e) {
      print("Error handling profile view for $uid: $e");
    }
  }

  void clear() {
    _connectionDetails = null;
    notifyListeners();
  }
}
