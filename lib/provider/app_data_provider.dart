// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nfc_app/models/app_data_model.dart';

class AppDataProvider with ChangeNotifier {
  final List<AppDataModel> _privacyPolicy = [];
  final List<AppDataModel> _termsCondition = [];
  bool _isLoading = false;

  List<AppDataModel> get privacyPolicy => _privacyPolicy;
  List<AppDataModel> get termsCondition => _termsCondition;
  bool get isLoading => _isLoading;

  Future<void> fetchPrivacyPolicy() async {
    try {
      _isLoading = true;
      _privacyPolicy.clear();
      notifyListeners();

      final querySnapshot =
          await FirebaseFirestore.instance.collection("PrivacyPolicy").get();
      for (var doc in querySnapshot.docs) {
        _privacyPolicy.add(AppDataModel.fromFirestore(doc.data()));
      }
    } catch (e) {
      print("Error fetching Privacy Policy: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchTermConditions() async {
    try {
      _isLoading = true;
      _termsCondition.clear();
      notifyListeners();

      final querySnapshot =
          await FirebaseFirestore.instance.collection("TermsCondition").get();
      for (var doc in querySnapshot.docs) {
        _termsCondition.add(AppDataModel.fromFirestore(doc.data()));
      }
    } catch (e) {
      print("Error fetching Terms & Condition: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
