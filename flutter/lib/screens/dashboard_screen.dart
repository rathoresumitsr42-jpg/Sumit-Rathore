import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/room_model.dart';
import '../models/payment_model.dart';
import '../models/electricity_model.dart';
import '../models/tenant_model.dart';
import '../theme/app_theme.dart';

class DashboardScreen extends StatelessWidget {
  final List<Room> rooms;
  final List<Payment> payments;
  final List<ElectricityReading> electricityReadings;
  final double electricityRate;
  final Function(Payment) onQuickRecordPayment;
  final Function(Tenant, double) onQuickAddTenant;

  const DashboardScreen({
    super.key,
    required this.rooms,
    required this.payments,
    required this.electricityReadings,
    required this.electricityRate,
    required this.onQuickRecordPayment,
    required this.onQuickAddTenant,
  });

  @override
  Widget build(BuildContext context) {
    // Calculators
    final currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);
    
    // Occupancy
    final totalRooms = rooms.length;
    final occupiedRooms = rooms.where((r) => r.isOccupied).length;
    final vacantRooms = totalRooms - occupiedRooms;
    
    // Expected Monthly Rent = occupied room rents + pending rent
    double totalExpectedRent = 0.0;
    for (var r in rooms) {
      if (r.isOccupied) {
        totalExpectedRent += r.baseRentAmount;
      }
      totalExpectedRent += r.pendingRent;
    }

    // Rent Collected this month (from Payments list for June 2026)
    double rentCollected = payments
        .where((p) => p.monthYear == 'June 2026')
        .fold(0.0, (sum, p) => sum + p.rentComponent);

    double pendingRent = rooms.fold(0.0, (sum, r) => sum + r.pendingRent);

    // Electricity
    double electricityCollected = payments
        .where((p) => p.monthYear == 'June 2026')
        .fold(0.0, (sum, p) => sum + p.electricityComponent);

    double pendingElectricity = rooms.fold(0.0, (sum, r) => sum + r.pendingElectricity);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Card
          Card(
            clipBehavior: Clip.antiAlias,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppTheme.primaryColor, AppTheme.accentColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'जय श्री राम',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white.withOpacity(0.9),
                            letterSpacing: 2,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Welcome, Admin',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Building management running smoothly with ${((occupiedRooms/totalRooms)*100).toStringAsFixed(0)}% Occupancy.',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 28,
                    child: Icon(Icons.apartment, color: AppTheme.primaryColor, size: 32),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Occupancy & Vacancy quick counters
          Row(
            children: [
              Expanded(
                child: _buildSmallCounterCard(
                  context,
                  title: 'Occupied',
                  count: '$occupiedRooms / $totalRooms',
                  subtitle: 'Rooms In Use',
                  icon: Icons.vpn_key,
                  color: AppTheme.primaryColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSmallCounterCard(
                  context,
                  title: 'Vacant',
                  count: '$vacantRooms',
                  subtitle: 'Available',
                  icon: Icons.door_front_slide,
                  color: AppTheme.secondaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Revenue Header
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
            child: Text(
              'RENT & CASH FLOW',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: 1.5, color: AppTheme.secondaryColor),
            ),
          ),

          // Rent Stats Row
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  context,
                  title: 'Expected Rent',
                  amount: currencyFormat.format(totalExpectedRent),
                  icon: Icons.account_balance_wallet_outlined,
                  color: AppTheme.textDark,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  context,
                  title: 'Rent Collected',
                  amount: currencyFormat.format(rentCollected),
                  icon: Icons.check_circle_outline,
                  color: AppTheme.secondaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          _buildWideStatCard(
            context,
            title: 'Pending Rent Outstanding',
            amount: currencyFormat.format(pendingRent),
            icon: Icons.pending_actions_outlined,
            color: AppTheme.primaryColor,
            barPercentage: totalExpectedRent > 0 ? (rentCollected / totalExpectedRent) : 0.0,
          ),

          const SizedBox(height: 20),

          // Electricity Header
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
            child: Text(
              'ELECTRICITY METRICS',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: 1.5, color: AppTheme.secondaryColor),
            ),
          ),

          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  context,
                  title: 'Collected Meter Dues',
                  amount: currencyFormat.format(electricityCollected),
                  icon: Icons.flash_on,
                  color: AppTheme.secondaryColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  context,
                  title: 'Pending Electricity',
                  amount: currencyFormat.format(pendingElectricity),
                  icon: Icons.bolt,
                  color: Colors.red[700]!,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Recent Payments Title
          Row(
            mainAxisAlignment: MainAxisAlignment.between,
            children: [
              const Text(
                'Recent Payments Log',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textDark),
              ),
              TextButton(
                onPressed: () {
                  // Navigate to payments list or similar via context trigger
                },
                child: const Text('See All', style: TextStyle(color: AppTheme.secondaryColor, fontWeight: FontWeight.bold)),
              ),
            ],
          ),

          // Recent Payments List
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: payments.length > 5 ? 5 : payments.length,
            itemBuilder: (context, index) {
              final payment = payments[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: payment.paymentMode == 'UPI'
                        ? Colors.blue[50]
                        : payment.paymentMode == 'Cash'
                            ? Colors.green[50]
                            : Colors.purple[50],
                    child: Icon(
                      payment.paymentMode == 'UPI'
                          ? Icons.qr_code
                          : payment.paymentMode == 'Cash'
                              ? Icons.money
                              : Icons.account_balance,
                      color: payment.paymentMode == 'UPI'
                          ? Colors.blue
                          : payment.paymentMode == 'Cash'
                              ? Colors.green
                              : Colors.purple,
                    ),
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.between,
                    children: [
                      Text(
                        'Room ${payment.roomNumber}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        currencyFormat.format(payment.amountPaid),
                        style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.secondaryColor),
                      ),
                    ],
                  ),
                  subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.between,
                    children: [
                      Text(payment.tenantName),
                      Text(DateFormat('dd MMM, yyyy').format(payment.date), style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSmallCounterCard(
    BuildContext context, {
    required String title,
    required String count,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 12, color: AppTheme.textLight)),
                  Text(count, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textDark)),
                  Text(subtitle, style: const TextStyle(fontSize: 11, color: AppTheme.textLight)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String title,
    required String amount,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(fontSize: 12, color: AppTheme.textLight)),
            const SizedBox(height: 4),
            Text(
              amount,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color == AppTheme.textDark ? AppTheme.textDark : color),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWideStatCard(
    BuildContext context, {
    required String title,
    required String amount,
    required IconData icon,
    required Color color,
    required double barPercentage,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.between,
              children: [
                Row(
                  children: [
                    Icon(icon, color: color, size: 24),
                    const SizedBox(width: 12),
                    Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppTheme.textLight)),
                  ],
                ),
                Text(amount, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
              ],
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: barPercentage,
                minHeight: 8,
                backgroundColor: Colors.grey[200],
                valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.secondaryColor),
              ),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Rent Collected: ${(barPercentage * 100).toStringAsFixed(0)}%', style: const TextStyle(fontSize: 11, color: AppTheme.textLight)),
                Text('Dues Outstanding: ${( (1 - barPercentage) * 100).toStringAsFixed(0)}%', style: const TextStyle(fontSize: 11, color: AppTheme.textLight)),
              ],
            )
          ],
        ),
      ),
    );
  }
}
