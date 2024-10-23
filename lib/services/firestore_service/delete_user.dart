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
    WriteBatch batch = FirebaseFirestore.instance.batch();
    try {
      // Delete socialLinks subcollection
      QuerySnapshot socialLinksSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('socialLinks')
          .get();
      for (DocumentSnapshot doc in socialLinksSnapshot.docs) {
        batch.delete(doc.reference);
      }

      // Delete connections subcollection
      QuerySnapshot connectionsSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('connections')
          .get();
      for (DocumentSnapshot doc in connectionsSnapshot.docs) {
        batch.delete(doc.reference);
      }

      // Delete userProfile subcollection
      QuerySnapshot userProfileSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('userProfile')
          .get();
      for (DocumentSnapshot doc in userProfileSnapshot.docs) {
        batch.delete(doc.reference);
      }

      //Delete the shipping address
      QuerySnapshot shippingAddressSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('shippingAddress')
          .get();
      for (DocumentSnapshot doc in shippingAddressSnapshot.docs) {
        batch.delete(doc.reference);
      }

      // Delete the user document itself
      DocumentReference userDoc =
          FirebaseFirestore.instance.collection('users').doc(uid);
      batch.delete(userDoc);

      // Commit the batch
      await batch.commit();
      print('User document and subcollections deleted from Firestore.');
    } catch (e) {
      print('Error deleting user data from Firestore: $e');
    }
  }

  Future<void> deleteUserFromConnections(String uid) async {
    try {
      // Fetch all users from the 'users' collection
      QuerySnapshot usersSnapshot =
          await FirebaseFirestore.instance.collection('users').get();

      // Iterate over all users to check their 'connections' subcollection
      for (var userDoc in usersSnapshot.docs) {
        String userId = userDoc.id;

        // Fetch connections for each user
        QuerySnapshot connectionSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('connections')
            .where('uid',
                isEqualTo: uid) // Assuming 'uid' field holds connections
            .get();

        // Remove the user from each 'connections' document where they are listed
        for (var connectionDoc in connectionSnapshot.docs) {
          await connectionDoc.reference.delete(); // Deleting the connection
        }
      }

      print('User removed from all connections subcollections.');
    } catch (e) {
      print('Error removing user from all connections: $e');
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
