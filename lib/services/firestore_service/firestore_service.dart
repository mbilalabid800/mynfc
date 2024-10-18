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

  Future<int> getTapCount(String userId) async {
    DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (snapshot.exists) {
      // Cast the snapshot data to a Map<String, dynamic>
      Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

      if (data != null && data.containsKey('tapCount')) {
        return data['tapCount'];
      }
    }

    return 0; // Default tap count if not found
  }
}
