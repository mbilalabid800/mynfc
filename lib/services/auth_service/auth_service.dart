// ignore_for_file: avoid_print, use_build_context_synchronously, unused_element

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nfc_app/screens/auth/login_screen.dart';
import 'package:nfc_app/provider/clear_app_data_provider.dart';
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
      print(e.toString());
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
      print(e.toString());
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
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (Route<dynamic> route) => false);
      Future.delayed(const Duration(milliseconds: 200), () async {
        await ClearAppData.clearAppData(context);
      });
    } catch (e) {
      print(e.toString());
      return;
    }
  }

  // Sign in with google
  Future<User?> signInWithGoogle() async {
    try {
      // Trigger the Google Authentication process
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        print("Google Sign-In canceled.");
        return null; // The user canceled the sign-in
      }

      print("Google account selected: ${googleUser.email}");

      // Retrieve the authentication details
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credentials
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      // Return the Firebase user
      return userCredential.user;
    } catch (e) {
      print("Google Sign-In failed: $e");
      return null;
    }
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
      print("Apple Sign-In failed: $e");
      return null;
    }
  }

//Send Email for Verification
  Future<void> sendVerificationEmail({required BuildContext context}) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Verification email sent to ${user.email}')),
        );
        Navigator.pushNamed(context, '/email-verify');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User is already verified')),
        );
      }
    } catch (e) {
      print("Error during email verification: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to send verification email.')),
      );
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      // Show success message

      print('Password reset email sent');
    } on FirebaseAuthException catch (e) {
      // Handle errors here
      print('Failed to send password reset email: $e');
    }
  }

  Future<String> generateProfileLink() async {
    // Get the current user's UID
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      String uid = user.uid;
      // Generate the link
      String userProfileLink =
          'https://nfcapp.com/connection-profile-preview/$uid';
      return userProfileLink;
    } else {
      throw Exception('User not logged in');
    }
  }
}
