import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewSplashScreen extends StatefulWidget {
  const NewSplashScreen({super.key});

  @override
  State<NewSplashScreen> createState() => _NewSplashScreenState();
}

class _NewSplashScreenState extends State<NewSplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _initializeAnimation();
    _checkAuthStatus();
  }

  void _initializeAnimation() {
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.bounceOut,
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _checkAuthStatus() async {
    await Future.delayed(const Duration(seconds: 3));

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      Navigator.pushReplacementNamed(context, '/splash');
    } else {
      Navigator.pushReplacementNamed(context, '/login-screen');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Transform.scale(
              scale: _animation.value,
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
