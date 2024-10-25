import 'package:cloud_firestore/cloud_firestore.dart';

class ShippingAddressModel {
  String firstName;
  String lastName;
  String locationName;
  String? company; // Optional
  String phone;
  String country;
  String streetAddress;
  String? apartment; // Optional
  String city;
  String state;
  String zipCode;
  bool selected;

  ShippingAddressModel({
    required this.firstName,
    required this.lastName,
    required this.locationName,
    this.company,
    required this.phone,
    required this.country,
    required this.streetAddress,
    this.apartment,
    required this.city,
    required this.state,
    required this.zipCode,
    this.selected = false,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'locationName': locationName,
      'company': company,
      'phone': phone,
      'country': country,
      'streetAddress': streetAddress,
      'apartment': apartment,
      'city': city,
      'state': state,
      'zipCode': zipCode,
      'selected': selected,
    };
  }

  factory ShippingAddressModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> json = doc.data() as Map<String, dynamic>;
    return ShippingAddressModel(
      firstName: json['firstName'],
      lastName: json['lastName'],
      locationName: json['locationName'],
      company: json['company'],
      phone: json['phone'],
      country: json['country'],
      streetAddress: json['streetAddress'],
      apartment: json['apartment'],
      city: json['city'],
      state: json['state'],
      zipCode: json['zipCode'],
      selected: json['selected'] ?? false,
    );
  }
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true; // Check if the objects are the same
    }
    if (runtimeType != other.runtimeType) return false;
    final ShippingAddressModel otherAddress = other as ShippingAddressModel;
    return locationName ==
        otherAddress.locationName; // Unique field for comparison
  }

  // Override hashCode
  @override
  int get hashCode =>
      locationName.hashCode; // Use a unique field for the hashCode
}
