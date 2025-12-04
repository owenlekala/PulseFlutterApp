import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart' as ph;

/// Helper class for handling app permissions
class PermissionsHelper {
  /// Request location permission
  /// Returns true if granted, false otherwise
  static Future<bool> requestLocationPermission({
    bool requestAlways = false,
  }) async {
    try {
      ph.PermissionStatus status;
      
      if (requestAlways) {
        status = await ph.Permission.locationAlways.request();
      } else {
        status = await ph.Permission.locationWhenInUse.request();
      }

      return status.isGranted;
    } on PlatformException catch (e) {
      debugPrint('Error requesting location permission: $e');
      return false;
    }
  }

  /// Check if location permission is granted
  static Future<bool> isLocationPermissionGranted() async {
    try {
      final status = await ph.Permission.location.status;
      return status.isGranted;
    } on PlatformException catch (e) {
      debugPrint('Error checking location permission: $e');
      return false;
    }
  }

  /// Request notification permission
  /// Returns true if granted, false otherwise
  static Future<bool> requestNotificationPermission() async {
    try {
      final status = await ph.Permission.notification.request();
      return status.isGranted;
    } on PlatformException catch (e) {
      debugPrint('Error requesting notification permission: $e');
      return false;
    }
  }

  /// Check if notification permission is granted
  static Future<bool> isNotificationPermissionGranted() async {
    try {
      final status = await ph.Permission.notification.status;
      return status.isGranted;
    } on PlatformException catch (e) {
      debugPrint('Error checking notification permission: $e');
      return false;
    }
  }

  /// Request multiple permissions at once
  static Future<Map<ph.Permission, ph.PermissionStatus>> requestPermissions(
    List<ph.Permission> permissions,
  ) async {
    try {
      return await permissions.request();
    } on PlatformException catch (e) {
      debugPrint('Error requesting permissions: $e');
      return {};
    }
  }

  /// Check if app should show permission rationale
  /// (Android only - returns false on iOS)
  static Future<bool> shouldShowRequestRationale(ph.Permission permission) async {
    try {
      return await permission.shouldShowRequestRationale;
    } on PlatformException catch (e) {
      debugPrint('Error checking permission rationale: $e');
      return false;
    }
  }

  /// Open app settings
  static Future<bool> openAppSettings() async {
    try {
      return await ph.openAppSettings();
    } on PlatformException catch (e) {
      debugPrint('Error opening app settings: $e');
      return false;
    }
  }

  /// Request location and notification permissions
  static Future<Map<String, bool>> requestLocationAndNotification({
    bool locationAlways = false,
  }) async {
    final results = await requestPermissions([
      locationAlways ? ph.Permission.locationAlways : ph.Permission.locationWhenInUse,
      ph.Permission.notification,
    ]);

    return {
      'location': results[locationAlways
              ? ph.Permission.locationAlways
              : ph.Permission.locationWhenInUse]
          ?.isGranted ??
          false,
      'notification': results[ph.Permission.notification]?.isGranted ?? false,
    };
  }
}

