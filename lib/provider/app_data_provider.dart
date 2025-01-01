// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class AppDataProvider with ChangeNotifier {
  bool _isLoading = false;
  List<Map<String, dynamic>> _privacyPolicy = [];
  List<Map<String, dynamic>> _termsCondition = [];

  bool get isLoading => _isLoading;
  List<Map<String, dynamic>> get privacyPolicy => _privacyPolicy;
  List<Map<String, dynamic>> get termsCondition => _termsCondition;

  Future<void> fetchPrivacyPolicy() async {
    _isLoading = true;
    notifyListeners();

    try {
      final querySnapshot =
          await FirebaseFirestore.instance.collection("PrivacyPolicy").get();
      _privacyPolicy = querySnapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print("Error fetching Privacy Policy: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchTermConditions() async {
    _isLoading = true;
    notifyListeners();

    try {
      final querySnapshot =
          await FirebaseFirestore.instance.collection("TermsCondition").get();
      _termsCondition = querySnapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print("Error fetching Terms & Condition: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
