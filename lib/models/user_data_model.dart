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
  bool isPrivate;
  final Timestamp timeStamp;
  bool connectionTypeAll;
  bool isCardOrdered;
  bool isBlocked;
  // bool isEmailVerified;
  int viewCount;

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
    required this.isPrivate,
    required this.timeStamp,
    required this.connectionTypeAll,
    this.isCardOrdered = false,
    this.isBlocked = false,
    // this.isEmailVerified = false,
    this.viewCount = 0,
  });

  factory UserDataModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserDataModel(
      countryName: data['countryName'] ?? '',
      email: data['email'] ?? '',
      uid: data['uid'] ?? '',
      contactNumber: data['contact'] ?? '',
      city: data['city'] ?? 'Muscat',
      firstName: data['first_name'] ?? '',
      lastName: data['last_name'] ?? '',
      businessType: data['profile_type'] ?? '',
      companyName: data['company_name'] ?? '',
      designation: data['designation'] ?? '',
      website: data['website_link'] ?? '',
      profileImage: data['image_url'] ?? '',
      bio: data['bio'] ?? '',
      isPrivate: data['isPrivate'],
      timeStamp: data['timeStamp'] ?? '',
      connectionTypeAll: data['connectionTypeAll'],
      isBlocked: data['isBlocked'] ?? false,
      // isEmailVerified: data['isEmailVerified'] ?? false,
      viewCount: data['viewCount'] ?? 0,
      isCardOrdered: data['isCardOrdered'] ?? false,
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
      'isPrivate': isPrivate,
      'timeStamp': timeStamp,
      'connectionTypeAll': connectionTypeAll,
      'isBlocked': isBlocked,
      // 'isEmailVerified': isEmailVerified,
      'viewCount': viewCount,
      'isCardOrdered': isCardOrdered,
    };
  }
}

class ChartsDataModel {
  int totalViews;

  ChartsDataModel({
    this.totalViews = 0,
  });

  factory ChartsDataModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ChartsDataModel(
      totalViews: data['totalViews'] ?? 0,
    );
  }
  Map<String, dynamic> toMap() {
    return {'totalViews': totalViews};
  }
}
