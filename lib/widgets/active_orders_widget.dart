import 'package:flutter/material.dart';

class ActiveOrdersWidget extends StatefulWidget {
  const ActiveOrdersWidget({super.key});

  @override
  State<ActiveOrdersWidget> createState() => _ActiveOrdersWidgetState();
}

class _ActiveOrdersWidgetState extends State<ActiveOrdersWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.pink,
        ),
        child: Column(
          children: [
            Text('XYZ'),
            Text('XYZ'),
            Text('XYZ'),
            Text('XYZ'),
            Text('XYZ'),
            Text('XYZ'),
            Text('XYZ'),
            Text('XYZ'),
            Text('XYZ'),
            Text('XYZ'),
            Text('XYZ'),
            Text('XYZ'),
            Text('XYZ'),
            Text('XYZ'),
            Text('XYZ'),
          ],
        ));
  }
}
