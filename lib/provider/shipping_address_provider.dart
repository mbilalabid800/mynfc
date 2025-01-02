// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nfc_app/models/shipping_address_model.dart';

class ShippingAddressProvider with ChangeNotifier {
  String _selectedMethod = '';
  List<ShippingAddressModel> _shippingAddress = [];
  ShippingAddressModel? _selectedShippingAddress;
  bool isLoading = false;
  bool hasLoadedShippingAddress = false;

  String get selectedMethod => _selectedMethod;
  List<ShippingAddressModel> get shippingAddress => _shippingAddress;
  ShippingAddressModel? get selectedShippingAddress => _selectedShippingAddress;

  void selectMethod(String method) {
    _selectedMethod = method;
    notifyListeners();
  }

  bool isMethodSelected(String method) {
    return _selectedMethod == method;
  }

  Future<void> saveShippingAddress(ShippingAddressModel address) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final uid = user.uid;
      try {
        // Step 1: Set selected to false for all other addresses
        await _setAllAddressesSelectedToFalse(uid);

        // Step 2: Save the new address with selected = true
        await _saveAddressToFirestore(uid, address, true);

        // Step 3: Reload all addresses and update selected address
        await loadShippingAddress(); // Reload addresses to reflect changes
        _selectedShippingAddress = address;
        notifyListeners();
        debugPrint(
            "Shipping address saved successfully and marked as selected.");
      } catch (e) {
        debugPrint("Error saving shipping address: $e");
      }
    }
  }

  Future<void> updateShippingAddress(
      ShippingAddressModel updatedAddress) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final uid = user.uid;
      isLoading = true;
      notifyListeners();
      try {
        await _setAllAddressesSelectedToFalse(uid);

        await _saveAddressToFirestore(uid, updatedAddress, true);

        await loadShippingAddress();

        _selectedShippingAddress = updatedAddress;

        notifyListeners();
        debugPrint("Successfully updated and selected the shipping address.");
      } catch (e) {
        debugPrint("Error in updateShippingAddress: $e");
      }
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _saveAddressToFirestore(
      String uid, ShippingAddressModel address, bool isSelected) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection("shippingAddress")
        .doc(address.locationName) // Assuming locationName is unique
        .set({
      'firstName': address.firstName,
      'lastName': address.lastName,
      'locationName': address.locationName,
      'company': address.company ?? '',
      'phone': address.phone,
      'country': address.country,
      'streetAddress': address.streetAddress,
      'apartment': address.apartment ?? '',
      'city': address.city,
      'state': address.state,
      'zipCode': address.zipCode,
      'selected': isSelected, // Mark as selected if applicable
    }).then((_) {
      debugPrint("Address saved successfully.");
    }).catchError((error) {
      debugPrint("Failed to save address: $error");
    });
  }

  Future<void> _setAllAddressesSelectedToFalse(String uid) async {
    final addressesSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection("shippingAddress")
        .get();

    for (var doc in addressesSnapshot.docs) {
      await doc.reference.update({'selected': false});
    }
  }

  Future<void> loadShippingAddress() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final uid = user.uid;

      isLoading = true;
      notifyListeners();
      try {
        final querySnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection("shippingAddress")
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          _shippingAddress = querySnapshot.docs.map((doc) {
            final data = doc.data();
            return ShippingAddressModel(
              firstName: data['firstName'] ?? '',
              lastName: data['lastName'] ?? '',
              locationName: data['locationName'] ?? '',
              company: data['company'],
              phone: data['phone'] ?? '',
              country: data['country'] ?? '',
              streetAddress: data['streetAddress'] ?? '',
              apartment: data['apartment'],
              city: data['city'] ?? '',
              state: data['state'] ?? '',
              zipCode: data['zipCode'] ?? '',
              selected: data['selected'] ?? false,
            );
          }).toList();

          setSelectedShippingAddress();
        } else {
          debugPrint("No shipping addresses found.");
        }
      } catch (e) {
        debugPrint("Error loading shipping addresses: $e");
      }

      isLoading = false;
      notifyListeners();
    }
  }

  void setSelectedShippingAddress() {
    if (_shippingAddress.isNotEmpty) {
      _selectedShippingAddress = _shippingAddress.firstWhere(
        (address) => address.selected == true,
        orElse: () =>
            _shippingAddress.first, // Fallback in case none is selected
      );
    }
    notifyListeners();
  }

  Future<void> deleteShippingAddress(ShippingAddressModel address) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final uid = user.uid;
      isLoading = true;
      notifyListeners();
      try {
        await FirebaseFirestore.instance
            .collection("users")
            .doc(uid)
            .collection("shippingAddress")
            .doc(address.locationName)
            .delete();
        debugPrint("Address deleted successfully.");
        _shippingAddress
            .removeWhere((a) => a.locationName == address.locationName);
        if (_selectedShippingAddress?.locationName == address.locationName) {
          if (_shippingAddress.isNotEmpty) {
            _selectedShippingAddress = _shippingAddress.first;
            await _saveAddressToFirestore(uid, _selectedShippingAddress!, true);
          } else {
            _selectedShippingAddress = null;
          }
        }
      } catch (e) {
        debugPrint("Error deleting shipping address: $e");
      }
    }
    isLoading = false;
    notifyListeners();
  }
}
