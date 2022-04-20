import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

// Single Permission Request
abstract class RequestPermissionService {
  final Permission permission;

  RequestPermissionService(this.permission);

  Future<void> request({
    required final OnPermatentlyDenied onPermatentlyDenied,
    required final OnGranted onGranted,
    required int requestedCount,
  }) async {
    PermissionStatus status = await permission.status;
    bool isShown = await permission.shouldShowRequestRationale;

    if (status.isPermanentlyDenied || status.isRestricted) {
      onPermatentlyDenied.call();
      return;
    }
    if (!status.isLimited && !status.isGranted) {
      final PermissionStatus result = await permission.request();
      if (requestedCount != 0 && !isShown && Platform.isAndroid) {
        onPermatentlyDenied.call();
        return;
      }

      if (!result.isGranted) {
        if (result.isPermanentlyDenied) {
          onPermatentlyDenied.call();
        }
        return;
      }
    }
    onGranted.call();
  }
}

// Multiple Permission Request
abstract class RequestMultiplePermissionService {
  final List<Permission> permissions;

  RequestMultiplePermissionService(this.permissions);

  Future<void> request({
    required final OnCallback onCallback,
  }) async {
    Map<Permission, PermissionStatus> statuses = await permissions.request();
    onCallback.call(statuses);
  }
}

// Common Function
typedef OnPermatentlyDenied = void Function();
typedef OnGranted = void Function();

// Used in multiple permision request
typedef OnCallback = void Function(Map<Permission, PermissionStatus>);
