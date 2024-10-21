import 'package:cloud_firestore/cloud_firestore.dart';

class UserDataModel {
  String countryName;
  String email;
  String uid;
  String contactNumber;
  String city;
  String firstName;
  String lastName;
  String businessType;
  String companyName;
  String designation;
  String website;
  String profileImage;
  String bio;
  // String connectionType;

  UserDataModel({
    required this.countryName,
    required this.email,
    required this.uid,
    required this.contactNumber,
    required this.city,
    required this.firstName,
    required this.lastName,
    required this.businessType,
    required this.companyName,
    required this.designation,
    required this.website,
    required this.profileImage,
    required this.bio,
    // required this.connectionType,
  });

  factory UserDataModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserDataModel(
      countryName: data['countryName'] ?? '',
      email: data['email'] ?? '',
      uid: data['uid'] ?? '',
      contactNumber: data['contact'] ?? '',
      city: data['city'] ?? '',
      firstName: data['first_name'] ?? '',
      lastName: data['last_name'] ?? '',
      businessType: data['profile_type'] ?? '',
      companyName: data['company_name'] ?? '',
      designation: data['designation'] ?? '',
      website: data['website_link'] ?? '',
      profileImage: data['image_url'] ?? '',
      bio: data['bio'] ?? '',
      // connectionType: data['connection_type'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'username': countryName,
      'email': email,
      'uid': uid,
      'contactNumber': contactNumber,
      'city': city,
      'first_name': firstName,
      'last_name': lastName,
      'businessType': businessType,
      'company_name': companyName,
      'designation': designation,
      'website_link': website,
      'image_url': profileImage,
      'bio': bio,
      // 'connection_type': connectionType,
    };
  }
}
