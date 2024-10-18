// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nfc_app/models/order_model.dart';

class OrderProvider with ChangeNotifier {
  OrderModel? _currentOrder;
  OrderModel? get currentOrder => _currentOrder;
  bool isLoading = false;

  Future<void> placeOrder(OrderModel order) async {
    isLoading = true;
    notifyListeners();
    try {
      await FirebaseFirestore.instance
          .collection("orders")
          .doc(order.orderId)
          .set(order.toFirestore());
      _currentOrder = order;
      notifyListeners();
    } catch (e) {
      print('Failed to place order: $e');
    }
    isLoading = false;
    notifyListeners();
  }
}
