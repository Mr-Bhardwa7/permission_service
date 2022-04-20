library permission_service;

import 'dart:io';

import 'package:permission_handler/permission_handler.dart';

import 'core/permissions.dart';
import 'core/request_services.dart';

enum AppPermisisons { camera, photoOrGallery }

class PermissionService {
  int _cameraRequestedCount = 0;
  int _photoRequestedCount = 0;

  // Camera Permisison Sample Function
  Future<void> checkCameraPermission({
    required final OnGranted onGranted,
    required final OnPermatentlyDenied onPermissionDenied,
  }) async {
    await RequestPermissionCamera().request(
      onPermatentlyDenied: onPermissionDenied,
      onGranted: onGranted,
      requestedCount: _cameraRequestedCount,
    );
    _cameraRequestedCount = _cameraRequestedCount + 1;
  }

  Future<void> checkPhotoAndGalleryPermisison({
    required final OnGranted onGranted,
    required final OnPermatentlyDenied onPermissionDenied,
  }) async {
    await RequestPermissionPhotos().request(
      onPermatentlyDenied: onPermissionDenied,
      onGranted: onGranted,
      requestedCount: _photoRequestedCount,
    );
    _photoRequestedCount = _photoRequestedCount + 1;
  }

  /* Check has permission */
  static Future<PermissionStatus> hasPermission({
    required AppPermisisons appPermisisons,
  }) async {
    switch (appPermisisons) {
      case AppPermisisons.camera:
        PermissionStatus status = await Permission.camera.status;
        return status;
      case AppPermisisons.photoOrGallery:
        PermissionStatus status = Platform.isAndroid
            ? await Permission.storage.status
            : await Permission.photos.status;
        return status;
    }
  }
}
