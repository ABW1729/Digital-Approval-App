import 'package:flutter/material.dart';
import 'package:flutter_root_checker/flutter_root_checker.dart';
import 'package:flutter/services.dart';
import 'package:flutter_windowmanager_plus/flutter_windowmanager_plus.dart';
import 'package:vpn_connection_detector/vpn_connection_detector.dart';

class SecurityCheck {
  static Future<void> runChecks(BuildContext context) async {
    bool isVpn = await VpnConnectionDetector.isVpnActive();
    bool isRooted = await FlutterRootChecker.isAndroidRoot ?? false;

    bool isBeingRecorded = false;
    try {
      await FlutterWindowManagerPlus.addFlags(FlutterWindowManagerPlus.FLAG_SECURE);
    } catch (_) {
      isBeingRecorded = true;
    }

    if (isVpn) {
      _showAndExit(context, "VPN detected. Please disable it to continue.");
    } else if (isRooted) {
      _showAndExit(context, "Rooted device is not allowed for security reasons.");
    } else if (isBeingRecorded) {
      _showAndExit(context, "Screen recording is active. Please disable it.");
    }
  }

  static void _showAndExit(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Security Alert"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              SystemNavigator.pop(); // Exit app
            },
            child: Text("Exit"),
          )
        ],
      ),
    );
  }
}
