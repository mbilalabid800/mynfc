import 'package:flutter/material.dart';
import 'package:nfc_app/constants/appColors.dart';
import 'package:nfc_app/widgets/custom_app_bar_widget.dart';

class OrderDetails extends StatefulWidget {
  const OrderDetails({super.key});

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenBackground,
      appBar: const CustomAppBar(title: "Order Details"),
      body: Container(
        decoration: const BoxDecoration(color: Colors.white),
        child: const Column(
          children: [],
        ),
      ),
    );
  }
}
