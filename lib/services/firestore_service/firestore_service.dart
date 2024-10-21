import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  //Save user data to Firestore
  Future<void> saveUserProfileData(
      String uid, Map<String, dynamic> userData) async {
    try {
      await _db.collection('users').doc(uid).set(userData);
    } catch (e) {
      print("Error saving user data: $e");
    }
  }

  // Future<Map<String, String>?> getUserData(String userId) async {
  //   try {
  //     DocumentSnapshot doc = await _db.collection('users').doc(userId).get();
  //     if (doc.exists) {
  //       return {
  //         'firstName': doc['first_name'] ?? '',
  //         'lastName': doc['last_name'] ?? '',
  //       };
  //     } else {
  //       print('Document does not exist');
  //       return null;
  //     }
  //   } catch (e) {
  //     print('Error fetching user data: $e');
  //     return null;
  //   }
  // }
}
