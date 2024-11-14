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
  //         .collection("userProfile")
  //         .doc("details");
  //     await userDocRef.update({'profileViews': FieldValue.increment(1)});
  //   } catch (e) {
  //     print("Error incrementing profile views for $uid: $e");
  //   }
  // }

  Future<void> incrementProfileViews(String uid) async {
    try {
      final userDocRef = FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .collection("chartsData")
          .doc("profileViews");
      await userDocRef.update({'viewCount': FieldValue.increment(1)});
    } catch (e) {
      print("Error incrementing profile views for $uid: $e");
    }
  }

  void clear() {
    _connectionDetails = null;
    notifyListeners();
  }
}
