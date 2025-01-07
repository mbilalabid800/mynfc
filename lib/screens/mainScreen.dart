// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:nfc_app/constants/appColors.dart';
import 'package:nfc_app/provider/loading_state_provider.dart';
import 'package:provider/provider.dart';
import 'package:nfc_app/chat/chat_screen.dart';
import 'package:nfc_app/screens/active_product_screen.dart';
import 'package:nfc_app/screens/graph_screens/graph_screen.dart';
import 'package:nfc_app/screens/home_screen.dart';
import 'package:nfc_app/screens/settings_screen.dart';
import 'package:nfc_app/shared/common_widgets/curved_nav_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LoadingStateProvider>(context);
    final user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid ?? '';

    final pages = [
      const HomeScreen(),
      GraphScreen(uid: uid),
      const ActiveProductScreen(),
      const ChatScreen(),
      const Settings(),
    ];

    return Scaffold(
      backgroundColor: AppColors.screenBackground,
      body: pages[provider.selectedIndex],
      bottomNavigationBar: CustomCurvedNavigationBar(
        initialIndex: provider.selectedIndex,
        onTap: provider.setIndex,
      ),
    );
  }
}
