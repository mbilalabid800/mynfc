// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nfc_app/models/user_data_model.dart';
import 'package:nfc_app/services/validation_service.dart';
import '../services/shared_preferences_service/shared_preferences_services.dart';

class UserInfoFormStateProvider extends ChangeNotifier {
  String _firstName = '';
  String _lastName = '';
  String _countryName = '';
  String _email = '';
  String _uid = '';
  String _contact = '';
  String _countryCode = '';
  String _city = '';
  String _profileType = '';
  String _companyName = '';
  String _designation = '';
  String _websiteLink = '';
  String _imageUrl = '';
  String _bio = '';
  // int _profileViews = 0;
  String _currentEditingField = '';
  String? _firstNameError;
  String? _lastNameError;
  String? _contactError;
  String? _websiteLinkError;
  String? _companyNameError;
  String? _designationError;
  String? _cityNameError;
  int _totalViews = 0;
  String _websiteError = "";

  bool _isPrivate = false;
  bool _connectionTypeAll = true;
  bool _isBlocked = false;
  final _subscriptionPlan = '';
  bool _isCardOrdered = false;
  bool _isFileUploaded = false;
  // String? _planName;

  // Getters
  String get firstName => _firstName;
  String get lastName => _lastName;
  String get contact => _contact;
  String get websiteError => _websiteError;
  String get countryCode => _countryCode;
  bool get connectionTypeAll => _connectionTypeAll;
  String get countryName => _countryName;
  String get email => _email;
  String get uid => _uid;
  String get city => _city;
  String get profileType => _profileType;
  String get companyName => _companyName;
  String get designation => _designation;
  String get websiteLink => _websiteLink;
  String get imageUrl => _imageUrl;
  String get bio => _bio;
  bool get isPrivate => _isPrivate;
  bool get isBlocked => _isBlocked;
  bool get isCardOrdered => _isCardOrdered;
  bool get isFileUploaded => _isFileUploaded;
  String get currentEditingField => _currentEditingField;
  String? get firstNameError => _firstNameError;
  String? get lastNameError => _lastNameError;
  String? get contactError => _contactError;
  String? get websiteLinkError => _websiteLinkError;
  String? get companyNameError => _companyNameError;
  String? get designationError => _designationError;
  String? get cityNameError => _cityNameError;
  int get totalViews => _totalViews;
  // String? get planName => planName;

  String? get subscriptionPlan => _subscriptionPlan;

  bool get isNameFormValid =>
      _firstName.isNotEmpty &&
      _lastName.isNotEmpty &&
      _contact.isNotEmpty &&
      _countryCode.isNotEmpty &&
      _countryName.isNotEmpty &&
      _firstNameError == null &&
      _lastNameError == null &&
      _contactError == null;

  bool get isCompanyInfoFormValid =>
      _profileType.isNotEmpty &&
      _companyName.isNotEmpty &&
      _designation.isNotEmpty &&
      _websiteLink.isNotEmpty &&
      _websiteLinkError == null &&
      _cityNameError == null &&
      _companyNameError == null &&
      _designationError == null;

  String? emailError;

  void validateEmail(String email) {
    emailError = ValidationService.validateEmail(email);
    notifyListeners();
  }

  void updateFirstName(String firstName) {
    final trimmedFirstName = firstName.trim();
    //Validation: Ensure the first name is between 2-20 chars and only contains letters
    final regex = RegExp(r'^[a-zA-Z]+(?: [a-zA-Z]+)*$');
    if (firstName.startsWith(' ')) {
      _firstNameError = 'Spaces are not allowed. Please enter a valid name.';
    } else if (trimmedFirstName.isEmpty) {
      _firstNameError = 'Enter your first name';
    } else if (trimmedFirstName.length < 2) {
      _firstNameError = 'First name must be at least 2 characters';
    } else if (trimmedFirstName.length > 25) {
      _firstNameError = 'First name must not exceed 25 characters';
    } else if (!regex.hasMatch(trimmedFirstName)) {
      _firstNameError = 'Only letters are allowed';
    } else {
      // Input is valid
      _firstNameError = null;
      _firstName = trimmedFirstName;
      notifyListeners();
      return; // Exit if update successful
    }
    //_firstName = firstName;
    notifyListeners();
  }

  void updateLastName(String lastName) {
    final trimmedLastName = lastName.trim();
    final regex = RegExp(r'^[a-zA-Z]+(?: [a-zA-Z]+)*$');
    if (lastName.startsWith(' ')) {
      _lastNameError = 'Spaces are not allowed. Please enter a valid name.';
    } else if (trimmedLastName.isEmpty) {
      _lastNameError = 'Enter your last name';
    } else if (trimmedLastName.length < 2) {
      _lastNameError = 'Last name must be at least 2 characters';
    } else if (trimmedLastName.length > 25) {
      _lastNameError = 'Last name must not exceed 25 characters';
    } else if (!regex.hasMatch(trimmedLastName)) {
      _lastNameError = 'Only letters are allowed';
    } else {
      _lastNameError = null;
      _lastName = trimmedLastName;
      notifyListeners();
      return;
    }
    notifyListeners();
  }

