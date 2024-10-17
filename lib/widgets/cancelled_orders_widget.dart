import 'package:flutter/material.dart';

class CancelledOrdersWidget extends StatefulWidget {
  const CancelledOrdersWidget({super.key});

  @override
  State<CancelledOrdersWidget> createState() => _CancelledOrdersWidgetState();
}

class _CancelledOrdersWidgetState extends State<CancelledOrdersWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.red,
      ),
    );
  }
}
