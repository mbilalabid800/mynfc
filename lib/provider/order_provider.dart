// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nfc_app/models/order_model.dart';

class OrderProvider with ChangeNotifier {
  OrderModel? _currentOrder;
  OrderModel? get currentOrder => _currentOrder;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool isLoading = false;
  // bool _isNfcCardOrdered = false;

  // List to store fetched orders

  List<OrderModel> _orders = [];
  List<OrderModel> get orders => _orders;
  // bool get isNfcCardOrdered => _isNfcCardOrdered;

  // void setOrderStatus(bool status) {
  //   _isNfcCardOrdered = status;
  //   notifyListeners();
  // }
// Setter to update selectedPlan

  void setLoading(bool value) {
    isLoading = value;
    notifyListeners(); // ✅ Notify UI about the state change
  }

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
      debugPrint('Failed to place order: $e');
    }
    isLoading = false;
    notifyListeners();
  }
  // Future<void> placeOrder(OrderModel order) async {
  //   isLoading = true;
  //   notifyListeners();
  //   try {
  //     if (order.cardQuantity == 1) {
  //       await FirebaseFirestore.instance
  //           .collection("orders")
  //           .doc('Individual')
  //           .collection("individual_orders")
  //           .doc(order.orderId)
  //           .set(order.toFirestore());
  //     } else {
  //       await FirebaseFirestore.instance
  //           .collection("orders")
  //           .doc('Business')
  //           .collection("business_orders")
  //           .doc(order.orderId)
  //           .set(order.toFirestore());
  //     }
  //     _currentOrder = order;
  //     notifyListeners();
  //   } catch (e) {
  //     debugPrint('Failed to place order: $e');
  //   }
  //   isLoading = false;
  //   notifyListeners();
  // }

  // // Fetch all orders from Firestore
  // Future<void> fetchOrders() async {
  //   isLoading = true;
  //   notifyListeners();
  //   try {
  //   // Get the current user's UID
  //     String? userUid = FirebaseAuth.instance.currentUser?.uid;

  //     QuerySnapshot querySnapshot = await FirebaseFirestore.instance
  //         .collection('orders')
  //         .where('userUid', isEqualTo: userUid)
  //         .get();

  //     _orders = querySnapshot.docs.map((doc) {
  //       return OrderModel.fromFirestore(doc.data() as Map<String, dynamic>);
  //     }).toList();

  //     debugPrint("$orders is this ");

  //     //notifyListeners();
  //   } catch (e) {
  //     debugPrint('Failed to fetch orders: $e');
  //   }
  //   isLoading = false;
  //   notifyListeners();
  // }

  Future<void> fetchOrders() async {
    isLoading = true;
    notifyListeners();

    try {
      //Get the current user's UID
      String? userUid = FirebaseAuth.instance.currentUser?.uid;

      if (userUid == null) {
        debugPrint('User UID is null. Please ensure the user is logged in.');
        return;
      }
      //Fetch orders from firestore
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('orders')
          .where('userUid', isEqualTo: userUid)
          .get();

      _orders = querySnapshot.docs.map((doc) {
        return OrderModel.fromFirestore(doc.data() as Map<String, dynamic>);
      }).toList();

      debugPrint('Fetched ${_orders.length} orders: $_orders');
    } catch (e) {
      debugPrint('Failed to fetch orders: $e');
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> fetchOrderById(String? id) async {
    isLoading = true;
    notifyListeners();
    try {
      DocumentSnapshot doc =
          await FirebaseFirestore.instance.collection("orders").doc(id).get();
      if (doc.exists) {
        _currentOrder =
            OrderModel.fromFirestore(doc.data() as Map<String, dynamic>);
      } else {
        debugPrint("Order not found");
        _currentOrder = null;
      }
    } catch (e) {
      debugPrint("Failed to fetch order by ID: $e");
    }
    isLoading = false;
    notifyListeners();
  }

  Future<String> generateOrderId() async {
    setLoading(true); // ✅ Ensure loader starts
    final DocumentReference counterRef =
        _firestore.collection('metadata').doc('orderCounter');

    try {
      return await _firestore.runTransaction((transaction) async {
        DocumentSnapshot counterSnapshot = await transaction.get(counterRef);

        int newOrderNumber = 1;

        if (counterSnapshot.exists && counterSnapshot.data() != null) {
          var lastOrderNumber = counterSnapshot.get('lastOrderNumber');

          if (lastOrderNumber is int) {
            newOrderNumber = lastOrderNumber + 1;
          } else if (lastOrderNumber is String) {
            newOrderNumber = int.tryParse(lastOrderNumber) ?? 1;
          }
        }

        String newOrderId = "ABS#${newOrderNumber.toString().padLeft(6, '0')}";
        transaction.set(counterRef, {'lastOrderNumber': newOrderNumber});

        return newOrderId;
      });
    } catch (error) {
      throw Exception("Failed to generate order ID: $error");
    } finally {
      setLoading(false); // ✅ Stop loader
    }
  }
}
