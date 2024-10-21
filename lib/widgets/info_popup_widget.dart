// lib/widgets/info_dialog.dart

import 'package:flutter/material.dart';

class InfoPopUp extends StatelessWidget {
  final String title;
  final String content;

  const InfoPopUp({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          child: const Text('Close'),
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
        ),
      ],
    );
  }

  // Function to show the dialog
  static void showInfoDialog(
      BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return InfoPopUp(title: title, content: content);
      },
    );
  }
}
