// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerProvider with ChangeNotifier {
  File? _image;
  File? get image => _image;
  String? _error;

  String? get error => _error;

  Future<void> pickImage(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final CroppedFile? croppedFile = await cropImage(image.path);

      if (croppedFile != null) {
        final File file = File(croppedFile.path);
        final int fileSizeInBytes = await file.length();
        final double fileSizeInMB = fileSizeInBytes / (1024 * 1024);
        print("Size of image is $fileSizeInMB MB");

        if (fileSizeInMB <= 5) {
          _image = file;
          _error = null;
          notifyListeners();
        } else {
          _error = 'File size exceeds 5MB. Please choose a smaller file.';
          notifyListeners();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(_error!)),
          );
        }
      }
    }
  }

  Future<CroppedFile?> cropImage(String imagePath) async {
    return await ImageCropper().cropImage(
      sourcePath: imagePath,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      compressFormat: ImageCompressFormat.jpg,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: Colors.grey,
          toolbarWidgetColor: Colors.white,
          cropStyle: CropStyle.circle,
          hideBottomControls: true,
          lockAspectRatio: true,
        ),
        IOSUiSettings(
          title: 'Crop Image',
        ),
      ],
    );
  }

  bool get hasImage => _image != null;
}
