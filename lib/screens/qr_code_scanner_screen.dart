// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:nfc_app/constants/appColors.dart';
import 'package:nfc_app/responsive/device_dimensions.dart';
import 'package:nfc_app/shared/utils/url_launcher_helper.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  _QRScannerScreenState createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  MobileScannerController cameraController = MobileScannerController();
  bool isTorchOn = false;
  bool isProcessing = false;
  String? lastScannedQR;
  int scannedCount = 0;

  @override
  void initState() {
    super.initState();
  }

  void _onQRScanned(String? data) {
    if (data == null || isProcessing) return;

    // Ensure the QR code remains stable in the clear box
    if (lastScannedQR == data) {
      scannedCount++;
    } else {
      scannedCount = 1;
    }
    lastScannedQR = data;

    if (scannedCount < 3) return; // Ensures stability before processing

    setState(() {
      isProcessing = true;
    });

    debugPrint('QR Code Found: $data');

    if (mounted) {
      Future.delayed(Duration.zero, () {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Scanned: $data"),
              duration: Duration(seconds: 3),
              action: SnackBarAction(
                label: "Open",
                textColor: Colors.green,
                onPressed: () =>
                    UrlLauncherHelper.launchSocialApps(context, data),
              ),
            ),
          );
        }
      });
    }

    // Reset flag after 3 seconds so user can scan again
    Future.delayed(Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          isProcessing = false;
        });
      }
    });

    // Reset last scanned QR after processing
    lastScannedQR = null;
    scannedCount = 0;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.screenBackground,
        body: Column(
          children: [
            Container(
              color: Colors.black.withOpacity(0.7),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: Icon(Icons.cancel_sharp, color: Colors.white),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: Icon(
                        isTorchOn
                            ? Icons.flash_on_outlined
                            : Icons.flash_off_outlined,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          isTorchOn = !isTorchOn;
                        });
                        cameraController.toggleTorch();
                      },
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              child: Stack(
                children: [
                  Container(
                    width: DeviceDimensions.screenHeight(context),
                    color: Colors.black,
                  ),
                  MobileScanner(
                    controller: cameraController,
                    onDetect: (capture) {
                      final List<Barcode> barcodes = capture.barcodes;
                      for (final barcode in barcodes) {
                        _onQRScanned(barcode.rawValue);
                      }
                    },
                  ),
                  QRScannerOverlay(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class QRScannerOverlay extends StatelessWidget {
  const QRScannerOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double scanBoxSize = constraints.maxWidth * 0.7; // 70% of screen width
        return Stack(
          children: [
            ClipPath(
              clipper: QRScannerClipper(scanBoxSize),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                ),
              ),
            ),
            Center(
              child: Container(
                width: DeviceDimensions.responsiveSize(context) * 0.7,
                height: DeviceDimensions.responsiveSize(context) * 0.7,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 2),
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 35.0),
                child: Text(
                  "Scan QR code",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: DeviceDimensions.responsiveSize(context) * 0.06,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Text(
                  "Powered by Absher",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: DeviceDimensions.responsiveSize(context) * 0.045,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class QRScannerClipper extends CustomClipper<Path> {
  final double boxSize;
  final double cornerRadius;

  QRScannerClipper(this.boxSize, {this.cornerRadius = 25.0});

  @override
  Path getClip(Size size) {
    Path path = Path();
    path.addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    path.addRRect(RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(size.width / 2, size.height / 2),
        width: boxSize,
        height: boxSize,
      ),
      Radius.circular(cornerRadius),
    ));
    return path..fillType = PathFillType.evenOdd;
  }

  @override
  bool shouldReclip(QRScannerClipper oldClipper) =>
      oldClipper.boxSize != boxSize;
}
