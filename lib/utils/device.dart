import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:geolocator/geolocator.dart';
class DeviceUtils {
  static Future<String> getDeviceId() async {
    final deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      String? deviceId = await PlatformDeviceId.getDeviceId;
      return deviceId ?? "unknown";
    } else {
      final iosInfo = await deviceInfo.iosInfo;
      return iosInfo.identifierForVendor ?? "unknown";
    }
  }

  static Future<Map<String, String>> getLocation() async {
    final location = Location();
    final hasPermission = await location.hasPermission();
    if (hasPermission != PermissionStatus.granted) {
      await location.requestPermission();
    }

    final current = await location.getLocation();
    return {
      "latitude": current.latitude?.toString() ?? "",
      "longitude": current.longitude?.toString() ?? "",
    };
  }

  static Future<String> getPublicIp() async {
    try {
      final response = await http.get(Uri.parse("https://api.ipify.org?format=json"));
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return json['ip'];
      }
    } catch (e) {
      print("❌ Failed to fetch IP: $e");
    }
    return "unknown";
  }

  static Future<Position?> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return null;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever ||
          permission == LocationPermission.denied) {
        return null;
      }
    }

    return await Geolocator.getCurrentPosition();
  }
}
