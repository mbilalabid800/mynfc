// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nfc_app/models/social_app_model.dart';

class SocialAppProvider with ChangeNotifier {
  List<SocialAppModel> _socialApps = [];
  List<SocialAppModel> _addedSocialApps = [];
  List<SocialAppModel> _filteredSocialApps = [];

  List<SocialAppModel> get socialApps => _socialApps;
  List<SocialAppModel> get addedSocialApps => _addedSocialApps;
  List<SocialAppModel> get filteredSocialApps => _filteredSocialApps;

  bool _isViewAllActive = false;
  bool get isViewAllActive => _isViewAllActive;

  String _originalUserName = '';
  String _currentUserName = '';

  bool get isUpdateEnabled => _originalUserName != _currentUserName;

  void setOriginalUserName(String userName) {
    _originalUserName = userName;
    _currentUserName = userName;
    notifyListeners();
  }

  void updateCurrentUserName(String userName) {
    _currentUserName = userName;
    notifyListeners();
  }

  Future<void> loadSocialApps() async {
    try {
      // Load all available social apps
      final querySnapshot = await FirebaseFirestore.instance
          .collection('socialApps')
          .get(const GetOptions(source: Source.server));
      _socialApps = querySnapshot.docs.map((doc) {
        return SocialAppModel.fromFirestore(doc.data());
      }).toList();

      FirebaseFirestore.instance
          .collection('socialApps')
          .snapshots()
          .listen((snapshot) {
        _socialApps = snapshot.docs
            .map((doc) => SocialAppModel.fromFirestore(doc.data()))
            .toList();
        removeFromSocialApps(_addedSocialApps);
        notifyListeners();
      });

      // Load User added social apps
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userSocialAppsSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('socialLinks')
            .orderBy('index')
            .get();
        _addedSocialApps = userSocialAppsSnapshot.docs.map((doc) {
          return SocialAppModel.fromFirestore(doc.data()).copyWith(
            isVisible: doc['isVisible'] ?? true,
          );
        }).toList();
        _updateFilteredSocialApps();
        removeFromSocialApps(_addedSocialApps);
      }

      // Check initial state of "View All"
      _updateViewAllState();

      notifyListeners();
    } catch (e) {
      debugPrint("Error loading social apps data: $e");
    }
  }

  Future<void> addOrUpdateAppItem(SocialAppModel item) async {
    try {
      final index = _addedSocialApps.indexWhere((app) => app.name == item.name);
      if (index >= 0) {
        _addedSocialApps[index] = item;
      } else {
        final newItem = SocialAppModel(
            name: item.name,
            icon: item.icon,
            profileLink: item.profileLink,
            userName: item.userName,
            isVisible: item.isVisible,
            index: _addedSocialApps.length);

        _addedSocialApps.add(newItem);
        removeFromSocialApps([newItem]);
      }
      _updateFilteredSocialApps();

      // Update "View All" state
      _updateViewAllState();
      notifyListeners();
      await _saveToFirestore(item);
    } catch (e) {
      debugPrint("Error adding/updating app item: $e");
    }
  }

  void removeFromSocialApps(List<SocialAppModel> apptoremove) {
    _socialApps
        .removeWhere((app) => apptoremove.any((item) => item.name == app.name));
    notifyListeners();
  }

  Future<void> removeFromaddedSocialApps(
      List<SocialAppModel> apptoremove) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final uid = user.uid;
      try {
        _addedSocialApps.removeWhere(
            (app) => apptoremove.any((item) => item.name == app.name));

        _filteredSocialApps.removeWhere(
            (app) => apptoremove.any((item) => item.name == app.name));

        _socialApps.addAll(apptoremove);

        for (var item in apptoremove) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .collection('socialLinks')
              .doc(item.name)
              .delete();
        }

        _updateFilteredSocialApps();
        notifyListeners();
      } catch (e) {
        debugPrint("Error removing app from addedSocialApps and Firestore: $e");
      }
    }
  }

  void toggleAppVisibility(SocialAppModel item) {
    final index = _addedSocialApps.indexWhere((app) => app.name == item.name);
    if (index >= 0) {
      _addedSocialApps[index] = item.copyWith(isVisible: !item.isVisible);
      _updateFilteredSocialApps();

      // Update "View All" state
      _updateViewAllState();

      notifyListeners();
      _saveToFirestore(_addedSocialApps[index]);
    }
  }

  void toggleViewAll(bool value) {
    _isViewAllActive = value;

    // Update all apps' visibility based on the "View All" toggle
    for (var i = 0; i < _addedSocialApps.length; i++) {
      _addedSocialApps[i] = _addedSocialApps[i].copyWith(isVisible: value);
      _saveToFirestore(_addedSocialApps[i]);
    }

    _updateFilteredSocialApps();
    notifyListeners();
  }

  void _updateViewAllState() {
    // If at least one app is visible, set "View All" to true, otherwise false
    _isViewAllActive = _addedSocialApps.any((app) => app.isVisible);
  }

  void _updateFilteredSocialApps() {
    _filteredSocialApps =
        _addedSocialApps.where((app) => app.isVisible).toList();
  }

  Future<void> _saveToFirestore(SocialAppModel item) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final uid = user.uid;
      try {
        final appData = item.toFirestore();
        appData['isVisible'] = item.isVisible; // Ensure visibility is saved
        appData['index'] = item.index;

        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('socialLinks')
            .doc(item.name)
            .set(appData);
      } catch (e) {
        debugPrint("Error saving social link data: $e");
      }
    }
  }

  Future<void> reorderSocialApps(int oldIndex, int newIndex) async {
    final SocialAppModel item = _addedSocialApps.removeAt(oldIndex);
    _addedSocialApps.insert(newIndex, item);

    for (var i = 0; i < _addedSocialApps.length; i++) {
      _addedSocialApps[i] = _addedSocialApps[i].copyWith(index: i);
    }
    _updateFilteredSocialApps();
    notifyListeners();
    await _saveReorderedAppsToFirestore();
  }

  Future<void> _saveReorderedAppsToFirestore() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final uid = user.uid;
      try {
        final batch = FirebaseFirestore.instance.batch();
        final userSocialLinksRef = FirebaseFirestore.instance
            .collection("users")
            .doc(uid)
            .collection('socialLinks');
        for (var i = 0; i < _addedSocialApps.length; i++) {
          final app = _addedSocialApps[i];
          final docRef = userSocialLinksRef.doc(app.name);
          final appData = app.toFirestore();
          appData['index'] = i;

          batch.set(docRef, appData);
        }
        await batch.commit();
        debugPrint('Reordered apps saved to Firestore');
      } catch (e) {
        debugPrint('Error saving reordered social apps to Firestore: $e');
      }
    }
  }

  void clear() {
    _socialApps = [];
    _addedSocialApps = [];
    _filteredSocialApps = [];
    _isViewAllActive = false;
  }
}
