import 'package:flutter/material.dart';
import '../models/room_model.dart';
import '../theme/app_theme.dart';

class AddEditRoomScreen extends StatefulWidget {
  final Room? room;
  final Function(Room) onSave;

  const AddEditRoomScreen({
    super.key,
    this.room,
    required this.onSave,
  });

  @override
  State<AddEditRoomScreen> createState() => _AddEditRoomScreenState();
}

class _AddEditRoomScreenState extends State<AddEditRoomScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _roomNumberController;
  late TextEditingController _rentController;
  late TextEditingController _meterController;
  late int _selectedFloor;
  late bool _isEditing;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.room != null;

    _roomNumberController = TextEditingController(text: widget.room?.roomNumber ?? '');
    _rentController = TextEditingController(
      text: widget.room != null ? widget.room!.baseRentAmount.toStringAsFixed(0) : '8000',
    );
    _meterController = TextEditingController(
      text: widget.room != null ? widget.room!.lastMeterReading.toStringAsFixed(1) : '100.0',
    );
    _selectedFloor = widget.room?.floor ?? 1;
  }

  @override
  void dispose() {
    _roomNumberController.dispose();
    _rentController.dispose();
    _meterController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      final double rent = double.tryParse(_rentController.text) ?? 8000.0;
      final double meter = double.tryParse(_meterController.text) ?? 0.0;
      final String roomNo = _roomNumberController.text.trim();

      final savedRoom = Room(
        roomNumber: roomNo,
        floor: _selectedFloor,
        isOccupied: widget.room?.isOccupied ?? false,
        currentTenantId: widget.room?.currentTenantId,
        currentTenantName: widget.room?.currentTenantName,
        baseRentAmount: rent,
        lastMeterReading: meter,
        pendingRent: widget.room?.pendingRent ?? 0.0,
        pendingElectricity: widget.room?.pendingElectricity ?? 0.0,
      );

      widget.onSave(savedRoom);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Configure Room Parameters' : 'Add Rental Unit'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header description
              Card(
                color: AppTheme.primaryColor.withOpacity(0.05),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: AppTheme.primaryColor.withOpacity(0.15)),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      const Icon(Icons.apartment, color: AppTheme.primaryColor),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _isEditing 
                              ? 'Editing room parameters changes base rentals and reading targets for future billings.' 
                              : 'Create a new room number ledger unit and define floor plans instantly.',
                          style: const TextStyle(fontSize: 12, height: 1.4, color: AppTheme.textDark),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 28),

              // Room Number input
              TextFormField(
                controller: _roomNumberController,
                keyboardType: TextInputType.number,
                enabled: !_isEditing, // Room numbers are primary keys, cannot edit after creation
                decoration: InputDecoration(
                  labelText: 'Room Number',
                  prefixIcon: const Icon(Icons.tag),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  helperText: _isEditing ? 'Room number identifier is fixed.' : 'Use 3 digits, e.g. 101, 204, 309.',
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return 'Room number is required';
                  if (val.trim().length < 3) return 'Must be at least 3 characters';
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Floor plan assignment
              DropdownButtonFormField<int>(
                value: _selectedFloor,
                decoration: InputDecoration(
                  labelText: 'Floor Plan Assignment',
                  prefixIcon: const Icon(Icons.layers_outlined),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                items: [1, 2, 3, 4, 5].map((floor) {
                  String name = floor == 1 ? 'Ground' : floor == 2 ? 'First' : floor == 3 ? 'Second' : floor == 4 ? 'Third' : 'Fourth';
                  return DropdownMenuItem(
                    value: floor,
                    child: Text('$name Floor'),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedFloor = val);
                },
              ),
              const SizedBox(height: 20),

              // Base Rent amount
              TextFormField(
                controller: _rentController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Default Monthly Rent (₹)',
                  prefixIcon: const Icon(Icons.currency_rupee_rounded),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                validator: (val) {
                  if (val == null || val.isEmpty) return 'Monthly rent target is required';
                  if (double.tryParse(val) == null) return 'Invalid amount';
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Initial Meter Index
              TextFormField(
                controller: _meterController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Starting Meter Reading (kWh)',
                  prefixIcon: const Icon(Icons.bolt),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  helperText: 'Initial electrical submeter reading.',
                ),
                validator: (val) {
                  if (val == null || val.isEmpty) return 'Electricity reading is required';
                  if (double.tryParse(val) == null) return 'Invalid meter value';
                  return null;
                },
              ),
              const SizedBox(height: 36),

              // Submit Button
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(
                  _isEditing ? 'Save Room Settings' : 'Add Unit to Ledger',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
