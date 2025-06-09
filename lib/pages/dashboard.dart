import 'package:flutter/material.dart';
import 'inbox.dart';
import 'dashboard_content.dart';
class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      DashboardContent(
        onSend: _openSendOptions,
        onRequest: _openRequestOptions,
        onPending: _openPendingRequests,
        onScan: _scanQrCode,
      ),
      InboxPage(),
    ];
  }


  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _selectedIndex == 0
          ? AppBar(
        title: const Text('Dashboard'),
        automaticallyImplyLeading: false,
      )
          : null, // Hide AppBar for Inbox tab
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onTabTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.sms), label: 'Inbox'),
        ],
      ),
    );
  }


  Widget _buildActionSection(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            _actionTile(context, Icons.send, "Send Money", _openSendOptions),
            _actionTile(context, Icons.request_page, "Request Money", _openRequestOptions),
          ],
        ),
        Row(
          children: [
            _actionTile(context, Icons.pending_actions, "Pending Requests", _openPendingRequests),
            _actionTile(context, Icons.qr_code_scanner, "Scan QR", _scanQrCode),
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
            // Navigate to send screen with UPI prefilled
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

  void _openSendOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Wrap(
        children: [
          ListTile(title: Text("Send via UPI ID"), onTap: () => Navigator.pushNamed(context, "/send_upi")),
          ListTile(title: Text("Send via Bank Account"), onTap: () => Navigator.pushNamed(context, "/send_bank")),
          ListTile(title: Text("Send via Phone Number"), onTap: () => Navigator.pushNamed(context, "/send_phone")),
        ],
      ),
    );
  }

  void _openRequestOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Wrap(
        children: [
          ListTile(title: Text("Request via UPI ID"), onTap: () => Navigator.pushNamed(context, "/request_upi")),
          ListTile(title: Text("Request via Phone Number"), onTap: () => Navigator.pushNamed(context, "/request_phone")),
        ],
      ),
    );
  }

  void _openPendingRequests(BuildContext context) {
    Navigator.pushNamed(context, '/pending_requests');
  }

  void _scanQrCode(BuildContext context) {
    Navigator.pushNamed(context, '/scan_qr');
  }
}
