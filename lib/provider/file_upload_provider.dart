import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class FileUploadProvider with ChangeNotifier {
  bool _isFileUploaded = false;
  String? _fileUrl;

  bool get isFileUploaded => _isFileUploaded;
  String? get fileUrl => _fileUrl;

  FileUploadProvider() {
    _fetchFileUploadStatus(); // Load status on app start
  }

  Future<void> _fetchFileUploadStatus() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final doc =
          await FirebaseFirestore.instance.collection("users").doc(uid).get();

      if (doc.exists) {
        final data = doc.data(); // ✅ Get the document data safely
        if (doc.exists) {
          final data = doc.data();
          _isFileUploaded = data?['isFileUploaded'] ?? false;
          _fileUrl = data?['fileUrl'] ?? "";
          notifyListeners();
        }

        // _isFileUploaded = (data != null && data.containsKey('isFileUploaded'))
        //     ? data['isFileUploaded']
        //     : false;
        // _fileUrl = (data != null && data.containsKey('fileUrl'))
        //     ? data['fileUrl']
        //     : null;

        // notifyListeners();
      }
    }
  }

  // Update Firestore when a file is uploaded
  Future<void> updateIsFileUploaded(bool isUploaded, String? fileUrl) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      await FirebaseFirestore.instance.collection("users").doc(uid).update({
        'isFileUploaded': isUploaded,
        'fileUrl': fileUrl,
      });
    }
    _isFileUploaded = isUploaded;
    _fileUrl = fileUrl;
    notifyListeners();
  }

  // Pick and upload a PDF file
  Future<void> pickAndUploadFile(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom, allowedExtensions: ['pdf'], // ✅ Allow only PDFs
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      await _uploadFileToFirebase(file, context);
    }
  }

  // Upload file to Firebase Storage and update Firestore
  Future<void> _uploadFileToFirebase(File file, BuildContext context) async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return;

      String fileName = file.path.split('/').last;
      Reference storageRef =
          FirebaseStorage.instance.ref().child('users/$uid/$fileName');

      UploadTask uploadTask = storageRef.putFile(file);
      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();

      // ✅ Save file info to Firestore
      // await FirebaseFirestore.instance
      //     .collection("users")
      //     .doc(uid)
      //     .collection("files")
      //     .add({
      //   'fileName': fileName,
      //   'downloadUrl': downloadUrl,
      //   'uploadedAt': Timestamp.now(),
      // });

      // ✅ Update the Firestore field
      await updateIsFileUploaded(true, downloadUrl);

      // ✅ Show success Snackbar

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("PDF uploaded successfully!"),
            backgroundColor: Colors.green),
      );
    } catch (e) {
      print("Error uploading file: $e");
    }
  }
}
