import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PricingPlanProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _plans = [];

  List<Map<String, dynamic>> get plans => _plans;

  Future<void> fetchPlans() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('monthlyPlans')
          .doc('Individual')
          .collection('plans')
          .get();

      _plans = snapshot.docs.map((doc) {
        return {
          'name': doc.id,
          'features': doc['features'] ?? [],
          'createdAt': doc['createdAt'],
        };
      }).toList();

      notifyListeners();
    } catch (e) {
      print('Error fetching plans: $e');
    }
  }
}
