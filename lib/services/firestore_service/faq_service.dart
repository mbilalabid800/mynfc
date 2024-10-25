// faq_service.dart
// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nfc_app/models/faq_model.dart';

class FaqService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<FaqModel>> fetchFaqs() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('faq').get();
      return querySnapshot.docs.map((doc) {
        return FaqModel.fromFirestore(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      print('Error fetching FAQs: $e');
      return [];
    }
  }
}
