// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nfc_app/models/employee_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmployeeProvider extends ChangeNotifier {
  Future<void> addEmployeeToLocal(EmployeeModel employee) async {
    final prefs = await SharedPreferences.getInstance();
    final employeesJson = prefs.getStringList('employees') ?? [];
    employeesJson.add(jsonEncode(employee.toFirestore()));
    await prefs.setStringList('employees', employeesJson);
    print("Employee saved locally: ${employee.email}");
    notifyListeners();
  }

  Future<List<EmployeeModel>> getLocalEmployees() async {
    final prefs = await SharedPreferences.getInstance();
    final employeesJson = prefs.getStringList('employees') ?? [];
    return employeesJson
        .map((e) => EmployeeModel.fromFirestore(jsonDecode(e)))
        .toList();
  }

  Future<void> saveEmployeesToFirestore() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final uid = user.uid;
      final employees = await getLocalEmployees();
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
              SetOptions(merge: true));
        } catch (e) {
          print("Error saving employee data to Firestore: $e");
        }
      }
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('employees');
      print("Local employees cleared after saving to Firestore.");
    } else {
      print("User is not authenticated");
    }
  }
}
