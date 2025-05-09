import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';
import 'package:flutter/foundation.dart'; 

Future<String> getDeviceName() async {
  final deviceInfo = DeviceInfoPlugin();

  if (kIsWeb) {
    final webInfo = await deviceInfo.webBrowserInfo;
    return '${webInfo.browserName.name} ${webInfo.userAgent}';
  } else {
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      return '${androidInfo.brand} ${androidInfo.model}';
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      return '${iosInfo.name} ${iosInfo.model}';
    } else {
      return 'Unknown Device';
    }
  }
}
