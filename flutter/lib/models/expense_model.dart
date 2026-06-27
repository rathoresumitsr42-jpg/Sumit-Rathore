import 'dart:convert';

class Expense {
  final String id;
  final String title;
  final String category; // Repairs, Cleaning, Water, Salary, Others
  final double amount;
  final DateTime date;
  final String paymentMode; // Cash, UPI, Bank Transfer
  final String? remarks;

  Expense({
    required this.id,
    required this.title,
    required this.category,
    required this.amount,
    required this.date,
    required this.paymentMode,
    this.remarks,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'amount': amount,
      'date': date.toIso8601String(),
      'paymentMode': paymentMode,
      'remarks': remarks,
    };
  }

  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      category: map['category'] ?? 'Others',
      amount: (map['amount'] as num?)?.toDouble() ?? 0.0,
      date: DateTime.parse(map['date'] ?? DateTime.now().toIso8601String()),
      paymentMode: map['paymentMode'] ?? 'UPI',
      remarks: map['remarks'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Expense.fromJson(String source) => Expense.fromMap(json.decode(source));

  Expense copyWith({
    String? id,
    String? title,
    String? category,
    double? amount,
    DateTime? date,
    String? paymentMode,
    String? remarks,
  }) {
    return Expense(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      paymentMode: paymentMode ?? this.paymentMode,
      remarks: remarks ?? this.remarks,
    );
  }
}
