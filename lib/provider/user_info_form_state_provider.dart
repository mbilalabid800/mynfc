// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nfc_app/models/user_data_model.dart';
import 'package:nfc_app/services/shared_preferences_service/shared_preferences_services.dart';

class UserInfoFormStateProvider extends ChangeNotifier {
  String _firstName = '';
  String _lastName = '';
  String _countryName = '';
  String _email = '';
  String _uid = '';
  String _contact = '';
  String _countryCode = '';
  String _city = '';
  String? _selectedItem;
  String _companyName = '';
  String _designation = '';
  String _websiteLink = '';
  String? _imageUrl;
  String _bio = '';
  int _profileViews = 0;
  String _currentEditingField = '';

  int _connectionType = 0;
  bool _isBlocked = false;

  // Getters
  String get firstName => _firstName;
  String get lastName => _lastName;
  String get contact => _contact;
  String get countryCode => _countryCode;
  int get connectionType => _connectionType;
  String get countryName => _countryName;
  String get email => _email;
  String get uid => _uid;
  String get city => _city;
  String? get selectedItem => _selectedItem;
  String get companyName => _companyName;
  String get designation => _designation;
  String get websiteLink => _websiteLink;
  String? get imageUrl => _imageUrl;
  String get bio => _bio;
  int get profileViews => _profileViews;
  bool get isBlocked => _isBlocked;
  String get currentEditingField => _currentEditingField;

  bool get isNameFormValid =>
      _firstName.isNotEmpty && _lastName.isNotEmpty && _contact.isNotEmpty;
  bool get isCompanyInfoFormValid =>
      _selectedItem != null &&
      _companyName.isNotEmpty &&
      _designation.isNotEmpty &&
      _websiteLink.isNotEmpty;

  void updateSelectedItem(String? selectedItem) {
    _selectedItem = selectedItem;
    notifyListeners();
  }

  void updateFirstName(String firstName) {
    _firstName = firstName;
    notifyListeners();
  }

  void updateLastName(String lastName) {
    _lastName = lastName;
    notifyListeners();
  }

  void updateCountryName(String countryName) {
    _countryName = countryName;
    notifyListeners();
  }

  void setEmail(String email) {
    _email = email;
    notifyListeners(); // Notify listeners to rebuild widgets that use this email
  }

  void updateContact(String contact, String countryCode) {
    _contact = '$countryCode $contact';

    notifyListeners();
  }

  void updateCity(String city) {
    _city = city;
    notifyListeners();
  }

  void updateCompanyName(String companyName) {
    _companyName = companyName;
    notifyListeners();
  }

  void updateDesignation(String designation) {
    _designation = designation;
    notifyListeners();
  }

  void updateWebsiteLink(String websiteLink) {
    _websiteLink = websiteLink;
    notifyListeners();
  }

  void updateConnectionType(int connectionType) {
    _connectionType = connectionType;
    notifyListeners();
  }

  void updateImageUrl(String? imageUrl) {
    _imageUrl = imageUrl;
    notifyListeners();
  }

  void updateBio(String bio) {
    _bio = bio;
    notifyListeners();
  }

  void updateProfileViews(int views) {
    _profileViews = views;
    notifyListeners();
  }

  void setEditingField(String fieldKey) {
    _currentEditingField = fieldKey;
    notifyListeners();
  }

  void clearEditingField() {
    _currentEditingField = '';
    notifyListeners();
  }

  Future<void> saveUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    SharedPreferencesServices prefsService = SharedPreferencesServices();
    String? email = await prefsService.getEmail();
    if (user != null) {
      final uid = user.uid;
      // print(uid);

      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('userProfile')
            .doc('details')
            .set({
          'uid': uid,
          'first_name': _firstName,
          'last_name': _lastName,
          'contact': _contact,
          'countryName': _countryName,
          'email': email,
          'city': _city,
          'company_name': _companyName,
          'designation': _designation,
          'website_link': _websiteLink,
          'image_url': _imageUrl,
          'profile_type': _selectedItem,
          'bio': _bio,
          'timeStamp': DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
          'profileViews': _profileViews,
          'connection_type': _connectionType,
          'isBlocked': _isBlocked,
        });

        // Second action: Save user's email in the main 'users' collection
        await FirebaseFirestore.instance.collection('users').doc(uid).set(
          {
            'email': email,
          },
          SetOptions(merge: true),
        ); // Use merge to avoid overwriting the entire document

        print("User data saved successfully.");
      } catch (e) {
        print("Error saving user data: $e");
        //ScaffoldMessenger.of(context).showSnackBar(
        //  const SnackBar(content: Text('Error saving user data')),
        //);
      }

      //
    }
  }

  Future<void> updateUserData() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final uid = user.uid;

      try {
        print("Updating user data for userId: $uid");
        print("lastName is $_lastName");
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('userProfile')
            .doc('details')
            .update({
          'image_url': _imageUrl,
          'first_name': _firstName,
          'last_name': _lastName,
          'company_name': _companyName,
          'designation': _designation,
          'bio': _bio,
          'countryName': _countryName,
        });

        print("User data updated successfully.");
      } catch (e) {
        print("Error updating user data: $e");
      }
      notifyListeners();
    }
  }

  Future<void> loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final uid = user.uid;
      try {
        DocumentReference<Map<String, dynamic>> docRef = FirebaseFirestore
            .instance
            .collection("users")
            .doc(uid)
            .collection("userProfile")
            .doc("details");
        DocumentSnapshot<Map<String, dynamic>> docSnapshot = await docRef.get();
        if (docSnapshot.exists) {
          final userData = UserDataModel.fromFirestore(docSnapshot);
          _firstName = userData.firstName;
          _lastName = userData.lastName;
          _email = userData.email;
          _uid = userData.uid;
          _city = userData.city;
          _companyName = userData.companyName;
          _designation = userData.designation;
          _websiteLink = userData.website;
          _imageUrl = userData.profileImage;
          _contact = userData.contactNumber;
          _selectedItem = userData.businessType;
          _countryName = userData.countryName;
          _bio = userData.bio;
          _profileViews = userData.profileViews;
          _isBlocked = userData.isBlocked;

          notifyListeners();
        }
      } catch (e) {
        print("Error loading user data: $e");
      }
    }
  }

  void clear() {
    _firstName = '';
    _lastName = '';
    _countryName = '';
    _email = '';
    _uid = '';
    _contact = '';
    _countryCode = '';
    _city = '';
    _selectedItem = null;
    _companyName = '';
    _designation = '';
    _websiteLink = '';
    _imageUrl = null;
    _bio = '';

    notifyListeners();
  }
}
