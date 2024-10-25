// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nfc_app/models/order_model.dart';

class OrderProvider with ChangeNotifier {
  OrderModel? _currentOrder;
  OrderModel? get currentOrder => _currentOrder;
  bool isLoading = false;
  List<OrderModel> _userOrders = [];
  List<OrderModel> get userOrders => _userOrders;

  // Place an order in Firestore
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

  Future<void> fetchOrders(String uid) async {
    isLoading = true;
    notifyListeners();
    try {
      print("Fetching orders from Firestore for UID: $uid");

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('orders')
          .get(); // Get all orders

      if (querySnapshot.docs.isEmpty) {
        print("No orders found.");
        _userOrders = []; // Set to empty if no orders
      } else {
        print("${querySnapshot.docs.length} orders found.");

        // Filter orders by matching uid
        _userOrders = querySnapshot.docs
            .map((doc) {
              final data = doc.data() as Map<String, dynamic>; // Cast to Map
              print("Order ID: ${doc.id}, Data: $data");

              // Match the uid
              if (data['userUid'] == uid) {
                print("Match found for order ID: ${doc.id}");
                return OrderModel.fromFirestore(
                    data); // Only add matching orders
              } else {
                print("Mismatch for order ID: ${doc.id}");
                return null; // Return null for mismatches
              }
            })
            .whereType<OrderModel>()
            .toList(); // Filter out nulls

        if (_userOrders.isEmpty) {
          print("No matching orders found for UID: $uid");
        } else {
          print("${_userOrders.length} matching orders found for UID: $uid");
        }
      }

      notifyListeners();
    } catch (e) {
      print('Failed to fetch orders: $e');
    }

    isLoading = false;
    notifyListeners();
  }
}
