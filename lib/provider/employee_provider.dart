// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nfc_app/constants/appColors.dart';
import 'package:nfc_app/models/employee_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmployeeProvider extends ChangeNotifier {
  List<EmployeeModel> _employees = [];
  List<EmployeeModel> get employees => _employees;
  List<EmployeeModel> _employeesLocal = [];
  List<EmployeeModel> get employeesLocal => _employeesLocal;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> addEmployeeToLocal(
      BuildContext context, EmployeeModel employee) async {
    final user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid;
    final prefs = await SharedPreferences.getInstance();
    final employeesJson = prefs.getStringList('employees') ?? [];

    // 🔍 Step 1: Check if the employee already exists in local storage
    bool existsInLocal = employeesJson.any((e) {
      final existingEmployee = EmployeeModel.fromFirestore(jsonDecode(e));
      return existingEmployee.email == employee.email;
    });

    if (existsInLocal) {
      Future.delayed(Duration.zero, () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Employee already added locally!"),
            backgroundColor: AppColors.errorColor,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            duration: Duration(seconds: 3),
          ),
        );
      });
      return;
    }

    // 🔍 Step 2: Check if the employee exists in Firestore
    DocumentSnapshot employeeSnapshot = await FirebaseFirestore.instance
        .collection("Subadmin")
        .doc(uid)
        .collection('employees')
        .doc(employee.email)
        .get();

    if (employeeSnapshot.exists) {
      Future.delayed(Duration.zero, () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Employee already exists in Firestore!"),
            backgroundColor: AppColors.errorColor,
            duration: Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      });
      return;
    }

    // ✅ Step 3: If not found in both, add to local storage
    employeesJson.add(jsonEncode(employee.toFirestore()));
    await prefs.setStringList('employees', employeesJson);

    // ✅ Step 4: Update local list and notify UI
    _employeesLocal = employeesJson
        .map((e) => EmployeeModel.fromFirestore(jsonDecode(e)))
        .toList();

    notifyListeners();
    debugPrint("Employee saved successfully: ${employee.email}");

    // 🎉 Show success snackbar
    Future.delayed(Duration.zero, () {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Employee added successfully!"),
          backgroundColor: AppColors.successColor,
          duration: Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    });
  }

  Future<void> getLocalEmployees() async {
    final prefs = await SharedPreferences.getInstance();
    final employeesJson = prefs.getStringList('employees') ?? [];
    _employeesLocal = employeesJson
        .map((e) => EmployeeModel.fromFirestore(jsonDecode(e)))
        .toList();
    notifyListeners();
  }

  Future<void> saveEmployeesToFirestore() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      debugPrint("User is not authenticated");
      return;
    }

    final uid = user.uid;
    final employees = List<EmployeeModel>.from(_employeesLocal);

    for (final employee in employees) {
      try {
        await FirebaseFirestore.instance
            .collection('Subadmin')
            .doc(uid)
            .collection('employees')
            .doc(employee.email)
            .set(employee.toFirestore());

        await FirebaseFirestore.instance.collection("Subadmin").doc(uid).set(
          {'email': user.email, 'userUid': user.uid},
          SetOptions(merge: true),
        );
      } catch (e) {
        debugPrint("Error saving employee data to Firestore: $e");
      }
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('employees');

    _employeesLocal.clear();
    notifyListeners();
    debugPrint("Local employees cleared after saving to Firestore.");
  }

  Future<void> fetchEmployeesFromFirestore() async {
    _isLoading = true;
    notifyListeners();
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      debugPrint("User is not authenticated");
      return;
    }

    final uid = user.uid;
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('Subadmin')
          .doc(uid)
          .collection('employees')
          .get();

      _employees = snapshot.docs
          .map((doc) => EmployeeModel.fromFirestore(doc.data()))
          .toList();

      notifyListeners();
      debugPrint("Fetched ${_employees.length} employees from Firestore");
    } catch (e) {
      debugPrint("Error fetching employees: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
