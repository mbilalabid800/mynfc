// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DeleteUser {
  Future<void> deleteUserFromAuth() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.delete();
      } else {
        print('No user is currently signed in.');
      }
    } catch (e) {
      print('Error deleting user from Firebase Authentication: $e');
    }
  }

  Future<void> deleteUserFromFirestore(String uid) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('socialLinks')
          .get()
          .then((snapshot) {
        for (DocumentSnapshot doc in snapshot.docs) {
          doc.reference.delete();
        }
      });
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('connections')
          .get()
          .then((snapshot) {
        for (DocumentSnapshot doc in snapshot.docs) {
          doc.reference.delete();
        }
      });
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('userProfile')
          .get()
          .then((snapshot) {
        for (DocumentSnapshot doc in snapshot.docs) {
          doc.reference.delete();
        }
      });
      await FirebaseFirestore.instance.collection('users').doc(uid).delete();
      print('User document and subcollections deleted from Firestore.');
    } catch (e) {
      print('Error deleting user data from Firestore: $e');
    }
  }

  Future<void> deleteUserFromConnections(String uid) async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('connections')
          .where('users', arrayContains: uid)
          .get();

      for (var doc in snapshot.docs) {
        await FirebaseFirestore.instance
            .collection('connections')
            .doc(doc.id)
            .update({
          'users': FieldValue.arrayRemove([uid]),
        });
      }
      print('User removed from all connections.');
    } catch (e) {
      print('Error removing user from connections: $e');
    }
  }

  Future<void> deleteUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String uid = user.uid;
      await deleteUserFromConnections(uid);
      await deleteUserFromFirestore(uid);
      await deleteUserFromAuth();
    } else {
      print('No user is currently signed in.');
    }
  }
}
