import 'package:flutter/material.dart';
import 'package:digirakshak/services/tts_service.dart';
class SendMoneyPage extends StatefulWidget {
  final String? upi;
  final String? name;
  final String? amount;

  const SendMoneyPage({this.upi, this.name, this.amount, super.key});

  @override
  State<SendMoneyPage> createState() => _SendMoneyPageState();
}

class _SendMoneyPageState extends State<SendMoneyPage> {
  final _upiController = TextEditingController();
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  final TTSService tts = TTSService();

  @override
  void initState() {
    super.initState();
    if (widget.upi != null) _upiController.text = widget.upi!;
    if (widget.name != null) _nameController.text = widget.name!;
    if (widget.amount != null) _amountController.text = widget.amount!;
  }

  void sendPayment() async {
    final upi = _upiController.text.trim();
    final amount = _amountController.text.trim();
    final note = _noteController.text.trim();
    final name = _nameController.text.trim().isNotEmpty ? _nameController.text : "व्यक्ति";

    if (upi.isEmpty || amount.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all required fields")),
      );
      return;
    }

    await tts.speak("आप ₹$amount रुपये $name को भेज रहे हैं");

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("₹$amount sent to $upi. Note: $note")),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Send Money")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _nameController, decoration: InputDecoration(labelText: "Recipient Name")),
            TextField(controller: _upiController, decoration: InputDecoration(labelText: "UPI ID")),
            TextField(
              controller: _noteController,
              decoration: const InputDecoration(labelText: "Note (optional)"),
            ),
            TextField(
              controller: _amountController,
              decoration: InputDecoration(labelText: "Amount (₹)"),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: sendPayment,
              child: Text("Send Money"),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _upiController.dispose();
    _amountController.dispose();
    _noteController.dispose(); // make sure this matches your controllers
    super.dispose();
  }

}
