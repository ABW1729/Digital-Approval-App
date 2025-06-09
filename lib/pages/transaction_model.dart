class Transaction {
  final String transactionId;
  final String txnTimestamp;
  final String rrn;
  final String trnStatus;
  final String amount;
  final String responseCode;
  final String payerVpa;
  final String payerCode;
  final String payerIfsc;
  final String payerAccount;
  final String beneficiaryVpa;
  final String beneficiaryCode;
  final String beneficiaryIfsc;
  final String beneficiaryAccount;
  final String longitude;
  final String latitude;
  final String deviceId;
  final String initiationMode;
  final String upiLiteLrn;
  final String cardNumber;
  final String transactionType;
  final String paymentInstrument;
  final String ipAddress;
  final bool isFraud;

  Transaction({
    required this.transactionId,
    required this.txnTimestamp,
    required this.rrn,
    required this.trnStatus,
    required this.amount,
    required this.responseCode,
    required this.payerVpa,
    required this.payerCode,
    required this.payerIfsc,
    required this.payerAccount,
    required this.beneficiaryVpa,
    required this.beneficiaryCode,
    required this.beneficiaryIfsc,
    required this.beneficiaryAccount,
    required this.longitude,
    required this.latitude,
    required this.deviceId,
    required this.initiationMode,
    required this.upiLiteLrn,
    required this.cardNumber,
    required this.transactionType,
    required this.paymentInstrument,
    required this.ipAddress,
    required this.isFraud,
  });

  Map<String, dynamic> toJson() => {
    "TRANSACTION_ID": transactionId,
    "TXN_TIMESTAMP": txnTimestamp,
    "RRN": rrn,
    "TRN_STATUS": trnStatus,
    "AMOUNT": amount,
    "RESPONSE_CODE": responseCode,
    "PAYER_VPA": payerVpa,
    "PAYER_CODE": payerCode,
    "PAYER_IFSC": payerIfsc,
    "PAYER_ACCOUNT": payerAccount,
    "BENEFICIARY_VPA": beneficiaryVpa,
    "BENEFICIARY_CODE": beneficiaryCode,
    "BENEFICIARY_IFSC": beneficiaryIfsc,
    "BENEFICIARY_ACCOUNT": beneficiaryAccount,
    "LONGITUDE": longitude,
    "LATITUDE": latitude,
    "DEVICE_ID": deviceId,
    "INITIATION_MODE": initiationMode,
    "UPI_LITE_LRN": upiLiteLrn,
    "CARD_NUMBER": cardNumber,
    "TRANSACTION_TYPE": transactionType,
    "PAYMENT_INSTRUMENT": paymentInstrument,
    "IP_ADDRESS": ipAddress,
    "IS_FRAUD": isFraud,
  };
}
