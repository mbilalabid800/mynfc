import 'package:flutter/material.dart';

class GlobalBackButtonHandler extends StatelessWidget {
  final Widget child;

  const GlobalBackButtonHandler({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return; // Do nothing if already popped
        debugPrint("Back button press ignored!");
      }, // Disable back button globally
      child: child,
    );
  }
}
