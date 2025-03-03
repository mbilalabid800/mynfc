import 'package:permission_handler/permission_handler.dart';

class PermissionHandler {
  Future<void> requestPermission() async {
    await _requestPermission(Permission.contacts);
    await _requestPermission(Permission.storage);
    await _requestPermission(Permission.location);
    await _requestPermission(Permission.phone);
    await _requestPermission(Permission.camera);
  }

  Future<bool> _requestPermission(Permission permission) async {
    final status = await permission.status;
    if (status.isGranted) {
      return true;
    } else if (status.isDenied) {
      final result = await permission.request();
      return result.isGranted;
    } else if (status.isPermanentlyDenied) {
      await openAppSettings();
      return false;
    }
    return false;
  }

  // Check if permission is already granted
  Future<bool> isPermissionGranted(Permission permission) async {
    final status = await permission.status;
    return status.isGranted;
  }

  // Open app settings in case permission is denied
  Future<void> openAppSettings() async {
    await PermissionHandler().openAppSettings();
  }
}
