import 'package:flutter/material.dart';

class DashboardContent extends StatelessWidget {
  final Function(BuildContext) onSend;
  final Function(BuildContext) onRequest;
  final Function(BuildContext) onPending;
  final Function(BuildContext) onScan;

  DashboardContent({
    required this.onSend,
    required this.onRequest,
    required this.onPending,
    required this.onScan,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildActionSection(context),
        Expanded(child: _buildRecentTransactionList(context)),
      ],
    );
  }

  Widget _buildActionSection(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            _actionTile(context, Icons.send, "Send Money", onSend),
            _actionTile(context, Icons.request_page, "Request Money", onRequest),
          ],
        ),
        Row(
          children: [
            _actionTile(context, Icons.pending_actions, "Pending Requests", onPending),
            _actionTile(context, Icons.qr_code_scanner, "Scan QR", onScan),
          ],
        ),
      ],
    );
  }

  Widget _actionTile(BuildContext context, IconData icon, String label, Function(BuildContext) onTap) {
    return Expanded(
      child: InkWell(
        onTap: () => onTap(context),
        child: Card(
          margin: EdgeInsets.all(8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 32),
                SizedBox(height: 8),
                Text(label, textAlign: TextAlign.center),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRecentTransactionList(BuildContext context) {
    final dummyData = [
      {"sender": "Aniket Wani", "amount": "₹1500", "upi": "aniket@upi"},
      {"sender": "Rahul Kumar", "amount": "₹600", "upi": "rahul@ybl"},
      {"sender": "Priya Singh", "amount": "₹220", "upi": "priya@oksbi"},
    ];

    return ListView.builder(
      itemCount: dummyData.length,
      itemBuilder: (_, index) {
        final tx = dummyData[index];
        return ListTile(
          title: Text("${tx['sender']}"),
          subtitle: Text("Amount: ${tx['amount']}"),
          trailing: Icon(Icons.arrow_forward),
          onTap: () {
            Navigator.pushNamed(context, '/send', arguments: {
              "upi": tx['upi'],
              "name": tx['sender'],
              "amount": tx['amount']
            });
          },
        );
      },
    );
  }
}
