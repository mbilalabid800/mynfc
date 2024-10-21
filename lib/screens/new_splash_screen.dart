import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nfc_app/utils/ui_mode_helper.dart';

class NewSplashScreen extends StatefulWidget {
  const NewSplashScreen({super.key});

  @override
  State<NewSplashScreen> createState() => _NewSplashScreenState();
}

class _NewSplashScreenState extends State<NewSplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
    enableImmersiveStickyMode();

    // Initialize the animation controller
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync:
          this, // Provide the vsync with 'this' which is a SingleTickerProvider
    );

    // Define the animation
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.bounceOut,
    );

    // Start the animation
    _controller.forward();

    // Navigate to another screen after 3 seconds
    _navigationTimer = Timer(const Duration(seconds: 3), () {
      // if (mounted) {
      //   Navigator.of(context).pushReplacement(
      //     MaterialPageRoute(
      //         builder: (context) =>
      //             SplashScreen()), // Replace with your next screen
      //   );
      // }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _navigationTimer?.cancel();
    super.dispose();
    //.this is a sample just for test
  }

  void _checkAuthStatus() async {
    // Simulate a delay for the splash screen
    await Future.delayed(const Duration(seconds: 3));

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      // User is not logged in, navigate to login
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/splash');
      }
    } else {
      // User is logged in, check Firestore data
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('userProfile')
          .doc('details')
          .get();

      if (!mounted) return;

      if (!userDoc.exists) {
        // User data does not exist, navigate to user info form screen
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/user-info');
        }
      } else if (!user.emailVerified) {
        // User's email is not verified, navigate to email verification screen
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/email-verify');
        }
      } else {
        // User data exists and email is verified, navigate to home screen
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/mainNav-screen');
        }
      }
    }
  }
  // void _checkAuthStatus() async {
  //   //// Simulate a delay for splash screen
  //   await Future.delayed(Duration(seconds: 5));

  //   final user = FirebaseAuth.instance.currentUser;

  //   if (user == null) {
  //     //check1 : User does not exist , navigate to login
  //     if (mounted) {
  //       Navigator.pushReplacementNamed(context, '/splash');
  //     }
  //   } else {
  //     // User is logged in, check Firestore data
  //     final userDoc = await FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(user.uid)
  //         .collection('userProfile')
  //         .doc('details')
  //         .get();

  //     if (!mounted) return;

  //     print('User document exists: ${userDoc.exists}');
  //     print('User document data: ${userDoc.data()}');
  //     if (!userDoc.exists) {
  //       //user data does not exists, nav to user form screen
  //       if (mounted) {
  //         Navigator.pushReplacementNamed(context, '/user-info');
  //       } else if (!user.emailVerified) {
  //         //user data exists but email is not verified
  //         if (mounted) {
  //           Navigator.pushReplacementNamed(context, '/set-password');
  //         }
  //       } else {
  //         if (mounted) {
  //           Navigator.pushReplacementNamed(context, '/mainNav-screen');
  //         }
  //       }
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Transform.scale(
              scale: _animation.value, // Apply the scale animation directly
              child: child,
            );
          },
          child: Image.asset(
            'assets/splash/nfc-2.png',
            width: 150,
            height: 150,
          ),
        ),
      ),
    );
  }
}
