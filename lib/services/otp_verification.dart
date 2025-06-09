import 'package:flutter/material.dart';
import '../services/api_service.dart';

class OtpVerificationPage extends StatefulWidget {
  final String phone;
  final bool fromLogin;
  const OtpVerificationPage({required this.phone, this.fromLogin = false});

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  final _otpController = TextEditingController();
  String? error;

  void verifyOtp() async {
    final otp = _otpController.text.trim();
    final result = widget.fromLogin
        ? await ApiService.verifyLoginOtp(widget.phone, otp)
        : await ApiService.verifyOtp(widget.phone, otp);

    if (result['success']) {
      Navigator.pushReplacementNamed(context, '/dashboard');
    } else {
      setState(() {
        error = result['error'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Verify OTP")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text("Enter the OTP sent to your email"),
            TextField(controller: _otpController, keyboardType: TextInputType.number),
            if (error != null) Text(error!, style: TextStyle(color: Colors.red)),
            ElevatedButton(onPressed: verifyOtp, child: Text("Verify")),
          ],
        ),
      ),
    );
  }
}
