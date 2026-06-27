import 'dart:convert';

class Room {
  final String roomNumber;
  final int floor;
  final bool isOccupied;
  final String? currentTenantId;
  final String? currentTenantName;
  final double baseRentAmount;
  final double lastMeterReading;
  final double pendingRent;
  final double pendingElectricity;

  Room({
    required this.roomNumber,
    required this.floor,
    required this.isOccupied,
    this.currentTenantId,
    this.currentTenantName,
    required this.baseRentAmount,
    required this.lastMeterReading,
    this.pendingRent = 0.0,
    this.pendingElectricity = 0.0,
  });

  Room copyWith({
    String? roomNumber,
    int? floor,
    bool? isOccupied,
    String? currentTenantId,
    String? currentTenantName,
    double? baseRentAmount,
    double? lastMeterReading,
    double? pendingRent,
    double? pendingElectricity,
  }) {
    return Room(
      roomNumber: roomNumber ?? this.roomNumber,
      floor: floor ?? this.floor,
      isOccupied: isOccupied ?? this.isOccupied,
      currentTenantId: currentTenantId ?? this.currentTenantId,
      currentTenantName: currentTenantName ?? this.currentTenantName,
      baseRentAmount: baseRentAmount ?? this.baseRentAmount,
      lastMeterReading: lastMeterReading ?? this.lastMeterReading,
      pendingRent: pendingRent ?? this.pendingRent,
      pendingElectricity: pendingElectricity ?? this.pendingElectricity,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'roomNumber': roomNumber,
      'floor': floor,
      'isOccupied': isOccupied,
      'currentTenantId': currentTenantId,
      'currentTenantName': currentTenantName,
      'baseRentAmount': baseRentAmount,
      'lastMeterReading': lastMeterReading,
      'pendingRent': pendingRent,
      'pendingElectricity': pendingElectricity,
    };
  }

  factory Room.fromMap(Map<String, dynamic> map) {
    return Room(
      roomNumber: map['roomNumber'] ?? '',
      floor: map['floor']?.toInt() ?? 1,
      isOccupied: map['isOccupied'] ?? false,
      currentTenantId: map['currentTenantId'],
      currentTenantName: map['currentTenantName'],
      baseRentAmount: (map['baseRentAmount'] as num?)?.toDouble() ?? 8000.0,
      lastMeterReading: (map['lastMeterReading'] as num?)?.toDouble() ?? 0.0,
      pendingRent: (map['pendingRent'] as num?)?.toDouble() ?? 0.0,
      pendingElectricity: (map['pendingElectricity'] as num?)?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Room.fromJson(String source) => Room.fromMap(json.decode(source));
}
