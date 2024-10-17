import 'package:flutter/material.dart';

class CompletedOrdersWidget extends StatefulWidget {
  const CompletedOrdersWidget({super.key});

  @override
  State<CompletedOrdersWidget> createState() => _CompletedOrdersWidgetState();
}

class _CompletedOrdersWidgetState extends State<CompletedOrdersWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.green,
      ),
    );
  }
}
