import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DefaultSmsButton extends StatefulWidget {
  @override
  _DefaultSmsButtonState createState() => _DefaultSmsButtonState();
}

class _DefaultSmsButtonState extends State<DefaultSmsButton> {
  static const platform = MethodChannel('digirakshak/sms');
  bool _isDefault = false;

  @override
  void initState() {
    super.initState();
    _checkIfDefaultSmsApp();
  }

  Future<void> _checkIfDefaultSmsApp() async {
    try {
      final bool isDefault = await platform.invokeMethod('isDefaultSms');
      setState(() {
        _isDefault = isDefault;
      });
    } catch (e) {
      print("⚠️ Failed to check default SMS app: $e");
    }
  }

  Future<void> _requestDefaultSmsApp() async {
    try {
      await platform.invokeMethod('requestDefaultSms');
      await _checkIfDefaultSmsApp();
    } catch (e) {
      print("❌ Failed to request default SMS app: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isDefault) {
      return SizedBox(); // already default, don't show anything
    }

    return ElevatedButton(
      onPressed: _requestDefaultSmsApp,
      child: Text("Make DigiRakshak Default SMS App"),
    );
  }
}
