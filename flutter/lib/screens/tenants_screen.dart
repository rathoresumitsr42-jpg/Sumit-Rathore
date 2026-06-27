import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/tenant_model.dart';
import '../models/room_model.dart';
import '../theme/app_theme.dart';
import 'add_edit_tenant_screen.dart';

class TenantsScreen extends StatefulWidget {
  final List<Tenant> tenants;
  final List<Room> rooms;
  final Function(Tenant, double) onAddTenant;
  final Function(String) onEvictTenant;

  const TenantsScreen({
    super.key,
    required this.tenants,
    required this.rooms,
    required this.onAddTenant,
    required this.onEvictTenant,
  });

  @override
  State<TenantsScreen> createState() => _TenantsScreenState();
}

class _TenantsScreenState extends State<TenantsScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);
    
    // Filtered tenants based on search query
    final filteredTenants = widget.tenants.where((t) {
      final matchesName = t.name.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesRoom = t.roomNumber.contains(_searchQuery);
      return matchesName || matchesRoom;
    }).toList();

    return Column(
      children: [
        // Search Bar Card & Onboard button
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
          child: Row(
            children: [
              Expanded(
                child: Card(
                  margin: EdgeInsets.zero,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                    child: TextField(
                      onChanged: (val) {
                        setState(() {
                          _searchQuery = val;
                        });
                      },
                      decoration: const InputDecoration(
                        hintText: 'Search by name or room...',
                        prefixIcon: Icon(Icons.search, color: AppTheme.primaryColor),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        fillColor: Colors.transparent,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddEditTenantScreen(
                        rooms: widget.rooms,
                        onSave: widget.onAddTenant,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.person_add, size: 16),
                label: const Text('Add'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
        ),

        // Tenants list
        Expanded(
          child: filteredTenants.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.people_outline, size: 64, color: Colors.grey[300]),
                      const SizedBox(height: 12),
                      const Text('No tenants found', style: TextStyle(color: AppTheme.textLight)),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: filteredTenants.length,
                  itemBuilder: (context, index) {
                    final tenant = filteredTenants[index];
                    final room = widget.rooms.firstWhere((r) => r.roomNumber == tenant.roomNumber, orElse: () => Room(roomNumber: tenant.roomNumber, floor: 1, isOccupied: true, baseRentAmount: 8000, lastMeterReading: 0));
                    
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
                                Row(
                                  children: [
                                    const CircleAvatar(
                                      backgroundColor: AppTheme.secondaryColor,
                                      foregroundColor: Colors.white,
                                      child: Icon(Icons.person),
                                    ),
                                    const SizedBox(width: 12),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          tenant.name,
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.textDark),
                                        ),
                                        Text(
                                          'Phone: ${tenant.phone}',
                                          style: const TextStyle(color: AppTheme.textLight, fontSize: 13),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: AppTheme.primaryColor.withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    'Room ${tenant.roomNumber}',
                                    style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryColor, fontSize: 13),
                                  ),
                                ),
                              ],
                            ),
                            const Divider(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.between,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('JOIN DATE', style: TextStyle(fontSize: 11, color: AppTheme.textLight)),
                                    const SizedBox(height: 2),
                                    Text(DateFormat('dd MMM, yyyy').format(tenant.joinDate), style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('BASE RENT', style: TextStyle(fontSize: 11, color: AppTheme.textLight)),
                                    const SizedBox(height: 2),
                                    Text(currencyFormat.format(room.baseRentAmount), style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('DEPOSIT', style: TextStyle(fontSize: 11, color: AppTheme.textLight)),
                                    const SizedBox(height: 2),
                                    Text(currencyFormat.format(tenant.securityDeposit), style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.blue, fontSize: 13)),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                OutlinedButton.icon(
                                  onPressed: () {
                                    // Simulated Call or WhatsApp action
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Calling ${tenant.name} at ${tenant.phone}...')));
                                  },
                                  icon: const Icon(Icons.phone, size: 16),
                                  label: const Text('Contact'),
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    minimumSize: Size.zero,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                OutlinedButton.icon(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AddEditTenantScreen(
                                          tenant: tenant,
                                          rooms: widget.rooms,
                                          onSave: widget.onAddTenant,
                                        ),
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.edit, size: 16),
                                  label: const Text('Edit'),
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    minimumSize: Size.zero,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                OutlinedButton.icon(
                                  onPressed: () {
                                    // View financial history
                                    _showTenantLedger(context, tenant);
                                  },
                                  icon: const Icon(Icons.receipt_long, size: 16),
                                  label: const Text('Ledger'),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: AppTheme.primaryColor,
                                    side: const BorderSide(color: AppTheme.primaryColor),
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    minimumSize: Size.zero,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  void _showTenantLedger(BuildContext context, Tenant tenant) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${tenant.name} - Room ${tenant.roomNumber}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text('Active Agreement Parameters:', style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.secondaryColor)),
              const SizedBox(height: 8),
              _buildLedgerRow('Agreement Start Date', DateFormat('dd MMMM, yyyy').format(tenant.joinDate)),
              _buildLedgerRow('Security Deposit', '₹${tenant.securityDeposit.toStringAsFixed(0)}'),
              _buildLedgerRow('Starting Electricity Index', '${tenant.initialMeterReading} kWh'),
              const Divider(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _buildLedgerRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.between,
        children: [
          Text(label, style: const TextStyle(color: AppTheme.textLight)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600, color: AppTheme.textDark)),
        ],
      ),
    );
  }
}
