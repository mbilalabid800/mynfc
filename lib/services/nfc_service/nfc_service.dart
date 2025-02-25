// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:nfc_app/constants/appColors.dart';
import 'package:nfc_app/responsive/device_dimensions.dart';
import 'package:nfc_app/shared/common_widgets/custom_snackbar_widget.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:lottie/lottie.dart';

class NfcService {
  bool _hasDetectedTag = false;
  Timer? _timeoutTimer; // ✅ Timer to handle auto-dismiss

  Future<void> writeProfileToNfc(
      BuildContext context, String profileLink) async {
    bool isAvailable = await NfcManager.instance.isAvailable();
    if (!isAvailable) {
      CustomSnackbar().snakBarError(context, "NFC is unavailable");
      return;
    }

    _hasDetectedTag = false;

    try {
      await NfcManager.instance.stopSession();
    } catch (e) {
      print("No active session to stop: $e");
    }

    _showLoadingDialog(context);

    NfcManager.instance.startSession(
      onDiscovered: (NfcTag tag) async {
        _timeoutTimer?.cancel(); // ✅ Cancel timeout when tag is detected
        if (_hasDetectedTag) return;
        _hasDetectedTag = true;

        var ndef = Ndef.from(tag);
        if (ndef != null && ndef.isWritable) {
          try {
            await ndef.write(NdefMessage([
              NdefRecord.createUri(Uri.parse(profileLink)),
            ]));
            await NfcManager.instance.stopSession();
            Navigator.of(context).pop(); // Close loading dialog
            _showSuccess(context);
          } catch (e) {
            await NfcManager.instance.stopSession(errorMessage: e.toString());
            Navigator.of(context).pop();
            CustomSnackbar()
                .snakBarError(context, 'Failed to write NFC tag: $e');
          }
        } else {
          await NfcManager.instance
              .stopSession(errorMessage: "Tag is not writable.");
          Navigator.of(context).pop();
          CustomSnackbar().snakBarError(context, "Tag is not writable.");
        }
      },
      onError: (error) async {
        _timeoutTimer?.cancel();
        await NfcManager.instance.stopSession(errorMessage: error.message);
        Navigator.of(context).pop();
        CustomSnackbar().snakBarError(context, error.message);
      },
    );
  }

  void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        _timeoutTimer = Timer(const Duration(seconds: 10), () {
          if (!_hasDetectedTag) {
            Navigator.of(dialogContext).pop(); // Auto close dialog
            CustomSnackbar().snakBarError(context, "NFC scan timed out.");
            NfcManager.instance.stopSession(); // Stop session on timeout
          }
        });

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
                _timeoutTimer?.cancel();
                await NfcManager.instance.stopSession();
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
                      )),
                ),
              ),
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
              },
              child: Container(
                width: DeviceDimensions.screenWidth(context) * 0.9,
                height: DeviceDimensions.screenHeight(context) * 0.055,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: AppColors.appBlueColor,
                ),
                child: const Center(
                  child: Text(
                    'Done',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
