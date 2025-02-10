import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nfc_app/models/messages_model.dart';

class ChatProvider with ChangeNotifier {
  final List<Message> _messages = [];

  List<Message> get messages => _messages;

  void listenForMessages(String chatRoomId, String currentUserId) {
    FirebaseFirestore.instance
        .collection('chats')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen((snapshot) {
      messages.clear();
      for (var doc in snapshot.docs) {
        messages.add(
            Message.fromMap(doc.data() as Map<String, dynamic>, currentUserId));
      }
      notifyListeners();
    });
  }

  // Send message to Firebase
  void sendMessage(String chatRoomId, String messageText, String senderId) {
    final message = {
      'text': messageText,
      'timestamp': Timestamp.now(),
      'senderId': senderId,
      'isRead': false,
    };

    FirebaseFirestore.instance
        .collection('chats')
        .doc(chatRoomId)
        .collection('messages')
        .add(message);
  }

  //Fetch messages from Firebase
  Stream<List<Message>> fetchMessages(String chatRoomId, String currentUserId) {
    return FirebaseFirestore.instance
        .collection('chats')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Message.fromMap(doc.data(), currentUserId);
      }).toList();
    });
  }
}
