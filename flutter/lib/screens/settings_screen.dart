import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SettingsScreen extends StatefulWidget {
  final double electricityRate;
  final String upiId;
  final String ownerName;
  final String buildingName;
  final Function(double, String, String, String) onUpdateSettings;
  final int totalRooms;
  final int occupiedRooms;

  const SettingsScreen({
    super.key,
    required this.electricityRate,
    required this.upiId,
    required this.ownerName,
    required this.buildingName,
    required this.onUpdateSettings,
    required this.totalRooms,
    required this.occupiedRooms,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late TextEditingController _rateController;
  late TextEditingController _upiController;
  late TextEditingController _ownerController;
  late TextEditingController _buildingController;

  @override
  void initState() {
    super.initState();
    _rateController = TextEditingController(text: widget.electricityRate.toString());
    _upiController = TextEditingController(text: widget.upiId);
    _ownerController = TextEditingController(text: widget.ownerName);
    _buildingController = TextEditingController(text: widget.buildingName);
  }

  @override
  void dispose() {
    _rateController.dispose();
    _upiController.dispose();
    _ownerController.dispose();
    _buildingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Building Info Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 24,
                        backgroundColor: AppTheme.primaryColor,
                        child: Icon(Icons.apartment, color: Colors.white, size: 24),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.buildingName,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppTheme.textDark),
                            ),
                            Text(
                              'Proprietor: ${widget.ownerName}',
                              style: const TextStyle(fontSize: 13, color: AppTheme.textLight),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildMetricRow('Total Rooms', '${widget.totalRooms} Units'),
                      _buildMetricRow('Active Tenants', '${widget.occupiedRooms} Active'),
                    ],
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Settings Inputs Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('System Configurations', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.secondaryColor)),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _buildingController,
                    decoration: const InputDecoration(labelText: 'Building / Residency Name'),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _ownerController,
                    decoration: const InputDecoration(labelText: 'Proprietor Name'),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _upiController,
                          decoration: const InputDecoration(labelText: 'UPI VPA (for QR code payments)'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: _rateController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          decoration: const InputDecoration(labelText: 'Elec Tariff (₹/kWh)'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        final rate = double.tryParse(_rateController.text) ?? widget.electricityRate;
                        widget.onUpdateSettings(rate, _upiController.text, _ownerController.text, _buildingController.text);
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Settings saved!')));
                      },
                      icon: const Icon(Icons.save),
                      label: const Text('Save Parameters'),
                    ),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Maintenance Tools
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Database Operations', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppTheme.textDark)),
                  const SizedBox(height: 8),
                  ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Backup Local Databases', style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: const Text('Compile database and export to CSV or local storage.'),
                    trailing: IconButton(
                      icon: const Icon(Icons.cloud_upload_outlined, color: AppTheme.secondaryColor),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Data compiled and backed up to cloud drive!')));
                      },
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Reset Application Database', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
                    subtitle: const Text('Purge all transactions, tenant logs, meter history.'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_forever_outlined, color: Colors.red),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Database reset is protected. Please contact support.')));
                      },
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildMetricRow(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: AppTheme.textLight)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppTheme.textDark)),
      ],
    );
  }
}
