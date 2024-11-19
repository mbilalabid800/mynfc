// ignore_for_file: file_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nfc_app/screens/active_product_screen.dart';
import 'package:nfc_app/screens/card_details_screen.dart';
import 'package:nfc_app/screens/graph_screens/graph_screen.dart';
import 'package:nfc_app/screens/home_screen.dart';
import 'package:nfc_app/screens/settings_screen.dart';
import 'package:nfc_app/widgets/curved_nav_bar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  late final String _uid;
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    _uid = user?.uid ?? 'defaultUid'; // Fetch UID

    // Initialize the pages after _uid is set
    _pages = [
      const HomeScreen(),
      GraphScreen(uid: _uid), // Use _uid here
      const ActiveProductScreen(),
      const CardDetails(),
      const Settings(),
    ];
  }

  void _onItemTapped(int index) {
    // if (!mounted) return;

    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: const Color(0xFFEFEFEF),

          body: _pages[_selectedIndex], // Display the selected page
          bottomNavigationBar: CustomCurvedNavigationBar(
            initialIndex: _selectedIndex,
            onTap: (index) {
              _onItemTapped(index);
            },
          ),
        ),
      ),
    );
  }
}
