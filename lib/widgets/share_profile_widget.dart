// ignore_for_file: avoid_print
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:nfc_app/constants/appColors.dart';
import 'package:nfc_app/responsive/device_dimensions.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

class ShareProfile {
  void shareProfile(BuildContext context, String profileLink) {
    showModalBottomSheet(
      backgroundColor: AppColors.screenBackground,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, setState) {
            return SizedBox(
              height: 170,
              width: DeviceDimensions.screenWidth(context),
              child: Column(
                children: [
                  SizedBox(
                      height: DeviceDimensions.screenHeight(context) * 0.015),
                  Container(
                    width: DeviceDimensions.screenWidth(context) * 0.16,
                    height: DeviceDimensions.screenHeight(context) * 0.007,
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  SizedBox(
                      height: DeviceDimensions.screenHeight(context) * 0.030),
                  // qrCodeWidget(profileLink),
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: GestureDetector(
                      onTap: () {
                        _shareQrCode(context, profileLink);
                      },
                      child: Row(
                        children: [
                          Image.asset("assets/icons/shareqr.png", height: 26),
                          SizedBox(
                              width: DeviceDimensions.screenWidth(context) *
                                  0.030),
                          Text(
                            "Share with QR Code",
                            style: TextStyle(
                              fontSize:
                                  DeviceDimensions.responsiveSize(context) *
                                      0.052,
                              fontFamily: 'Barlow-Regular',
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                      height: DeviceDimensions.screenHeight(context) * 0.010),
                  Divider(),
                  SizedBox(
                      height: DeviceDimensions.screenHeight(context) * 0.010),
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: GestureDetector(
                      onTap: () {
                        Share.share(profileLink);
                      },
                      child: Row(
                        children: [
                          Image.asset("assets/icons/sharelink.png", height: 28),
                          SizedBox(
                              width: DeviceDimensions.screenWidth(context) *
                                  0.030),
                          Text(
                            "Share Profile Link",
                            style: TextStyle(
                              fontSize:
                                  DeviceDimensions.responsiveSize(context) *
                                      0.052,
                              fontFamily: 'Barlow-Regular',
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _shareQrCode(BuildContext context, String profileLink) async {
    try {
      // Create the QR code without showing it in the UI
      final qrImage = await _generateQrImage(profileLink);

      // Save the QR code image to a temporary directory
      final tempDir = await getTemporaryDirectory();
      final file = await File('${tempDir.path}/qr_code.png').create();
      await file.writeAsBytes(qrImage);

      // Share the image
      await Share.shareXFiles([XFile(file.path)],
          text: 'Scan this QR code to view my profile.');
    } catch (e) {
      print("Error capturing QR code: $e");
    }
  }

  Future<Uint8List> _generateQrImage(String profileLink) async {
    try {
      final qrValidationResult = QrValidator.validate(
        data: profileLink,
        version: QrVersions.auto,
      );
      if (qrValidationResult.status == QrValidationStatus.valid) {
        // Create a picture recorder to capture the QR code as an image
        final pictureRecorder = PictureRecorder();
        final canvas = Canvas(pictureRecorder);
        final paint = Paint()..color = Colors.white;
        final size = const Size(200, 200);

        // Fill the background with white
        canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

        // Render the QR code on the canvas
        QrPainter(
          data: profileLink,
          version: QrVersions.auto,
          gapless: true,
        ).paint(canvas, size);

        // End the recording and convert it to an image
        final image = await pictureRecorder
            .endRecording()
            .toImage(size.width.toInt(), size.height.toInt());

        // Convert the image to bytes (png format)
        final byteData = await image.toByteData(format: ImageByteFormat.png);
        return byteData!.buffer.asUint8List();
      } else {
        throw Exception('Invalid QR code data.');
      }
    } catch (e) {
      throw Exception('Error generating QR code image: $e');
    }
  }
}
