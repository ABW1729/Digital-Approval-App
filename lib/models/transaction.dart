class Transaction {
  final String transactionId;
  final String userId;
  final double amount;
  final String timestamp;
  final String merchantCategory;
  final String transactionType;
  final int fraudRisk;

  Transaction({
    required this.transactionId,
    required this.userId,
    required this.amount,
    required this.timestamp,
    required this.merchantCategory,
    required this.transactionType,
    required this.fraudRisk,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      transactionId: json['TransactionID'],
      userId: json['UserID'],
      amount: json['Amount'].toDouble(),
      timestamp: json['Timestamp'],
      merchantCategory: json['MerchantCategory'],
      transactionType: json['TransactionType'],
      fraudRisk: json['FraudRisk'],
    );
  }
}
