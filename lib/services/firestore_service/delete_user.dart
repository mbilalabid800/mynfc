// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:nfc_app/provider/user_info_form_state_provider.dart';
import 'package:provider/provider.dart';

class DeleteUser {
  Future<void> deleteUserFromAuth() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.delete();
      } else {
        debugPrint('No user is currently signed in.');
      }
    } catch (e) {
      debugPrint('Error deleting user from Firebase Authentication: $e');
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
      debugPrint('User document and subcollections deleted from Firestore.');
    } catch (e) {
      debugPrint('Error deleting user data from Firestore: $e');
    }
  }

  Future<void> deleteImage(BuildContext context) async {
    try {
      // Access the imageUrl from the provider
      final imageUrl =
          Provider.of<UserInfoFormStateProvider>(context, listen: false)
              .imageUrl;

      // Check if the imageUrl exists
      if (imageUrl.isNotEmpty) {
        // Get the Firebase Storage reference and delete the image
        await FirebaseStorage.instance.refFromURL(imageUrl).delete();
        debugPrint('Image deleted successfully from Firebase Storage.');
      } else {
        debugPrint('No image URL found to delete.');
      }
    } catch (e) {
      debugPrint('Error deleting image: $e');
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

      debugPrint('User removed from all connections subcollections.');
    } catch (e) {
      debugPrint('Error removing user from all connections: $e');
    }
  }

  Future<void> deleteUser(BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String uid = user.uid;
      await deleteUserFromConnections(uid);
      await deleteUserFromFirestore(uid);
      await deleteImage(context);
      await deleteUserFromAuth();
    } else {
      debugPrint('No user is currently signed in.');
    }
  }
}
