import 'package:cloud_firestore/cloud_firestore.dart';

Future<String> generateOrderId() async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final DocumentReference counterRef =
      firestore.collection('metadata').doc('orderCounter');

  return await firestore.runTransaction((transaction) async {
    DocumentSnapshot counterSnapshot = await transaction.get(counterRef);

    int newOrderNumber = 1; // Default if no orders exist

    if (counterSnapshot.exists && counterSnapshot.data() != null) {
      var lastOrderNumber = counterSnapshot.get('lastOrderNumber');

      if (lastOrderNumber is int) {
        newOrderNumber = lastOrderNumber + 1;
      } else if (lastOrderNumber is String) {
        newOrderNumber = int.tryParse(lastOrderNumber) ?? 1;
      }
    }

    // ✅ Ensure orderId is always a STRING
    String newOrderId = "ABS#${newOrderNumber.toString().padLeft(6, '0')}";

    // ✅ Update the counter as an INTEGER
    transaction.set(counterRef, {'lastOrderNumber': newOrderNumber});

    return newOrderId;
  }).catchError((error) {
    throw Exception("Failed to generate order ID: $error");
  });
}
