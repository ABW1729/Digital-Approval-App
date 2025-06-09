import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../services/api_service.dart';
import 'transaction_model.dart';
import '../utils/device.dart';
import '../services/tts_service.dart';
Future<void> sendPayment({
  required BuildContext context,
  required TextEditingController upiController,
  required TextEditingController amountController,
  required TextEditingController noteController,
  required TextEditingController nameController,
  required TTSService tts,
}) async {
  final upi = upiController.text.trim();
  final amount = amountController.text.trim();
  final note = noteController.text.trim();
  final name = nameController.text
      .trim()
      .isNotEmpty ? nameController.text : "व्यक्ति";

  if (upi.isEmpty || amount.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Please fill all required fields")),
    );
    return;
  }

  await tts.speak("आप ₹$amount रुपये $name को भेज रहे हैं");


  final location = await DeviceUtils.getCurrentLocation();
  final deviceId = await DeviceUtils.getDeviceId();
  final ipAddress = await DeviceUtils.getPublicIp();
  final transaction = Transaction(
    transactionId: "TXN${DateTime
        .now()
        .millisecondsSinceEpoch}",
    txnTimestamp: DateTime.now().toIso8601String(),
    rrn: "RRN${DateTime
        .now()
        .millisecondsSinceEpoch}",
    trnStatus: "SUCCESS",
    amount: amount,
    responseCode: "00",
    payerVpa: "yourVPA@upi",
    payerCode: "PYR123",
    payerIfsc: "HDFC0000123",
    payerAccount: "1234567890",
    beneficiaryVpa: upi,
    beneficiaryCode: "BENE456",
    beneficiaryIfsc: "ICIC0000456",
    beneficiaryAccount: "9876543210",
    longitude: location?.longitude.toString() ?? '',
    latitude: location?.latitude.toString() ?? '',
    deviceId: deviceId ?? '',
    ipAddress: ipAddress ?? '',
    initiationMode: "APP",
    upiLiteLrn: "NA",
    cardNumber: "NA",
    transactionType: "P2P",
    paymentInstrument: "UPI",
    isFraud: false,
  );

  final prediction = await ApiService.predict(transaction.toJson());

  if (prediction['is_fraud'] == true) {
    showDialog(
      context: context,
      builder: (_) =>
          AlertDialog(
            title: const Text("⚠️ Fraud Alert"),
            content: const Text("This transaction seems fraudulent."),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              )
            ],
          ),
    );
    return;
  }

  await ApiService.reportTransaction(transaction);

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text("₹$amount sent to $upi. Note: $note")),
  );

  Navigator.pop(context);
}

