import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../services/api_service.dart';
import '../services/tts_service.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Transaction> transactions = [];
  final TTSService ttsService = TTSService();

  @override
  void initState() {
    super.initState();
    loadTransactions();
  }

  Future<void> loadTransactions() async {
    try {
      final data = await ApiService.fetchTransactions();
      setState(() {
        transactions = data;
      });

      for (var tx in data.where((tx) => tx.fraudRisk >= 2)) {
        await ttsService.speak(
        "Warning! Fraud risk detected for transaction ${tx.transactionId}.");
        }
        } catch (e) {
          print('Error fetching transactions: $e');
        }
      }

  Color getRiskColor(int risk) {
    if (risk == 0) return Colors.green;
    if (risk == 1) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('DigiRakshak Transactions')),
      body: RefreshIndicator(
        onRefresh: loadTransactions,
        child: ListView.builder(
          itemCount: transactions.length,
          itemBuilder: (context, index) {
            final tx = transactions[index];
            return Card(
              color: getRiskColor(tx.fraudRisk).withOpacity(0.1),
              child: ListTile(
                title: Text('Transaction: ${tx.transactionId}'),
                subtitle: Text('${tx.merchantCategory} - \$${tx.amount}'),
                trailing: Icon(Icons.shield, color: getRiskColor(tx.fraudRisk)),
              ),
            );
          },
        ),
      ),
    );
  }
}
