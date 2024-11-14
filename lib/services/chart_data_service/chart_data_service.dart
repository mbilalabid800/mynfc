import 'package:cloud_firestore/cloud_firestore.dart';

class ChartDataService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addChartData(double value) async {
    print("addChartData called with value: $value"); // Debug log
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      await firestore.collection('chartData').add({
        'timestamp': FieldValue.serverTimestamp(),
        'value': value,
      });
      print("Data added successfully"); // Confirmation log
    } catch (e) {
      print("Failed to add data: $e"); // Error log
    }
  }

  Stream<List<Map<String, dynamic>>> getChartData() {
    return _db
        .collection('chartData')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }
}
