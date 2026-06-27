import 'dart:convert';

class Tenant {
  final String id;
  final String name;
  final String phone;
  final String roomNumber;
  final DateTime joinDate;
  final double securityDeposit;
  final bool isActive;
  final double initialMeterReading;

  Tenant({
    required this.id,
    required this.name,
    required this.phone,
    required this.roomNumber,
    required this.joinDate,
    required this.securityDeposit,
    this.isActive = true,
    required this.initialMeterReading,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'roomNumber': roomNumber,
      'joinDate': joinDate.toIso8601String(),
      'securityDeposit': securityDeposit,
      'isActive': isActive,
      'initialMeterReading': initialMeterReading,
    };
  }

  factory Tenant.fromMap(Map<String, dynamic> map) {
    return Tenant(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      roomNumber: map['roomNumber'] ?? '',
      joinDate: DateTime.parse(map['joinDate'] ?? DateTime.now().toIso8601String()),
      securityDeposit: (map['securityDeposit'] as num?)?.toDouble() ?? 0.0,
      isActive: map['isActive'] ?? true,
      initialMeterReading: (map['initialMeterReading'] as num?)?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Tenant.fromJson(String source) => Tenant.fromMap(json.decode(source));
}
