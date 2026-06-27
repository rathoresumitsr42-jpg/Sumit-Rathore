import 'dart:convert';

class ElectricityReading {
  final String id;
  final String roomNumber;
  final String monthYear; // e.g. "June 2026"
  final double previousReading;
  final double currentReading;
  final double ratePerUnit;
  final DateTime readingDate;
  final bool isBilled;
  final bool isPaid;

  ElectricityReading({
    required this.id,
    required this.roomNumber,
    required this.monthYear,
    required this.previousReading,
    required this.currentReading,
    required this.ratePerUnit,
    required this.readingDate,
    this.isBilled = true,
    this.isPaid = false,
  });

  int get unitsConsumed => (currentReading - previousReading).clamp(0, double.infinity).toInt();
  double get totalAmount => unitsConsumed * ratePerUnit;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'roomNumber': roomNumber,
      'monthYear': monthYear,
      'previousReading': previousReading,
      'currentReading': currentReading,
      'ratePerUnit': ratePerUnit,
      'readingDate': readingDate.toIso8601String(),
      'isBilled': isBilled,
      'isPaid': isPaid,
    };
  }

  factory ElectricityReading.fromMap(Map<String, dynamic> map) {
    return ElectricityReading(
      id: map['id'] ?? '',
      roomNumber: map['roomNumber'] ?? '',
      monthYear: map['monthYear'] ?? '',
      previousReading: (map['previousReading'] as num?)?.toDouble() ?? 0.0,
      currentReading: (map['currentReading'] as num?)?.toDouble() ?? 0.0,
      ratePerUnit: (map['ratePerUnit'] as num?)?.toDouble() ?? 8.0,
      readingDate: DateTime.parse(map['readingDate'] ?? DateTime.now().toIso8601String()),
      isBilled: map['isBilled'] ?? true,
      isPaid: map['isPaid'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory ElectricityReading.fromJson(String source) => ElectricityReading.fromMap(json.decode(source));
}
