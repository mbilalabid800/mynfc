import 'package:cloud_firestore/cloud_firestore.dart';

class SubscriptionService {
  String selectedPlan = 'Freee';
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>?> fetchPlanDetails(String planType) async {
    try {
      var doc = await FirebaseFirestore.instance
          .collection('pricing_plans')
          .doc(planType)
          .get();

      if (doc.exists) {
        return doc.data();
      }
    } catch (e) {
      print('Error fetching plan: $e');
    }
    return null;
  }
}
