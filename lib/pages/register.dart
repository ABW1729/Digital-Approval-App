import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'login.dart';
import '../services/otp_verification.dart';
class RegisterPage extends StatefulWidget {
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  String? error;
  String? success;

  void register() async {
    final phone = _phoneController.text;
    final email = _emailController.text;

    final result = await ApiService.register(phone, email);
    if (result['success']) {
      setState(() {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (_) => OtpVerificationPage(phone: phone)));
        error = null;
      });
    } else {
      setState(() {
        error = result['error'];
        success = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Register")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _phoneController, decoration: InputDecoration(labelText: 'Phone')),
            TextField(controller: _emailController, decoration: InputDecoration(labelText: 'Email')),
            SizedBox(height: 12),
            if (error != null) Text(error!, style: TextStyle(color: Colors.red)),
            if (success != null) Text(success!, style: TextStyle(color: Colors.green)),
            ElevatedButton(onPressed: register, child: Text("Register")),
            TextButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => LoginPage())),
                child: Text("Already registered? Log in")
            )
          ],
        ),
      ),
    );
  }
}