  void updateCountryName(String countryName) {
    _countryName = countryName;
    notifyListeners();
  }

  void updateCountryCode(String countryCode) {
    _countryCode = countryCode;
    notifyListeners();
  }

  void setEmail(String email) {
    _email = email;
    notifyListeners(); // Notify listeners to rebuild widgets that use this email
  }

  void setWebsiteError(String error) {
    _websiteError = error;
    notifyListeners();
  }

  void clearWebsiteError() {
    _websiteError = "";
    notifyListeners();
  }

  void updateContact(String contact, String countryCode, String countryName) {
    final regex = RegExp(r'^[0-9]+$'); // Regex to validate numbers

    if (contact.startsWith(' ')) {
      _contactError = 'Spaces are not allowed, Enter your phone number';
    } else if (contact.isEmpty) {
      _contactError = 'Enter your phone number';
    } else if (!regex.hasMatch(contact)) {
      _contactError = 'Contact must be numbers only';
    }
    // else if (contact.length != 8) {
    //   // Assuming phone number is 8 digits
    //   //_contactError = 'Contact must be exactly 8 digits';
    // }
    else {
      _contactError = null;
      _contact =
          '$countryCode $contact'; // Combine country code and phone number
      _countryCode = countryCode; // Store the country code
      _countryName = countryName; // Store the country name
    }
    notifyListeners();
  }

  void updateCity(String city) {
    final trimmedCityName = city.trim();
    // Validation: Ensure the first name is between 2-20 chars and only contains letters
    final regex = RegExp(r'^[a-zA-Z]+(?: [a-zA-Z]+)*$');
    if (city.startsWith(' ')) {
      _cityNameError = 'Spaces are not allowed, Enter your city name';
    } else if (trimmedCityName.isEmpty) {
      _cityNameError = 'Enter your city name';
    } else if (trimmedCityName.length < 2) {
      _cityNameError = 'City name must be at least 2 characters';
    } else if (trimmedCityName.length > 25) {
      _cityNameError = 'City name must not exceed 25 characters';
    } else if (!regex.hasMatch(trimmedCityName)) {
      _cityNameError = 'Only letters are allowed';
    } else {
      // Input is valid
      _cityNameError = null;
      _city = trimmedCityName;
      notifyListeners();
      return; // Exit if update successful
    }
    //_firstName = firstName;
    notifyListeners();
  }

  void updateCompanyName(String companyName) {
    final trimmedCompanyName = companyName.trim();
    //Validation: Ensure the first name is between 2-20 chars and only contains letters
    final regex = RegExp(r'^[a-zA-Z]+(?: [a-zA-Z]+)*$');
    if (companyName.startsWith(' ')) {
      _companyNameError = 'Spaces are not allowed, Enter your company name';
    } else if (trimmedCompanyName.isEmpty) {
      _companyNameError = 'Enter your company name';
    } else if (trimmedCompanyName.length < 2) {
      _companyNameError = 'Company name must be at least 2 characters';
    } else if (trimmedCompanyName.length > 25) {
      _companyNameError = 'Company name must not exceed 25 characters';
    } else if (!regex.hasMatch(trimmedCompanyName)) {
      _companyNameError = 'Only letters are allowed';
    } else {
      // Input is valid
      _companyNameError = null;
      _companyName = trimmedCompanyName;
      notifyListeners();
      return; // Exit if update successful
    }
    //_firstName = firstName;
    notifyListeners();
  }

  void updateDesignation(String designation) {
    final trimmedDesignation = designation.trim();
    //Validation: Ensure the first name is between 2-20 chars and only contains letters
    //final regex = RegExp(r'^[a-zA-Z]+(?: [a-zA-Z]+)*$');
    if (designation.startsWith(' ')) {
      _designationError = 'Spaces are not allowed, Enter your designation';
    } else if (trimmedDesignation.isEmpty) {
      _designationError = 'Enter your designation';
    } else if (trimmedDesignation.length < 2) {
      _designationError = 'Designation must be at least 2 characters';
    } else if (trimmedDesignation.length > 50) {
      _designationError = 'Designation must not exceed 50 characters';
    }
    // else if (!regex.hasMatch(trimmedDesignation)) {
    //   _designationError = 'Only letters are allowed';
    // }
    else {
      // Input is valid
      _designationError = null;
      _designation = trimmedDesignation;
      notifyListeners();
      return; // Exit if update successful
    }
    //_firstName = firstName;
    notifyListeners();
  }

