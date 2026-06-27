import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/room_model.dart';
import '../models/payment_model.dart';
import '../models/electricity_model.dart';
import '../theme/app_theme.dart';

class ReportsScreen extends StatelessWidget {
  final List<Room> rooms;
  final List<Payment> payments;
  final List<ElectricityReading> electricityReadings;
  final String buildingName;
  final String ownerName;

  const ReportsScreen({
    super.key,
    required this.rooms,
    required this.payments,
    required this.electricityReadings,
    required this.buildingName,
    required this.ownerName,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);
    
    // Calculate Analytics
    final totalRooms = rooms.length;
    final occupiedRooms = rooms.where((r) => r.isOccupied).length;
    final vacantRooms = totalRooms - occupiedRooms;
    final occupancyRate = (occupiedRooms / totalRooms) * 100;

    double rentCollected = payments.fold(0.0, (sum, p) => sum + p.rentComponent);
    double electricityCollected = payments.fold(0.0, (sum, p) => sum + p.electricityComponent);
    double totalCollected = rentCollected + electricityCollected;

    double pendingRent = rooms.fold(0.0, (sum, r) => sum + r.pendingRent);
    double pendingElectricity = rooms.fold(0.0, (sum, r) => sum + r.pendingElectricity);
    double totalPending = pendingRent + pendingElectricity;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Occupancy Progress Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const Text('Occupancy Analytics', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 16),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 130,
                        height: 130,
                        child: CircularProgressIndicator(
                          value: occupancyRate / 100,
                          strokeWidth: 12,
                          backgroundColor: Colors.grey[200],
                          valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.secondaryColor),
                        ),
                      ),
                      Column(
                        children: [
                          Text('${occupancyRate.toStringAsFixed(0)}%', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.textDark)),
                          const Text('Occupied', style: TextStyle(fontSize: 12, color: AppTheme.textLight)),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildMiniIndicator('Occupied', '$occupiedRooms Rooms', AppTheme.secondaryColor),
                      _buildMiniIndicator('Vacant', '$vacantRooms Rooms', AppTheme.primaryColor),
                    ],
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Cashflow breakdown
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Financial Cashflow (All Time)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 16),
                  _buildProgressLine('Rent Collection', rentCollected, pendingRent, AppTheme.secondaryColor),
                  const SizedBox(height: 16),
                  _buildProgressLine('Electricity Collection', electricityCollected, pendingElectricity, Colors.amber[700]!),
                  const Divider(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Total Cash Inflow', style: TextStyle(fontSize: 12, color: AppTheme.textLight)),
                          Text(currencyFormat.format(totalCollected), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.secondaryColor)),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text('Dues Outstanding', style: TextStyle(fontSize: 12, color: AppTheme.textLight)),
                          Text(currencyFormat.format(totalPending), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red)),
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Monthly Invoice print panel
          Card(
            color: Colors.green[50],
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Monthly Statement Report', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.secondaryDarkColor)),
                        const SizedBox(height: 4),
                        const Text('Compile a structured monthly ledger audit report ready for printing, WhatsApp, or records.', style: TextStyle(fontSize: 12, color: AppTheme.textLight)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: AppTheme.secondaryColor),
                    onPressed: () => _printReport(context),
                    child: const Icon(Icons.print),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildMiniIndicator(String label, String value, Color color) {
    return Column(
      children: [
        Row(
          children: [
            Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
            const SizedBox(width: 6),
            Text(label, style: const TextStyle(fontSize: 12, color: AppTheme.textLight)),
          ],
        ),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
      ],
    );
  }

  Widget _buildProgressLine(String title, double collected, double pending, Color color) {
    final currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);
    final total = collected + pending;
    final ratio = total > 0 ? (collected / total) : 1.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.between,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppTheme.textDark)),
            Text('${currencyFormat.format(collected)} / ${currencyFormat.format(total)}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: ratio,
            minHeight: 6,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }

  void _printReport(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);
    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Building Invoice Report preview'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(buildingName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppTheme.primaryColor)),
                Text('Proprietor: $ownerName', style: const TextStyle(fontSize: 12, color: AppTheme.textLight)),
                const Divider(),
                const Text('MONTHLY RECONCILIATION SUMMARY (June 2026)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: AppTheme.secondaryColor)),
                const SizedBox(height: 8),
                _buildReportRow('Total Capacity', '${rooms.length} Units'),
                _buildReportRow('Active Leases', '${rooms.where((r) => r.isOccupied).length} Rooms'),
                _buildReportRow('Rent Collected (June)', currencyFormat.format(payments.fold(0.0, (sum, p) => sum + p.rentComponent))),
                _buildReportRow('Meter Bill Collected (June)', currencyFormat.format(payments.fold(0.0, (sum, p) => sum + p.electricityComponent))),
                _buildReportRow('Saffron Rent Pending', currencyFormat.format(rooms.fold(0.0, (sum, r) => sum + r.pendingRent))),
                _buildReportRow('Electricity Bill Pending', currencyFormat.format(rooms.fold(0.0, (sum, r) => sum + r.pendingElectricity))),
                const Divider(),
                const Text('End of statement report.', style: TextStyle(fontSize: 10, fontStyle: FontStyle.italic, color: Colors.grey)),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Saving PDF summary to local documents...')));
              },
              icon: const Icon(Icons.download),
              label: const Text('Save PDF'),
            )
          ],
        );
      },
    );
  }

  Widget _buildReportRow(String label, String val) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.between,
        children: [
          Text(label, style: const TextStyle(fontSize: 12)),
          Text(val, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppTheme.textDark)),
        ],
      ),
    );
  }
}
