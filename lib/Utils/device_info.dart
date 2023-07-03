import 'dart:io';

import 'package:device_info/device_info.dart';

class DeviceInfo{
  final String deviceModelName;
  final String deviceName;

  DeviceInfo(this.deviceModelName, this.deviceName);

}

Future<DeviceInfo> getDeviceInfo()async{
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  String deviceModelName = "";
  String deviceName = "";

  if (Platform.isAndroid) {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    deviceModelName = androidInfo.model;
    deviceName = "${androidInfo.brand} ${androidInfo.device}";
  } else if (Platform.isIOS) {
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    deviceModelName = iosInfo.model;
    deviceName = "apple ${iosInfo.name}";
  }
  return DeviceInfo(deviceModelName, deviceName);
}