import 'package:flutter/material.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import 'package:flutter/foundation.dart';
// Send via Bank
class SendBankPage extends StatefulWidget {
  const SendBankPage({super.key});

  @override
  State<SendBankPage> createState() => _SendBankPageState();
}

class _SendBankPageState extends State<SendBankPage> {
  final _accountController = TextEditingController();
  final _ifscController = TextEditingController();
  final _amountController = TextEditingController();

  void send() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("₹${_amountController.text} sent to A/C ${_accountController.text}")),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text("Send via Bank Account")),
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(controller: _accountController, decoration: const InputDecoration(labelText: "Account Number")),
          TextField(controller: _ifscController, decoration: const InputDecoration(labelText: "IFSC Code")),
          TextField(controller: _amountController, decoration: const InputDecoration(labelText: "Amount (₹)"), keyboardType: TextInputType.number),
          const SizedBox(height: 20),
          ElevatedButton(onPressed: send, child: const Text("Send Money"))
        ],
      ),
    ),
  );
}

// Send via Phone
class SendPhonePage extends StatefulWidget {
  const SendPhonePage({super.key});

  @override
  State<SendPhonePage> createState() => _SendPhonePageState();
}

class _SendPhonePageState extends State<SendPhonePage> {
  final _phoneController = TextEditingController();
  final _amountController = TextEditingController();

  void send() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("₹${_amountController.text} sent to ${_phoneController.text}")),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text("Send via Phone Number")),
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(controller: _phoneController, decoration: const InputDecoration(labelText: "Phone Number"), keyboardType: TextInputType.phone),
          TextField(controller: _amountController, decoration: const InputDecoration(labelText: "Amount (₹)"), keyboardType: TextInputType.number),
          const SizedBox(height: 20),
          ElevatedButton(onPressed: send, child: const Text("Send Money"))
        ],
      ),
    ),
  );
}

// Request via UPI
class RequestUpiPage extends StatefulWidget {
  const RequestUpiPage({super.key});

  @override
  State<RequestUpiPage> createState() => _RequestUpiPageState();
}

class _RequestUpiPageState extends State<RequestUpiPage> {
  final _upiController = TextEditingController();
  final _amountController = TextEditingController();

  void request() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("₹${_amountController.text} requested from ${_upiController.text}")),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text("Request via UPI ID")),
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(controller: _upiController, decoration: const InputDecoration(labelText: "Recipient UPI ID")),
          TextField(controller: _amountController, decoration: const InputDecoration(labelText: "Amount (₹)"), keyboardType: TextInputType.number),
          const SizedBox(height: 20),
          ElevatedButton(onPressed: request, child: const Text("Send Request"))
        ],
      ),
    ),
  );
}

// Request via Phone
class RequestPhonePage extends StatefulWidget {
  const RequestPhonePage({super.key});

  @override
  State<RequestPhonePage> createState() => _RequestPhonePageState();
}

class _RequestPhonePageState extends State<RequestPhonePage> {
  final _phoneController = TextEditingController();
  final _amountController = TextEditingController();

  void request() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("₹${_amountController.text} requested from ${_phoneController.text}")),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text("Request via Phone Number")),
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(controller: _phoneController, decoration: const InputDecoration(labelText: "Phone Number"), keyboardType: TextInputType.phone),
          TextField(controller: _amountController, decoration: const InputDecoration(labelText: "Amount (₹)"), keyboardType: TextInputType.number),
          const SizedBox(height: 20),
          ElevatedButton(onPressed: request, child: const Text("Send Request"))
        ],
      ),
    ),
  );
}

// Pending Requests
class PendingRequestPage extends StatelessWidget {
  const PendingRequestPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text("Pending Requests")),
    body: ListView(
      children: [
        ListTile(
          title: const Text("Request from Rahul (₹500)"),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.check, color: Colors.green)),
              IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close, color: Colors.red)),
            ],
          ),
        ),
        const Divider(),
      ],
    ),
  );
}

// QR Scanner Placeholder
class QrScannerPage extends StatefulWidget {
  const QrScannerPage({super.key});

  @override
  State<QrScannerPage> createState() => _QrScannerPageState();
}

class _QrScannerPageState extends State<QrScannerPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  String? scannedData;

  @override
  void reassemble() {
    super.reassemble();
    if (defaultTargetPlatform == TargetPlatform.android) {
      controller!.pauseCamera();
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      controller!.resumeCamera();
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;

    controller.scannedDataStream.listen((scanData) {
      controller.pauseCamera();

      final scanned = scanData.code?.trim() ?? '';
      final uri = Uri.tryParse(scanned);

      final upiId = uri?.queryParameters['pa'];
      final name = uri?.queryParameters['pn'] ?? '';
      final amount = uri?.queryParameters['am'] ?? '';

      final upiRegex = RegExp(r'^[\w.-]+@[\w.-]+$');

      if (upiId != null && upiRegex.hasMatch(upiId)) {
        Navigator.popAndPushNamed(
          context,
          '/send_upi',
          arguments: {
            'upi': upiId,
            'name': Uri.decodeComponent(name),
            'amount': amount,
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("⚠️ Invalid UPI"),
            content: const Text("The scanned QR code does not contain a valid UPI ID."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  controller.resumeCamera();
                },
                child: const Text("Scan Again"),
              )
            ],
          ),
        );
      }

      setState(() {
        scannedData = scanned;
      });
    });
  }




  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text("Scan QR Code")),
    body: Column(
      children: [
        Expanded(
          flex: 4,
          child: QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
          ),
        ),
        Expanded(
          flex: 1,
          child: Center(
            child: scannedData != null
                ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Scanned: $scannedData"),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.popAndPushNamed(
                      context,
                      '/send_upi',
                      arguments: {
                        'upi': scannedData,
                      },
                    );
                  },
                  child: const Text("Use This UPI"),
                )
              ],
            )
                : const Text("Scan a QR code"),
          ),
        )
      ],
    ),
  );
}

