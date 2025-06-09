import 'package:flutter/material.dart';
import 'pages/login.dart';
import 'package:local_auth/local_auth.dart';
import 'pages/dashboard.dart';
import 'pages/send_money.dart';
import 'pages/send_upi.dart';
import 'pages/send_bank.dart';
import 'pages/inbox.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(DigiRakshakApp());
}

class DigiRakshakApp extends StatefulWidget {
  @override
  State<DigiRakshakApp> createState() => _DigiRakshakAppState();
}

class _DigiRakshakAppState extends State<DigiRakshakApp> {
  bool _initialized = false;
  bool _authenticated = false;


  @override
  void initState() {
    super.initState();
    _runChecksAndAuthenticate();
    const MethodChannel('digirakshak/sms').setMethodCallHandler((call) async {
      if (call.method == 'newSms') {
        final sms = Map<String, dynamic>.from(call.arguments);
        print("📥 New SMS received: ${sms['sender']} - ${sms['body']}");

        // Optionally: show a snackbar
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("New SMS from ${sms['sender']}"),
          ));
        }

        // Optionally: trigger backend classification
        // await ApiService.classifyOne(sms['sender'], sms['body']);
      }
      return null;
    });
  }

  Future<void> _runChecksAndAuthenticate() async {
    // Security Checks
    // await Future.delayed(Duration.zero, () => SecurityCheck.runChecks(context));

    // Biometric Authentication
    final auth = LocalAuthentication();
    bool allowed = await auth.canCheckBiometrics;
    bool success = false;

    if (allowed) {
      success = await auth.authenticate(
        localizedReason: 'Please authenticate to use DigiRakshak',
        options: const AuthenticationOptions(biometricOnly: true),
      );
    } else {
      success = true; // fallback if biometric is unavailable
    }

    setState(() {
      _authenticated = success;
      _initialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DigiRakshak',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: _initialized
          ? (_authenticated ? LoginPage() : Center(child: Text("Authentication failed.")))
          : Center(child: CircularProgressIndicator()),
        routes: {
          '/dashboard': (context) => DashboardPage(),
          '/send': (context) => SendMoneyPage(),
          '/send_upi': (context) => SendUpiPage(),
          '/send_bank': (context) => SendBankPage(),
          '/send_phone': (context) => SendPhonePage(),
          '/request_upi': (context) => RequestUpiPage(),
          '/request_phone': (context) => RequestPhonePage(),
          '/pending_requests': (context) => PendingRequestPage(),
          '/scan_qr': (context) => QrScannerPage(),
          '/inbox': (context) => InboxPage(),
        },
    );
  }
}
