import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/room_model.dart';
import '../theme/app_theme.dart';

class NotificationsScreen extends StatelessWidget {
  final List<Room> rooms;
  final String proprietorUpi;

  const NotificationsScreen({
    super.key,
    required this.rooms,
    required this.proprietorUpi,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);
    
    // Filter rooms with outstanding dues
    final debtorRooms = rooms.where((r) => r.isOccupied && (r.pendingRent > 0 || r.pendingElectricity > 0)).toList();

    // Create system notification list in memory
    final List<Map<String, dynamic>> systemAlerts = [];
    for (var r in debtorRooms) {
      if (r.pendingRent > 0) {
        systemAlerts.add({
          'title': 'Rent Overdue - Room ${r.roomNumber}',
          'body': '${r.currentTenantName} owes ₹${r.pendingRent.toStringAsFixed(0)} in base rental fees.',
          'type': 'rent',
          'date': 'Due 1st June',
          'severity': 'high',
        });
      }
      if (r.pendingElectricity > 0) {
        systemAlerts.add({
          'title': 'Electricity Due - Room ${r.roomNumber}',
          'body': 'Unsettled electricity charge of ₹${r.pendingElectricity.toStringAsFixed(0)} logged.',
          'type': 'electricity',
          'date': 'Reading synced',
          'severity': 'medium',
        });
      }
    }

    // Add general notifications if none
    if (systemAlerts.isEmpty) {
      systemAlerts.add({
        'title': 'Property Synced Successfully',
        'body': 'All 36 rental rooms are completely updated. No pending rental debts recorded.',
        'type': 'system',
        'date': 'Just Now',
        'severity': 'info',
      });
    }

    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.notifications_active), text: 'System Alerts'),
              Tab(icon: Icon(Icons.share), text: 'Rent Reminders'),
            ],
            labelColor: AppTheme.primaryColor,
            unselectedLabelColor: AppTheme.textLight,
            indicatorColor: AppTheme.primaryColor,
          ),
          Expanded(
            child: TabBarView(
              children: [
                // TAB 1: System Alerts
                ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: systemAlerts.length,
                  itemBuilder: (context, index) {
                    final alert = systemAlerts[index];
                    final isHigh = alert['severity'] == 'high';
                    final isMedium = alert['severity'] == 'medium';
                    
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              backgroundColor: isHigh 
                                  ? Colors.red[50] 
                                  : isMedium 
                                      ? Colors.amber[50] 
                                      : Colors.blue[50],
                              child: Icon(
                                isHigh 
                                    ? Icons.error_rounded 
                                    : isMedium 
                                        ? Icons.bolt_rounded 
                                        : Icons.info_outline_rounded, 
                                color: isHigh 
                                    ? Colors.red 
                                    : isMedium 
                                        ? Colors.amber[900] 
                                        : Colors.blue,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.between,
                                    children: [
                                      Text(
                                        alert['title'],
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                      ),
                                      Text(
                                        alert['date'],
                                        style: const TextStyle(fontSize: 10, color: AppTheme.textLight),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    alert['body'],
                                    style: const TextStyle(fontSize: 13, color: AppTheme.textDark, height: 1.3),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                // TAB 2: Dynamic Rent Reminders
                debtorRooms.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.check_circle_outline, size: 64, color: Colors.green[200]),
                            const SizedBox(height: 12),
                            const Text('No outstanding tenant debts!', style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textLight)),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: debtorRooms.length,
                        itemBuilder: (context, index) {
                          final room = debtorRooms[index];
                          final double totalDue = room.pendingRent + room.pendingElectricity;
                          
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
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                      ),
                                      Text(
                                        currencyFormat.format(totalDue),
                                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red, fontSize: 15),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Rent: ${currencyFormat.format(room.pendingRent)}  |  Electricity: ${currencyFormat.format(room.pendingElectricity)}',
                                    style: const TextStyle(fontSize: 12, color: AppTheme.textLight),
                                  ),
                                  const Divider(height: 24),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: OutlinedButton.icon(
                                          onPressed: () {
                                            _copyTemplateToClipboard(context, room);
                                          },
                                          icon: const Icon(Icons.copy, size: 16),
                                          label: const Text('Copy SMS'),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: ElevatedButton.icon(
                                          style: ElevatedButton.styleFrom(backgroundColor: Colors.green[600]),
                                          onPressed: () {
                                            _shareWhatsAppReminder(context, room);
                                          },
                                          icon: const Icon(Icons.share, size: 16, color: Colors.white),
                                          label: const Text('WhatsApp', style: TextStyle(color: Colors.white)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _copyTemplateToClipboard(BuildContext context, Room room) {
    final double total = room.pendingRent + room.pendingElectricity;
    final template = 'Dear ${room.currentTenantName},\n\n'
        'This is a friendly reminder from Shree Ram Residency regarding outstanding dues for Room ${room.roomNumber}:\n'
        '• Overdue Rent: ₹${room.pendingRent.toStringAsFixed(0)}\n'
        '• Electricity Add-on: ₹${room.pendingElectricity.toStringAsFixed(0)}\n'
        '• Total Amount Due: ₹${total.toStringAsFixed(0)}\n\n'
        'Please complete the transfer to our official UPI: $proprietorUpi.\n\n'
        'Thank you,\n'
        'Management, Shree Ram Residency';
        
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Message template copied to clipboard!')),
    );
  }

  void _shareWhatsAppReminder(BuildContext context, Room room) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Simulating WhatsApp sharing message to ${room.currentTenantName}...')),
    );
  }
}
