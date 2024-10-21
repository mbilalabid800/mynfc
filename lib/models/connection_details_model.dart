import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nfc_app/models/social_app_model.dart';

class ConnectionDetailsModel {
  String countryName;
  String email;
  String uid;
  String contactNumber;
  String address;
  String firstName;
  String lastName;
  String businessType;
  String companyName;
  String designation;
  String website;
  String profileImage;
  List<SocialAppModel>? socialApps;

  ConnectionDetailsModel({
    required this.countryName,
    required this.email,
    required this.uid,
    required this.contactNumber,
    required this.address,
    required this.firstName,
    required this.lastName,
    required this.businessType,
    required this.companyName,
    required this.designation,
    required this.website,
    required this.profileImage,
    this.socialApps,
  });

  factory ConnectionDetailsModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ConnectionDetailsModel(
      countryName: data['countryName'] ?? '',
      email: data['email'] ?? '',
      uid: data['uid'] ?? '',
      contactNumber: data['contact'] ?? '',
      address: data['address'] ?? '',
      firstName: data['first_name'] ?? '',
      lastName: data['last_name'] ?? '',
      businessType: data['profile_type'] ?? '',
      companyName: data['company_name'] ?? '',
      designation: data['designation'] ?? '',
      website: data['website_link'] ?? '',
      profileImage: data['image_url'] ?? '',
      socialApps: (data['social_apps'] as List<dynamic>?)
              ?.map((app) =>
                  SocialAppModel.fromFirestore(app as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  ConnectionDetailsModel copyWith({List<SocialAppModel>? socialApps}) {
    return ConnectionDetailsModel(
      countryName: countryName,
      email: email,
      uid: uid,
      contactNumber: contactNumber,
      address: address,
      firstName: firstName,
      lastName: lastName,
      businessType: businessType,
      companyName: companyName,
      designation: designation,
      website: website,
      profileImage: profileImage,
      socialApps: socialApps ?? this.socialApps,
    );
  }
}
