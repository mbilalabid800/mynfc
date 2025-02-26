import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:nfc_app/constants/appColors.dart';
import 'package:nfc_app/responsive/device_dimensions.dart';
import 'package:nfc_app/shared/common_widgets/custom_app_bar_widget.dart';
import 'package:nfc_app/shared/common_widgets/custom_snackbar_widget.dart';
import 'package:permission_handler/permission_handler.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _QRScannerScreenState createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  MobileScannerController cameraController = MobileScannerController();
  bool isTorchOn = false;
  bool isProcessing = false;

  @override
  void initState() {
    super.initState();
    _requestCameraPermission();
  }

  void _onQRScanned(String? data) {
    if (data == null || isProcessing) return;

    setState(() {
      isProcessing = true;
    });

    debugPrint('QR Code Found: $data');
    // CustomSnackbar().snakBarMessage(context, 'Scanned: $data');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.successColor,
        elevation: 5,
        content: Text("Scanned: $data"),
        duration: Duration(seconds: 3), // Show for 3 seconds
      ),
    );

    // Reset flag after 3 seconds so user can scan again
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        isProcessing = false;
      });
    });
  }

  Future<void> _requestCameraPermission() async {
    var status = await Permission.camera.request();
    if (status != PermissionStatus.granted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Camera permission denied")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.screenBackground,
        body: Column(
          children: [
            AbsherAppBar(
              title: 'Scan Your QR Code',
              onLeftButtonTap: () {
                Navigator.pop(context);
              },
              rightButton: Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                    width: DeviceDimensions.screenWidth(context) * 0.035),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: Icon(isTorchOn
                    ? Icons.flash_on_outlined
                    : Icons.flash_off_outlined),
                onPressed: () {
                  setState(() {
                    isTorchOn = !isTorchOn;
                  });
                  cameraController.toggleTorch();
                },
              ),
            ),
            Flexible(
              child: Stack(
                children: [
                  MobileScanner(
                    controller: cameraController,
                    onDetect: (capture) {
                      final List<Barcode> barcodes = capture.barcodes;
                      for (final barcode in barcodes) {
                        _onQRScanned(barcode.rawValue);
                        // debugPrint('QR Code Found: ${barcode.rawValue}');
                        // // CustomSnackbar().snakBarMessage(
                        // //     context, 'Scanned ${barcode.rawValue}');
                        // ScaffoldMessenger.of(context).showSnackBar(
                        //   SnackBar(
                        //       content: Text("Scanned: ${barcode.rawValue}")),
                        // );
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
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double scanBoxSize = constraints.maxWidth * 0.7; // 70% of screen width
        return Stack(
          children: [
            // Dark Overlay with a Transparent Hole
            Container(
              color: Colors.black.withOpacity(0.4),
            ),

            // Clear Scan Area
            Center(
              child: ClipPath(
                clipper: QRScannerClipper(scanBoxSize),
                child: Container(
                  width: DeviceDimensions.responsiveSize(context) * 0.8,
                  height: DeviceDimensions.responsiveSize(context) * 0.8,
                  // width: scanBoxSize,
                  // height: scanBoxSize,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 2),
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

// Clipper to Cut Out the Scan Box
class QRScannerClipper extends CustomClipper<Path> {
  final double boxSize;

  QRScannerClipper(this.boxSize);

  @override
  Path getClip(Size size) {
    Path path = Path();
    path.addRect(Rect.fromLTWH(0, 0, size.width, size.height)); // Full Screen
    path.addRect(Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: boxSize,
      height: boxSize,
    ));
    return path..fillType = PathFillType.evenOdd; // Cut-out effect
  }

  @override
  bool shouldReclip(QRScannerClipper oldClipper) =>
      oldClipper.boxSize != boxSize;
}
