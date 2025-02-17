import 'package:cloud_firestore/cloud_firestore.dart';

Future<String> generateOrderId() async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final CollectionReference orders = firestore.collection('orders');

  // Get the latest order ID
  QuerySnapshot querySnapshot =
      await orders.orderBy('orderId', descending: true).limit(1).get();

  int newOrderNumber = 0; // Default if no orders exist

  if (querySnapshot.docs.isNotEmpty) {
    String lastOrderId = querySnapshot.docs.first['orderId'];
    newOrderNumber = int.parse(lastOrderId.replaceAll(RegExp(r'\D'), '')) + 1;
  }

  // Format order ID (e.g., ABS#000001)
  String newOrderId = "ABS#${newOrderNumber.toString().padLeft(6, '0')}";

  return newOrderId;
}