  void updateWebsiteLink(String websiteLink) {
    final regex = RegExp(r'^(www\.)' // Require www at the start
        r'([a-zA-Z0-9\-]+\.)+[a-zA-Z]{2,10}' // Domain name
        r'(\/[a-zA-Z0-9\-_\/]*)?$'); // Optional path (note the ? at the end)

    if (!regex.hasMatch(websiteLink)) {
      _websiteLinkError = 'Enter your valid website';
    } else {
      _websiteLinkError = null; // Clear error if input is valid
      _websiteLink = websiteLink;
    }
    notifyListeners();
  }

  void updateConnectionType(bool connectionTypeAll) {
    _connectionTypeAll = connectionTypeAll;
    notifyListeners();
  }

  void updateImageUrl(String imageUrl) {
    _imageUrl = imageUrl;
    notifyListeners();
  }

  void updateBio(String bio) {
    _bio = bio;
    notifyListeners();
  }

  Future<void> updateIsPrivate(bool isPrivate) async {
    notifyListeners();
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      await FirebaseFirestore.instance.collection("users").doc(uid).update({
        'isPrivate': isPrivate ? true : false,
      });
    }
    _isPrivate = isPrivate;
    notifyListeners();
  }

  // Future<void> updateIsEmailVerified(bool isEmailVerified) async {
  //   notifyListeners();
  //   final uid = FirebaseAuth.instance.currentUser?.uid;
  //   if (uid != null) {
  //     await FirebaseFirestore.instance.collection("users").doc(uid).update({
  //       'isEmailVerified': isEmailVerified ? true : false,
  //     });
  //   }
  //   _isEmailVerified = isEmailVerified;
  //   notifyListeners();
  // }

  Future<void> updateProfileType(String profileType) async {
    notifyListeners();
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      await FirebaseFirestore.instance.collection("users").doc(uid).update({
        'profile_type': profileType,
      });
    }
    _profileType = profileType;
    notifyListeners();
  }

  void updateSelectedItem(String newValue) {
    _profileType = newValue;
    notifyListeners();
  }

  void updateProfileViews(int viewCount) {
    _totalViews = totalViews;
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

  Future<void> updateIsCardOrdered(bool isCardOrdered) async {
    notifyListeners();
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      await FirebaseFirestore.instance.collection("users").doc(uid).update({
        'isCardOrdered': isCardOrdered ? true : false,
      });
    }
    _isCardOrdered = isCardOrdered;
    notifyListeners();
  }

  Future<void> fetchFileUploadStatus() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final doc =
          await FirebaseFirestore.instance.collection("users").doc(uid).get();

      if (doc.exists) {
        final data = doc.data();
        _isFileUploaded = data != null && data.containsKey('isFileUploaded')
            ? data['isFileUploaded']
            : false;
        notifyListeners();
      }
    }
  }

  Future<void> updateFileUploadStatus(bool status) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      await FirebaseFirestore.instance.collection("users").doc(uid).update({
        'isFileUploaded': status,
      });

      _isFileUploaded = status;
      notifyListeners();
    }
  }
  // Future<void> updateIsFileUploaded(bool isFileUploaded) async {
  //   notifyListeners();
  //   final uid = FirebaseAuth.instance.currentUser?.uid;
  //   if (uid != null) {
  //     await FirebaseFirestore.instance.collection("users").doc(uid).update({
  //       'isCardOrdered': isCardOrdered ? true : false,
  //     });
  //   }
  //   _isCardOrdered = isCardOrdered;
  //   notifyListeners();
  // }

  Future<void> saveUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    SharedPreferencesServices prefsService = SharedPreferencesServices();
    String? email = await prefsService.getEmail();
    if (user != null) {
      final uid = user.uid;
      // print(uid);

      try {
        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'uid': uid,
          'first_name': _firstName,
          'last_name': _lastName,
          'contact': _contact,
          'countryName': _countryName,
          'email': (_email.isNotEmpty) ? _email : email,
          'city': _city,
          'company_name': _companyName,
          'designation': _designation,
          'website_link': _websiteLink,
          'image_url': _imageUrl,
          'profile_type': _profileType,
          'bio': _bio,
          'isFileUploaded': 'false',
          'fileUrl': '',
          'isPrivate': _isPrivate,
          'timeStamp': Timestamp.now(),
          'connectionTypeAll': _connectionTypeAll,
          'isBlocked': _isBlocked,
          // 'isEmailVerified': _isEmailVerified,
          'isCardOrdered': _isCardOrdered,
          'planName': 'Free',
        });

        // Second action: Save user's email in the main 'users' collection
        // await FirebaseFirestore.instance.collection('users').doc(uid).set(
        //   {
        //     'email': (_email.isNotEmpty) ? _email : email,
        //     'subscriptionPlan': 'Free'
        //   },
        //   SetOptions(merge: true),
        // ); // Use merge to avoid overwriting the entire document

        debugPrint("User data saved successfully.");
      } catch (e) {
        debugPrint("Error saving user data: $e");
        //ScaffoldMessenger.of(context).showSnackBar(
        //  const SnackBar(content: Text('Error saving user data')),
        //);
      }

      // Second action: Save charts Data in users> uid> chartsData
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection("chartsData")
          .doc("profileViews")
          .set({'totalViews': totalViews});

      // You can initialize with an empty list for timestamps and counts for specific social apps (if desired)
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection("chartsData")
          .doc("socialAppTaps")
          .set({
        // Initialize an empty list for timestamps
        'timestamps': [],
        // Optionally, initialize counts for specific social apps with zero

        // Add any other social app keys as needed
      });

      // Third action: create chats collection in users > uid > chats
      DocumentReference chatRoomRef = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('chats')
          .add({});

      // Optional: Print the unique chat room ID
      debugPrint("Chat room created with ID: ${chatRoomRef.id}");

      //
    }
  }

  Future<void> updateUserData() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final uid = user.uid;

      try {
        debugPrint("Updating user data for userId: $uid");
        debugPrint("lastName is $_lastName");
        await FirebaseFirestore.instance.collection('users').doc(uid).update({
          'image_url': _imageUrl,
          'first_name': _firstName,
          'last_name': _lastName,
          'company_name': _companyName,
          'designation': _designation,
          'bio': _bio,
          'website_link': _websiteLink,
        });

        debugPrint("User data updated successfully.");
      } catch (e) {
        debugPrint("Error updating user data: $e");
      }
      notifyListeners();
    }
  }

  Future<void> loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final uid = user.uid;
      try {
        DocumentReference<Map<String, dynamic>> docRef =
            FirebaseFirestore.instance.collection("users").doc(uid);

        DocumentSnapshot<Map<String, dynamic>> docSnapshot = await docRef.get();
        debugPrint("Here is :$docSnapshot");
        if (docSnapshot.exists) {
          debugPrint("Here is :$docSnapshot");

          final userData = UserDataModel.fromFirestore(docSnapshot);
          _firstName = userData.firstName;
          _lastName = userData.lastName;
          _email = userData.email;
          _uid = userData.uid;
          _city = userData.city.isEmpty ? '' : userData.city;
          _companyName =
              userData.companyName.isEmpty ? '' : userData.companyName;
          _designation =
              userData.designation.isEmpty ? '' : userData.designation;
          _connectionTypeAll = userData.connectionTypeAll;
          _websiteLink =
              userData.website.isEmpty ? 'www.sahab.com' : userData.website;
          _imageUrl =
              userData.profileImage.isEmpty ? '' : userData.profileImage;
          _contact = userData.contactNumber;
          _profileType = userData.businessType;
          _countryName =
              userData.countryName.isEmpty ? '' : userData.countryName;
          _bio =
              userData.bio.isEmpty ? 'Write about yourself ...' : userData.bio;
          _isPrivate = userData.isPrivate;
          // _isEmailVerified = userData.isEmailVerified;
          _isCardOrdered = userData.isCardOrdered;
          // _profileViews = userData.profileViews;
          _isBlocked = userData.isBlocked;

          notifyListeners();
        }
      } catch (e) {
        debugPrint("Error loading user data: $e");
      }
    }
  }

  // void _listenToPlanChanges() {
  //   final user = FirebaseAuth.instance.currentUser;
  //   if (user != null) {
  //     FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(user.uid)
  //         .snapshots()
  //         .listen((snapshot) {
  //       if (snapshot.exists && snapshot.data() != null) {
  //         _planName = snapshot.data()?['planName'] ?? "No Plan Selected";
  //         notifyListeners(); // Notify UI to update immediately
  //       }
  //     });
  //   }
  // }

  Future<void> loadChartsData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final uid = user.uid;
      try {
        DocumentReference<Map<String, dynamic>> docRef = FirebaseFirestore
            .instance
            .collection("users")
            .doc(uid)
            .collection("chartsData")
            .doc("profileViews");
        DocumentSnapshot<Map<String, dynamic>> docSnapshot = await docRef.get();
        if (docSnapshot.exists) {
          final chartsData = ChartsDataModel.fromFirestore(docSnapshot);

          _totalViews = chartsData.totalViews;
          notifyListeners();
        }
      } catch (e) {
        debugPrint("Error loading user data: $e");
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
    _profileType = '';
    _companyName = '';
    _designation = '';
    _websiteLink = '';
    _imageUrl = '';
    _bio = '';

    notifyListeners();
  }
}
