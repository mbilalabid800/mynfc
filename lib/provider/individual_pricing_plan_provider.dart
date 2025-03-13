import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/price_feature_model.dart';

class IndividualPricingProvider extends ChangeNotifier {
  bool isFetchingPlans = false;
  bool isSavingPlan = false;
  int? selectedContainer;
  String? selectedPlanName;
  List<Map<String, dynamic>> plans = [];

  IndividualPricingProvider() {
    fetchPlansFromFireStore();
  }

  Future<void> fetchPlansFromFireStore() async {
    isFetchingPlans = true;
    notifyListeners();

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('monthlyPlans')
          .doc('Individual')
          .collection('plans')
          .orderBy('order')
          .get();

      plans = snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      debugPrint("Error fetching Individual plan: $e");
    }

    isFetchingPlans = false;
    notifyListeners();
  }

  void selectPlan(int index, String planName) {
    selectedContainer = index;
    selectedPlanName = planName;
    notifyListeners();
  }

  Future<void> savePlanToFirebase(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && selectedPlanName != null) {
      isSavingPlan = true;
      notifyListeners();
      try {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'planName': selectedPlanName,
        }, SetOptions(merge: true));

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("$selectedPlanName plan updated successfully!")),
        );
      } catch (e) {
        debugPrint("Error saving plan: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to save plan. Please try again.")),
        );
      }
      isSavingPlan = false;
      notifyListeners();
    }
  }
}
