import 'package:cloud_firestore/cloud_firestore.dart';

class ConnectionsModel {
  String uid;
  String profileImage;
  String firstName;
  String lastName;
  String designation;
  String companyName;
  Timestamp timestamp;
  bool isRequested;
  bool isAccepted;

  ConnectionsModel({
    required this.uid,
    required this.profileImage,
    required this.firstName,
    required this.lastName,
    required this.designation,
    required this.companyName,
    required this.timestamp,
    this.isRequested = false,
    this.isAccepted = false,
  });

  factory ConnectionsModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ConnectionsModel(
      uid: data['uid'] ?? '',
      profileImage: data['image_url'] ?? '',
      firstName: data['first_name'] ?? '',
      lastName: data['last_name'] ?? '',
      designation: data['designation'] ?? '',
      companyName: data['company_name'] ?? '',
      timestamp: data['timestamp'] ?? Timestamp.now(),
      isRequested: data['isRequested'] ?? false,
      isAccepted: data['isAccepted'] ?? false,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'image_url': profileImage,
      'first_name': firstName,
      'last_name': lastName,
      'designation': designation,
      'company_name': companyName,
      'timestamp': timestamp,
      'isRequested': isRequested,
      'isAccepted': isAccepted,
    };
  }
}
