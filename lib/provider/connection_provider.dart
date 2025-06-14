// ignore_for_file: avoid_print, prefer_final_fields

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nfc_app/models/connections_model.dart';
import 'package:nfc_app/provider/user_info_form_state_provider.dart';
import 'package:provider/provider.dart';

class ConnectionProvider with ChangeNotifier {
  List<ConnectionsModel> _recommendedConnections = [];
  List<ConnectionsModel> _addedConnections = [];
  List<ConnectionsModel> _searchAddedConnections = [];
  List<ConnectionsModel> _searchRecommendedConnections = [];
  bool _showCompanyConnections = false;
  bool _isLoading = false;

  List<ConnectionsModel> get recommendedConnections => _recommendedConnections;
  List<ConnectionsModel> get addedConnections => _addedConnections;
  List<ConnectionsModel> get searchAddedConnections => _searchAddedConnections;
  List<ConnectionsModel> get searchRecommendedConnections =>
      _searchRecommendedConnections;
  bool get showCompanyConnections => _showCompanyConnections;
  bool get isLoading => _isLoading;

  Future<void> toggleConnections(BuildContext context, bool value) async {
    _isLoading = true;
    _showCompanyConnections = value;
    notifyListeners();
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final userProvider =
        Provider.of<UserInfoFormStateProvider>(context, listen: false);
    if (uid != null) {
      await FirebaseFirestore.instance.collection("users").doc(uid).update({
        'connectionTypeAll': value ? true : false,
      });
      userProvider.updateConnectionType(value);
    }
    await loadRecommendedConnections();
  }

  Future<void> loadRecommendedConnections() async {
    try {
      _isLoading = true;
      _recommendedConnections.clear();
      notifyListeners();

      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        final uid = currentUser.uid;

        // Fetch the current user's company and connection preferences
        final userSnapshot =
            await FirebaseFirestore.instance.collection("users").doc(uid).get();

        if (!userSnapshot.exists) return;

        final userData = userSnapshot.data();
        final String? userCompany = userData?['company_name'];
        final bool connectionType = userData?['connectionTypeAll'];

        _showCompanyConnections = connectionType;

        final querySnapshot =
            await FirebaseFirestore.instance.collection("users").get();

        for (var doc in querySnapshot.docs) {
          if (doc.id != uid) {
            DocumentReference<Map<String, dynamic>> profileRef =
                FirebaseFirestore.instance.collection("users").doc(doc.id);

            DocumentSnapshot<Map<String, dynamic>> profileSnapshot =
                await profileRef.get();

            if (profileSnapshot.exists) {
              final connection =
                  ConnectionsModel.fromFirestore(profileSnapshot);
              bool isAlreadyAdded = _addedConnections.any(
                  (addedConnection) => addedConnection.uid == connection.uid);
              if (!isAlreadyAdded) {
                if (_showCompanyConnections) {
                  if (connection.companyName.trim().toLowerCase() ==
                      userCompany?.trim().toLowerCase()) {
                    _recommendedConnections.add(connection);
                  }
                } else {
                  _recommendedConnections.add(connection);
                }
              }
            }
          }
        }
      }
    } catch (e) {
      debugPrint("Error loading recommended connections: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadAddedConnections() async {
    try {
      _isLoading = true;
      _addedConnections.clear();
      notifyListeners();

      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        final uid = currentUser.uid;

        final addedSnapshot = await FirebaseFirestore.instance
            .collection("users")
            .doc(uid)
            .collection("connections")
            .get();

        for (var doc in addedSnapshot.docs) {
          final addedConnection = ConnectionsModel.fromFirestore(doc);
          _addedConnections.add(addedConnection);
        }
      }
    } catch (e) {
      debugPrint("Error loading added connections: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void addConnection(ConnectionsModel connection) async {
    try {
      _addedConnections.add(connection);
      _removeFromRecommendedConnections(connection);
      notifyListeners();
      await _saveToFirestore(connection);
    } catch (e) {
      debugPrint("Error adding/updating connection: $e");
    }
  }

  void removeConnection(ConnectionsModel connection) async {
    try {
      _addedConnections.removeWhere((c) => c.uid == connection.uid);
      _recommendedConnections.add(connection);
      notifyListeners();
      await _removeFromFirestore(connection);
    } catch (e) {
      debugPrint("Error removing connection: $e");
    }
  }

  Future<void> _removeFromFirestore(ConnectionsModel connection) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final uid = user.uid;
      try {
        await FirebaseFirestore.instance
            .collection("users")
            .doc(uid)
            .collection('connections')
            .doc(connection.uid)
            .delete();
      } catch (e) {
        debugPrint("Error removing connection from Firestore: $e");
      }
    }
  }

  bool isInAddedConnections(ConnectionsModel connection) {
    return _addedConnections.any((added) => added.uid == connection.uid);
  }

  Future<void> _saveToFirestore(ConnectionsModel connection) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final uid = user.uid;
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('connections')
            .doc(connection.uid)
            .set(connection.toFirestore());
      } catch (e) {
        debugPrint("Error saving social link data: $e");
      }
    }
  }

  void _removeFromRecommendedConnections(ConnectionsModel connection) {
    _recommendedConnections.removeWhere((c) => c.uid == connection.uid);
  }

  Future<void> saveAllConnectionsToFirestore() async {
    for (var connection in _addedConnections) {
      await _saveToFirestore(connection);
    }
  }

  bool _isSearchEmpty = false;
  bool get isSearchEmpty => _isSearchEmpty;

  void searchConnections(String query) {
    if (query.isEmpty) {
      resetSearch();
    } else {
      // Filter added connections based on the search query
      _searchAddedConnections = _addedConnections.where((connection) {
        final fullName =
            "${connection.firstName} ${connection.lastName}".toLowerCase();
        return fullName.contains(query.toLowerCase());
      }).toList();

      // Filter recommended connections based on the search query
      _searchRecommendedConnections =
          _recommendedConnections.where((connection) {
        final fullName =
            "${connection.firstName} ${connection.lastName}".toLowerCase();
        return fullName.contains(query.toLowerCase());
      }).toList();
    }

    _isSearchEmpty = _searchAddedConnections.isEmpty &&
        _searchRecommendedConnections.isEmpty;

    notifyListeners();
  }

  void resetSearch() {
    _searchAddedConnections.clear();
    _searchRecommendedConnections.clear();
    _isSearchEmpty = false;
    notifyListeners();
  }

  void clear() {
    _recommendedConnections = [];
    _addedConnections = [];
    _isLoading = false;

    notifyListeners();
  }
}
