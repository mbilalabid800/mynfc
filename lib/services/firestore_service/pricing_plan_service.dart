import 'package:cloud_firestore/cloud_firestore.dart';

class SubscriptionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>?> fetchPlanDetails(String planType) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('SubscriptionPlan').doc(planType).get();

      if (doc.exists) {
        return doc.data() as Map<String, dynamic>;
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching plan: $e');
      return null;
    }
  }
}
