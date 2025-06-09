import 'package:flutter/material.dart';
import '../services/api_service.dart';

class InboxPage extends StatefulWidget {
  @override
  _InboxPageState createState() => _InboxPageState();
}

class _InboxPageState extends State<InboxPage> {
  List<Map<String, dynamic>> messages = [];

  @override
  void initState() {
    super.initState();
    _classifyMessages();
  }

  Future<void> _classifyMessages() async {
    final result = await ApiService.classifyMessages();
    if (result['success']) {
      setState(() {
        messages = List<Map<String, dynamic>>.from(result['messages']);
      });
    } else {
      print("❌ Classification failed: ${result['error']}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Messages'),
        automaticallyImplyLeading: false,
      ),
      body: messages.isEmpty
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: _classifyMessages,
        child: ListView.separated(
          itemCount: messages.length,
          separatorBuilder: (_, __) => Divider(),
          itemBuilder: (context, index) {
            final msg = messages[index];
            return ListTile(
              leading: Icon(Icons.sms),
              title: Text(msg['sender'] ?? ''),
              subtitle: Text(msg['content'] ?? ''),
              trailing: Text(
                msg['label'] ?? '',
                style: TextStyle(
                  color: msg['label'] == 'Spam'
                      ? Colors.red
                      : msg['label'] == 'Suspicious'
                      ? Colors.orange
                      : Colors.green,
                ),
              ),
              onTap: () {
                // Future: show full message or actions
              },
            );
          },
        ),
      ),
    );
  }


}
