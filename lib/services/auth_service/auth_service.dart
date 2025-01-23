// ignore_for_file: avoid_print, use_build_context_synchronously, unused_element

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nfc_app/provider/loading_state_provider.dart';
import 'package:nfc_app/screens/auth/login_screen.dart';
import 'package:nfc_app/provider/clear_app_data_provider.dart';
import 'package:nfc_app/shared/common_widgets/custom_snackbar_widget.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign in with email and password
  Future<User?> signInWithEmailPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return user;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  // Register with email and password
  Future<User?> registerWithEmailPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return user;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  // Sign out
  Future<void> signOut(BuildContext context) async {
    try {
      //sign out of firebase
      await _auth.signOut();

      //sign out of google id
      final GoogleSignIn googleSignIn = GoogleSignIn();
      await googleSignIn.signOut();
      await ClearAppData.clearAppData(context);

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (Route<dynamic> route) => false);
      Future.delayed(const Duration(milliseconds: 200), () async {});
    } catch (e) {
      debugPrint(e.toString());
      return;
    }
  }

  Future<Map<String, dynamic>?> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        return null; // User canceled the sign-in
      }
      LoadingStateProvider().setLoading(true);
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        bool isNew = await isNewUser(user);
        return {'user': user, 'isNew': isNew};
      }
      return null;
    } catch (e) {
      debugPrint("Google Sign-In failed: $e");
      return null;
    } finally {
      LoadingStateProvider().setLoading(false);
    }
  }

  Future<bool> isNewUser(User user) async {
    final DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    return !userDoc.exists;
  }

  //Sign in with Apple
  Future<User?> signInWithApple() async {
    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );
      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(oauthCredential);
      return userCredential.user;
    } catch (e) {
      debugPrint("Apple Sign-In failed: $e");
      return null;
    }
  }

//Send Email for Verification
  Future<void> sendVerificationEmail({required BuildContext context}) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        CustomSnackbar().snakBarMessage(
            context, 'Verification email sent to ${user.email}');
        Navigator.pushNamed(context, '/email-verify');

        // } else {
        //   ScaffoldMessenger.of(context).showSnackBar(
        //     const SnackBar(content: Text('User is already verified')),
        //   );
      }
    } catch (e) {
      debugPrint("Error during email verification: $e");
      CustomSnackbar()
          .snakBarError(context, 'Failed to send verification email.');
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      // Show success message

      debugPrint('Password reset email sent');
    } on FirebaseAuthException catch (e) {
      // Handle errors here
      debugPrint('Failed to send password reset email: $e');
    }
  }

  // Future<String> generateProfileLink() async {
  //   // Get the current user's UID
  //   User? user = FirebaseAuth.instance.currentUser;

  //   if (user != null) {
  //     String uid = user.uid;
  //     // Generate the link
  //     String userProfileLink = 'https://myabsher.com/profile/$uid';
  //     return userProfileLink;
  //   } else {
  //     throw Exception('User not logged in');
  //   }
  // }
}
