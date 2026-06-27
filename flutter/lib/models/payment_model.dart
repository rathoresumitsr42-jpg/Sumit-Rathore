import 'dart:convert';

class Payment {
  final String id;
  final String roomNumber;
  final String tenantName;
  final DateTime date;
  final double amountPaid;
  final double rentComponent;
  final double electricityComponent;
  final double previousReading;
  final double currentReading;
  final int unitsConsumed;
  final String paymentMode; // UPI, Cash, Bank Transfer
  final String monthYear; // e.g., "June 2026"
  final String? transactionId;
  final String? remarks;

  Payment({
    required this.id,
    required this.roomNumber,
    required this.tenantName,
    required this.date,
    required this.amountPaid,
    required this.rentComponent,
    required this.electricityComponent,
    required this.previousReading,
    required this.currentReading,
    required this.unitsConsumed,
    required this.paymentMode,
    required this.monthYear,
    this.transactionId,
    this.remarks,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'roomNumber': roomNumber,
      'tenantName': tenantName,
      'date': date.toIso8601String(),
      'amountPaid': amountPaid,
      'rentComponent': rentComponent,
      'electricityComponent': electricityComponent,
      'previousReading': previousReading,
      'currentReading': currentReading,
      'unitsConsumed': unitsConsumed,
      'paymentMode': paymentMode,
      'monthYear': monthYear,
      'transactionId': transactionId,
      'remarks': remarks,
    };
  }

  factory Payment.fromMap(Map<String, dynamic> map) {
    return Payment(
      id: map['id'] ?? '',
      roomNumber: map['roomNumber'] ?? '',
      tenantName: map['tenantName'] ?? '',
      date: DateTime.parse(map['date'] ?? DateTime.now().toIso8601String()),
      amountPaid: (map['amountPaid'] as num?)?.toDouble() ?? 0.0,
      rentComponent: (map['rentComponent'] as num?)?.toDouble() ?? 0.0,
      electricityComponent: (map['electricityComponent'] as num?)?.toDouble() ?? 0.0,
      previousReading: (map['previousReading'] as num?)?.toDouble() ?? 0.0,
      currentReading: (map['currentReading'] as num?)?.toDouble() ?? 0.0,
      unitsConsumed: map['unitsConsumed']?.toInt() ?? 0,
      paymentMode: map['paymentMode'] ?? 'Cash',
      monthYear: map['monthYear'] ?? '',
      transactionId: map['transactionId'],
      remarks: map['remarks'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Payment.fromJson(String source) => Payment.fromMap(json.decode(source));
}
