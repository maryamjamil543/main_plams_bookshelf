import 'package:permission_handler/permission_handler.dart';

class PermissionsUtil {
  // Method to check the status of multiple permissions at once
  static List<Permission> appPermissions = [
    Permission.camera,
    Permission.notification
  ];

  Future<Map<Permission, PermissionStatus>> checkPermissions(List<Permission>? permissions) async {
    final Map<Permission, PermissionStatus> statuses = {};

    for (var permission in permissions??appPermissions) {
      statuses[permission] = await permission.status;
    }

    return statuses;
  }

  // Method to request multiple permissions at once
  Future<Map<Permission, PermissionStatus>> requestPermissions(List<Permission>? permissions) async {
    final Map<Permission, PermissionStatus> statuses = await (permissions??appPermissions).request();
    return statuses;
  }

  // Utility method to check if all permissions are granted
  bool arePermissionsGranted(Map<Permission, PermissionStatus> statuses) {
    for (var status in statuses.values) {
      if (!status.isGranted) {
        return false; // At least one permission is not granted
      }
    }
    return true;
  }
}