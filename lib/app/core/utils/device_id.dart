import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform;
import 'package:uuid/uuid.dart';

class DeviceID {
  static final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();

  static Future<String> deviceUUID() async {
    List<dynamic> info = [];
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        var data = await _deviceInfoPlugin.androidInfo;
        info.addAll([
          data.id,
          data.serialNumber,
          data.name,
          data.model,
          data.device,
        ]);
        return Uuid().v5(Namespace.nil.value, info.join('-'));

      case TargetPlatform.iOS:
        var data = await _deviceInfoPlugin.iosInfo;

        return data.identifierForVendor!;
      default:
        throw UnsupportedError("Unsupported platform");
    }
  }
}
