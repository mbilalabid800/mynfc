import 'package:flutter/material.dart';
import 'package:nfc_app/widgets/custom_app_bar_widget.dart';

class AnotherScreen extends StatelessWidget {
  const AnotherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(appBar: CustomAppBar(title: 'New Screen'));
  }
}
