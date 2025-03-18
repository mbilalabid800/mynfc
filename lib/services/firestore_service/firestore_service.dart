// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // // Future<Map<String, String>?> getUserData(String userId) async {
  //   try {
  //     DocumentSnapshot doc = await _db.collection('users').doc(userId).get();
  //     if (doc.exists) {
  //       return {
  //         'firstName': doc['first_name'] ?? '',
  //         'lastName': doc['last_name'] ?? '',
  //       };
  //     } else {
  //       debugPrint('Document does not exist');
  //       return null;
  //     }
  //   } catch (e) {
  //     debugPrint('Error fetching user data: $e');
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

  // Future<void> incrementTapCount() async {
  //   User? user = FirebaseAuth.instance.currentUser;

  //   if (user != null) {
  //     String userId = user.uid;
  //     DocumentReference userRef =
  //         FirebaseFirestore.instance.collection('users').doc(userId);

  //     await FirebaseFirestore.instance.runTransaction((transaction) async {
  //       DocumentSnapshot snapshot = await transaction.get(userRef);

  //       if (!snapshot.exists) {
  //         // If the document doesn't exist, create it with an initial tapCount of 1
  //         transaction.set(userRef, {'tapCount': 1});
  //       } else {
  //         // If it exists, increment the tapCount
  //         int newTapCount =
  //             (snapshot.data() as Map<String, dynamic>)['tapCount'] + 1;
  //         transaction.update(userRef, {'tapCount': newTapCount});
  //       }
  //     });
  //   } else {
  //     debugPrint("User not authenticated");
  //   }
  // }

  static Future<void> incrementTapCount(String userId, String appName) async {
    final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('chartsData')
        .doc('socialAppTaps');

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final doc = await transaction.get(docRef);
      if (doc.exists) {
        transaction.update(docRef, {
          appName: FieldValue.increment(1),
          'timestamps':
              FieldValue.arrayUnion([DateTime.now().toIso8601String()])
        });
      } else {
        transaction.set(docRef, {
          appName: 1,
          'timestamps': [DateTime.now().toIso8601String()]
        });
      }
    });
  }

  Future<void> subscribeUser(String email) async {
    try {
      await _db.collection('email_subscribers').add({
        'email': email,
        'subscribed_at': Timestamp.now(), // Optional: Add timestamp
      });
      debugPrint("Subscription successful");
    } catch (e) {
      debugPrint("Error subscribing: $e");
      throw Exception("Failed to subscribe user");
    }
  }

  Future<void> saveNewsletterSubscriber(String email) async {
    if (email.isNotEmpty && _isValidEmail(email)) {
      await _db.collection('subscribers').add({'email': email});
    } else {
      throw Exception('Invalid email');
    }
  }

  bool _isValidEmail(String email) {
    final RegExp emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return emailRegex.hasMatch(email);
  }

  static Future<void> updateSocialAppTap({
    required String appName,
    required String uid,
  }) async {
    final firestore = FirebaseFirestore.instance;

    try {
      // Reference to the specific social app in Firestore
      final socialAppRef = firestore
          .collection('users')
          .doc(uid)
          .collection('chartsData')
          .doc('socialAppTaps');

// Use Firestore transactions to ensure atomic updates
      await firestore.runTransaction((transaction) async {
        final snapshot = await transaction.get(socialAppRef);

        if (!snapshot.exists) {
          // If document doesn't exist, create it with the appName count
          transaction.set(socialAppRef, {
            appName: 1,
            'timestamps': [DateTime.now().toIso8601String()],
          });
        } else {
          final data = snapshot.data() as Map<String, dynamic>? ?? {};
          final int currentCount = (data[appName] ?? 0) as int;

          // Update the tap count and add timestamp
          transaction.update(socialAppRef, {
            appName: currentCount + 1,
            'timestamps':
                FieldValue.arrayUnion([DateTime.now().toIso8601String()]),
          });
        }
      });

      debugPrint('$appName tap logged successfully!');
    } catch (e) {
      debugPrint('Error updating Firestore: $e');
    }
  }
  // Increment the count and add timestamp
  //     await socialAppRef.set({
  //       appName: FieldValue.increment(1),
  //       'timestamps': FieldValue.arrayUnion([DateTime.now().toIso8601String()]),
  //     }, SetOptions(merge: true));

  //     debugPrint('$appName tap logged successfully!');
  //   } catch (e) {
  //     debugPrint('Error updating Firestore: $e');
  //   }
  // }

  Future<Map<String, int>> fetchSocialAppTaps(String uid) async {
    final firestore = FirebaseFirestore.instance;
    final socialAppTapsRef = firestore
        .collection('users')
        .doc(uid)
        .collection('chartsData')
        .doc('socialAppTaps');

    try {
      final snapshot = await socialAppTapsRef.get();
      if (snapshot.exists) {
        // Convert Firestore data to a map of appName -> count
        final data = snapshot.data();
        final Map<String, int> appCounts = {};

        data?.forEach((key, value) {
          if (value is int) {
            appCounts[key] = value;
          }
        });
        print('Fetched App Taps: $appCounts'); // Debugging Output
        return appCounts;
      } else {
        print('No app taps data found.');
        return {};
      }
    } catch (e) {
      debugPrint('Error fetching social app taps: $e');
      return {};
    }
  }

  static Future<String?> fetchSelectedPlan() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        return userDoc.exists ? userDoc['planName'] ?? "Free" : null;
      } catch (e) {
        debugPrint("Error fetching plan: $e");
        return null;
      }
    }
    return null;
  }
}
