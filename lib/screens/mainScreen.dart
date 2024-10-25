// ignore_for_file: file_names

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
  final List<Widget> _pages = [
    const HomeScreen(), // Contains UI for Home
    const GraphScreen(), // Contains UI for Category
    const ActiveProductScreen(), // Contains UI for Add
    const CardDetails(), // Contains UI for Category
    const Settings(), // Contains UI for Settings
  ];
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
