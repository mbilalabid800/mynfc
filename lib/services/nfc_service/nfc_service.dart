// ignore_for_file: use_build_context_synchronously

import 'package:lottie/lottie.dart';
import 'package:nfc_app/constants/appColors.dart';
import 'package:nfc_app/responsive/device_dimensions.dart';
import 'package:nfc_app/widgets/custom_snackbar_widget.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'dart:async';
import 'package:flutter/material.dart';

class NfcService {
  Future<void> writeProfileToNfc(
      BuildContext context, String profileLink) async {
    bool isAvailable = await NfcManager.instance.isAvailable();
    if (!isAvailable) {
      CustomSnackbar().snakBarError(context, 'NFC is unavailable');
      return;
    }
    _showLoadingDialog(context);

    Completer<void> completer = Completer();
    Timer? timeoutTimer;

    NfcManager.instance.startSession(
      onDiscovered: (NfcTag tag) async {
        var ndef = Ndef.from(tag);
        if (ndef != null && ndef.isWritable) {
          NdefMessage message = NdefMessage([
            NdefRecord.createUri(Uri.parse(profileLink)),
          ]);
          try {
            await ndef.write(message);
            NfcManager.instance.stopSession();
            completer.complete();
            timeoutTimer?.cancel();
          } catch (e) {
            NfcManager.instance.stopSession(errorMessage: e.toString());
            completer.completeError(e);
            timeoutTimer?.cancel();
          }
        } else {
          NfcManager.instance.stopSession(errorMessage: "Tag is not writable.");
          completer.completeError("Tag is not writable.");
          timeoutTimer?.cancel();
        }
      },
      onError: (error) async {
        NfcManager.instance.stopSession(errorMessage: error.message);
        completer.completeError(error.message);
        timeoutTimer?.cancel();
      },
    );

    timeoutTimer = Timer(const Duration(seconds: 10), () {
      NfcManager.instance.stopSession(); // Stop NFC session after timeout
      completer.completeError('NFC scan timed out after 10 seconds');
    });

    try {
      await completer.future;
      Navigator.of(context).pop(); // Close the loading dialog
      _showSuccess(context, 'NFC tag written successfully');
    } catch (e) {
      Navigator.of(context).pop(); // Close the loading dialog
      CustomSnackbar().snakBarError(context, 'Failed to write NFC tag: $e');
    }
  }

  void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: AppColors.screenBackground,
              title: const Text('Scan your NFC card'),
              content: SizedBox(
                height: DeviceDimensions.screenHeight(context) * 0.26,
                width: DeviceDimensions.screenWidth(context) * 0.7,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Lottie.asset('assets/animations/nfc_scan.json'),
                  ],
                ),
              ),
              actions: <Widget>[
                GestureDetector(
                  onTap: () {
                    NfcManager.instance.stopSession();
                    Navigator.of(context).pop();
                  },
                  child: Container(
                      width: DeviceDimensions.screenWidth(context) * 0.9,
                      height: DeviceDimensions.screenHeight(context) * 0.055,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Colors.black,
                      ),
                      child: const Center(
                          child: Text('Cancel',
                              style: TextStyle(
                                color: Colors.white,
                              )))),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showSuccess(BuildContext context, String message) {
    // Find the dialog and update its content dynamically
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: AppColors.screenBackground,
              title: const Text('NFC Tag Written!'),
              content: SizedBox(
                height: DeviceDimensions.screenHeight(context) * 0.26,
                width: DeviceDimensions.screenWidth(context) * 0.7,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    //SizedBox(height: 10),
                    // Show success animation after NFC is written
                    Lottie.asset('assets/animations/done_animation.json',
                        height: 150, key: const ValueKey('success_animation')),
                    //SizedBox(height: 10),
                    //Text('The NFC tag was written successfully!'),
                  ],
                ),
              ),
              actions: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.of(context)
                        .pop(); // Close dialog when user clicks 'Done'
                  },
                  child: Container(
                    width: DeviceDimensions.screenWidth(context) * 0.9,
                    height: DeviceDimensions.screenHeight(context) * 0.055,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.black,
                    ),
                    child: const Center(
                      child: Text('Done',
                          style: TextStyle(
                            color: Colors.white,
                          )),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // void _showError(BuildContext context, String message) {
  //   CustomSnackbar().snakBarError(context, "Failed to write Tag.");
  // }
}
