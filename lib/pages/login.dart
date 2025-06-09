import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'register.dart';
import '../services/otp_verification.dart';
class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _phoneController = TextEditingController();
  String? error;

  void login() async {
    final phone = _phoneController.text;
    final result = await ApiService.login(phone);
    if (result['success']) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OtpVerificationPage(phone: phone, fromLogin: true),
        ),
      );

    } else {
      setState(() {
        error = result['error'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _phoneController, decoration: InputDecoration(labelText: 'Phone Number')),
            SizedBox(height: 12),
            if (error != null) Text(error!, style: TextStyle(color: Colors.red)),
            ElevatedButton(onPressed: login, child: Text("Login")),
            TextButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => RegisterPage())),
                child: Text("Don't have an account? Register")
            )
          ],
        ),
      ),
    );
  }
}
