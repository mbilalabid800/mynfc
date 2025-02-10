import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String text;
  final DateTime timestamp;
  final String senderId;
  final bool isRead;
  final bool isSender;

  Message(
      {required this.text,
      required this.timestamp,
      required this.senderId,
      required this.isRead,
      required this.isSender});
  // ✅ Convert Firestore document to Message object
  factory Message.fromMap(Map<String, dynamic> map, String currentUserId) {
    return Message(
        text: map['text'] ?? '',
        timestamp: (map['timestamp'] as Timestamp).toDate(),
        senderId: map['senderId'] ?? '',
        isRead: map['isRead'] ?? false,
        isSender: map['senderId'] == currentUserId);
  }

  // Optional: Convert Message object back to Map (for sending)
  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'timestamp': timestamp,
      'senderId': senderId,
      'isRead': isRead,
    };
  }
}
