import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/room_model.dart';
import '../models/electricity_model.dart';
import '../theme/app_theme.dart';

class ElectricityScreen extends StatefulWidget {
  final List<Room> rooms;
  final double electricityRate;
  final Function(ElectricityReading) onAddMeterReading;

  const ElectricityScreen({
    super.key,
    required this.rooms,
    required this.electricityRate,
    required this.onAddMeterReading,
  });

  @override
  State<ElectricityScreen> createState() => _ElectricityScreenState();
}

class _ElectricityScreenState extends State<ElectricityScreen> {
  final _controllers = <String, TextEditingController>{};

  @override
  void dispose() {
    for (var ctrl in _controllers.values) {
      ctrl.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);
    final occupiedRooms = widget.rooms.where((r) => r.isOccupied).toList();

    return occupiedRooms.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.flash_off, size: 64, color: Colors.grey[300]),
                const SizedBox(height: 12),
                const Text('No occupied rooms to bill electricity', style: TextStyle(color: AppTheme.textLight)),
              ],
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: occupiedRooms.length,
            itemBuilder: (context, index) {
              final room = occupiedRooms[index];
              
              // Maintain unique controller per room
              final controller = _controllers.putIfAbsent(
                room.roomNumber,
                () => TextEditingController(text: (room.lastMeterReading + 40.0).toString()),
              );

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.between,
                        children: [
                          Text(
                            'Room ${room.roomNumber} - ${room.currentTenantName}',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.textDark),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.amber[50],
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: Colors.amber[200]!),
                            ),
                            child: Text(
                              'Rate: ₹${widget.electricityRate}/unit',
                              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.amber[900]),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('PREVIOUS READING', style: TextStyle(fontSize: 10, color: AppTheme.textLight)),
                                const SizedBox(height: 4),
                                Text('${room.lastMeterReading} kWh', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('CURRENT READING', style: TextStyle(fontSize: 10, color: AppTheme.textLight)),
                                const SizedBox(height: 4),
                                SizedBox(
                                  height: 40,
                                  child: TextField(
                                    controller: controller,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                      border: OutlineInputBorder(),
                                    ),
                                    onChanged: (val) {
                                      setState(() {}); // Trigger rebuild to recalculate values live
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.between,
                        children: [
                          _buildCalculatedUnits(room.lastMeterReading, controller.text),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.secondaryColor,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              minimumSize: Size.zero,
                            ),
                            onPressed: () {
                              final curr = double.tryParse(controller.text) ?? 0.0;
                              if (curr < room.lastMeterReading) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Error: Current reading cannot be less than previous.')),
                                );
                                return;
                              }
                              
                              widget.onAddMeterReading(ElectricityReading(
                                id: 'E_${room.roomNumber}_${DateTime.now().millisecondsSinceEpoch}',
                                roomNumber: room.roomNumber,
                                monthYear: 'June 2026',
                                previousReading: room.lastMeterReading,
                                currentReading: curr,
                                ratePerUnit: widget.electricityRate,
                                readingDate: DateTime.now(),
                              ));
                              
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Electricity bill generated for Room ${room.roomNumber}!')),
                              );
                            },
                            icon: const Icon(Icons.check, size: 14),
                            label: const Text('Add to Invoice', style: TextStyle(fontSize: 12)),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          );
  }

  Widget _buildCalculatedUnits(double prev, String currText) {
    final curr = double.tryParse(currText) ?? 0.0;
    final units = (curr - prev).clamp(0, double.infinity).toInt();
    final cost = units * widget.electricityRate;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.bolt, size: 14, color: Colors.amber),
            const SizedBox(width: 4),
            Text(
              'Consuming: $units units',
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppTheme.textDark),
            ),
          ],
        ),
        Text(
          'Rent Add-on: ₹${cost.toStringAsFixed(0)}',
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.primaryColor),
        )
      ],
    );
  }
}
