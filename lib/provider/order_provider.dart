// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nfc_app/models/order_model.dart';

class OrderProvider with ChangeNotifier {
  OrderModel? _currentOrder;
  OrderModel? get currentOrder => _currentOrder;
  bool isLoading = false;
  // List to store fetched orders
  List<OrderModel> _orders = [];
  List<OrderModel> get orders => _orders;

  Future<void> placeOrder(OrderModel order) async {
    isLoading = true;
    notifyListeners();
    try {
      if (order.cardQuantity == 1) {
        await FirebaseFirestore.instance
            .collection("orders")
            .doc('Individual')
            .collection("orders")
            .doc(order.orderId)
            .set(order.toFirestore());
      } else {
        await FirebaseFirestore.instance
            .collection("orders")
            .doc('Business')
            .collection("orders")
            .doc(order.orderId)
            .set(order.toFirestore());
      }
      _currentOrder = order;
      notifyListeners();
    } catch (e) {
      print('Failed to place order: $e');
    }
    isLoading = false;
    notifyListeners();
  }

  // Fetch all orders from Firestore
  Future<void> fetchOrders() async {
    isLoading = true;
    //notifyListeners();
    try {
// Get the current user's UID
      String? userUid = FirebaseAuth.instance.currentUser?.uid;

      // Ensure user is logged in
      if (userUid == null) {
        print('User is not logged in');
        isLoading = false;
        notifyListeners();
        return;
      }

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('orders')
          .where('userUid', isEqualTo: userUid)
          .get();

      _orders = querySnapshot.docs.map((doc) {
        return OrderModel.fromFirestore(doc.data() as Map<String, dynamic>);
      }).toList();

      print("$orders is this ");

      //notifyListeners();
    } catch (e) {
      print('Failed to fetch orders: $e');
    }
    isLoading = false;
    notifyListeners();
  }
}
