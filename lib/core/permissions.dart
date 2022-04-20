import 'dart:io';

import 'package:permission_handler/permission_handler.dart';

import 'request_services.dart';

class RequestPermissionCamera extends RequestPermissionService {
  RequestPermissionCamera() : super(Permission.camera);
}

class RequestPermissionPhotos extends RequestPermissionService {
  RequestPermissionPhotos()
      : super(Platform.isAndroid ? Permission.storage : Permission.photos);
}
