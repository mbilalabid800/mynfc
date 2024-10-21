import 'package:permission_handler/permission_handler.dart';

class PermissionHandler {
  Future<bool> requestContactsPermission() async {
    return _requestPermission(Permission.contacts);
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
