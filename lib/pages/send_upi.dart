import 'package:flutter/material.dart';
import 'package:digirakshak/services/tts_service.dart';
import '../services/api_service.dart';
import '../utils/device.dart';
import 'transaction_model.dart';
import 'payment.dart';

class SendUpiPage extends StatefulWidget {
  const SendUpiPage({super.key});

  @override
  State<SendUpiPage> createState() => _SendUpiPageState();
}

class _SendUpiPageState extends State<SendUpiPage> {
  final _upiController = TextEditingController();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  final _nameController = TextEditingController();
  final TTSService tts = TTSService();




  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map?;
    if (args != null) {
      _upiController.text = args['upi'] ?? '';
      _noteController.text = args['name'] ?? '';
      _amountController.text = args['amount'] ?? '';
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Send via UPI ID")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _upiController,
              decoration: const InputDecoration(labelText: "Recipient UPI ID"),
            ),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Amount (₹)"),
            ),
            TextField(
              controller: _noteController,
              decoration: const InputDecoration(labelText: "Note (optional)"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await sendPayment(
                  context: context,
                  upiController: _upiController,
                  amountController: _amountController,
                  noteController: _noteController,
                  nameController: _nameController,
                  tts: tts,
                );
              },
              child: const Text("Send Money"),
            )
          ],
        ),
      ),
    );
  }
}
