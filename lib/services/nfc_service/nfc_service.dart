// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:lottie/lottie.dart';
import 'package:nfc_app/constants/appColors.dart';
import 'package:nfc_app/responsive/device_dimensions.dart';
import 'package:nfc_app/shared/common_widgets/custom_snackbar_widget.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'dart:async';
import 'package:flutter/material.dart';

class NfcService {
  bool _isWriting = false; // Prevents read while writing

  Future<void> writeProfileToNfc(
      BuildContext context, String profileLink) async {
    bool isAvailable = await NfcManager.instance.isAvailable();
    if (!isAvailable) {
      CustomSnackbar().snakBarError(context, "NFC is unavailable");
      return;
    }

    _isWriting = true; // ✅ Disable NFC reading while writing

    // 🚨 Stop any active NFC session to avoid interference
    try {
      await NfcManager.instance.stopSession();
    } catch (e) {
      print("No active session to stop: $e");
    }

    _showLoadingDialog(context);

    Completer<void> completer = Completer();
    Timer? timeoutTimer;

    NfcManager.instance.startSession(
      onDiscovered: (NfcTag tag) async {
        if (!_isWriting) return; // ✅ Prevent accidental read

        var ndef = Ndef.from(tag);
        if (ndef != null && ndef.isWritable) {
          NdefMessage message = NdefMessage([
            NdefRecord.createUri(Uri.parse(profileLink)),
          ]);
          try {
            await ndef.write(message);
            await NfcManager.instance.stopSession();
            _isWriting = false; // ✅ Allow reading after completion
            timeoutTimer?.cancel();
            completer.complete();
          } catch (e) {
            await NfcManager.instance.stopSession(errorMessage: e.toString());
            completer.completeError(e);
            timeoutTimer?.cancel();
          }
        } else {
          await NfcManager.instance
              .stopSession(errorMessage: "Tag is not writable.");
          completer.completeError("Tag is not writable.");
          timeoutTimer?.cancel();
        }
      },
      onError: (error) async {
        await NfcManager.instance.stopSession(errorMessage: error.message);
        completer.completeError(error.message);
        timeoutTimer?.cancel();
      },
    );

    timeoutTimer = Timer(const Duration(seconds: 10), () async {
      await NfcManager.instance.stopSession();
      completer.completeError('NFC scan timed out after 10 seconds');
    });

    try {
      await completer.future;
      Navigator.of(context).pop(); // Close loading dialog
      _showSuccess(context);
    } catch (e) {
      Navigator.of(context).pop();
      Future.delayed(const Duration(milliseconds: 200), () {
        CustomSnackbar().snakBarError(context, 'Failed to write NFC tag: $e');
      });
    }
  }

  void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
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
              onTap: () async {
                await NfcManager.instance.stopSession();
                _isWriting = false; // ✅ Allow reading again
                Navigator.of(context).pop();
              },
              child: Container(
                  width: DeviceDimensions.screenWidth(context) * 0.9,
                  height: DeviceDimensions.screenHeight(context) * 0.055,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: AppColors.appBlueColor,
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
  }

  void _showSuccess(BuildContext rootContext) {
    showDialog(
      context: rootContext,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.screenBackground,
          title: const Text('NFC Tag Written!'),
          content: SizedBox(
            height: DeviceDimensions.screenHeight(rootContext) * 0.26,
            width: DeviceDimensions.screenWidth(rootContext) * 0.7,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Lottie.asset('assets/animations/done_animation.json',
                    height: 150, key: const ValueKey('success_animation')),
              ],
            ),
          ),
          actions: <Widget>[
            GestureDetector(
              onTap: () async {
                Navigator.of(context).pop();

                // ✅ Restart NFC reading only after clicking "Done"
                await NfcManager.instance.startSession(
                  onDiscovered: (NfcTag tag) async {
                    CustomSnackbar()
                        .snakBarMessage(context, "NFC Tag Detected!");
                  },
                );

                _isWriting = false; // ✅ Allow NFC reading again
              },
              child: Container(
                width: DeviceDimensions.screenWidth(context) * 0.9,
                height: DeviceDimensions.screenHeight(context) * 0.055,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: AppColors.appBlueColor,
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
  }
}
