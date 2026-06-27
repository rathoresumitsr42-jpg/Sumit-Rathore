import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/tenant_model.dart';
import '../models/room_model.dart';
import '../theme/app_theme.dart';

class AddEditTenantScreen extends StatefulWidget {
  final Tenant? tenant;
  final List<Room> rooms;
  final Function(Tenant, double) onSave;

  const AddEditTenantScreen({
    super.key,
    this.tenant,
    required this.rooms,
    required this.onSave,
  });

  @override
  State<AddEditTenantScreen> createState() => _AddEditTenantScreenState();
}

class _AddEditTenantScreenState extends State<AddEditTenantScreen> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _depositController;
  late TextEditingController _meterController;
  late TextEditingController _rentController;
  
  String? _selectedRoom;
  late DateTime _selectedDate;
  late bool _isEditing;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.tenant != null;
    
    _nameController = TextEditingController(text: widget.tenant?.name ?? '');
    _phoneController = TextEditingController(text: widget.tenant?.phone ?? '');
    _depositController = TextEditingController(
      text: widget.tenant != null ? widget.tenant!.securityDeposit.toStringAsFixed(0) : '',
    );
    _meterController = TextEditingController(
      text: widget.tenant != null ? widget.tenant!.initialMeterReading.toStringAsFixed(1) : '',
    );
    
    _selectedRoom = widget.tenant?.roomNumber;
    _selectedDate = widget.tenant?.joinDate ?? DateTime.now();

    // Look up initial base rent if editing
    double initialRent = 8000.0;
    if (_isEditing) {
      final rm = widget.rooms.firstWhere(
        (r) => r.roomNumber == widget.tenant!.roomNumber,
        orElse: () => Room(roomNumber: '', floor: 1, isOccupied: false, baseRentAmount: 8000.0, lastMeterReading: 0.0),
      );
      initialRent = rm.baseRentAmount;
    }
    _rentController = TextEditingController(text: initialRent.toStringAsFixed(0));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _depositController.dispose();
    _meterController.dispose();
    _rentController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_selectedRoom == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select an active room assignment.')),
        );
        return;
      }

      final double deposit = double.tryParse(_depositController.text) ?? 0.0;
      final double rent = double.tryParse(_rentController.text) ?? 8000.0;
      final double initialMeter = double.tryParse(_meterController.text) ?? 0.0;

      final updatedTenant = Tenant(
        id: widget.tenant?.id ?? 'T_${_selectedRoom}_${DateTime.now().millisecondsSinceEpoch}',
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        roomNumber: _selectedRoom!,
        joinDate: _selectedDate,
        securityDeposit: deposit,
        initialMeterReading: initialMeter,
        isActive: widget.tenant?.isActive ?? true,
      );

      widget.onSave(updatedTenant, rent);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Collect available rooms: vacant rooms + the current room of the tenant if editing
    final availableRooms = widget.rooms.where((r) {
      if (!r.isOccupied) return true;
      if (_isEditing && r.roomNumber == widget.tenant!.roomNumber) return true;
      return false;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Modify Tenant Profile' : 'Onboard New Tenant'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Info Card
              Card(
                color: AppTheme.secondaryColor.withOpacity(0.05),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: AppTheme.secondaryColor.withOpacity(0.15)),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline, color: AppTheme.secondaryColor),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _isEditing 
                            ? 'Editing profile details updates agreement ledger records directly.' 
                            : 'Onboarding a tenant automatically marks their assigned room as Occupied.',
                          style: const TextStyle(fontSize: 12, height: 1.4, color: AppTheme.textDark),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Full Name
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Tenant Full Name',
                  prefixIcon: const Icon(Icons.person_outline),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return 'Tenant name is required';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Phone Number
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Mobile Phone Number',
                  prefixIcon: const Icon(Icons.phone_outlined),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  hintText: '+91 9999999999',
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return 'Phone number is required';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Room Selector
              DropdownButtonFormField<String>(
                value: _selectedRoom,
                decoration: InputDecoration(
                  labelText: 'Room Assignment',
                  prefixIcon: const Icon(Icons.meeting_room_outlined),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                items: availableRooms.map((room) {
                  return DropdownMenuItem(
                    value: room.roomNumber,
                    child: Text('Room ${room.roomNumber} (Base: ₹${room.baseRentAmount.toStringAsFixed(0)})'),
                  );
                }).toList(),
                onChanged: _isEditing ? null : (val) {
                  setState(() {
                    _selectedRoom = val;
                    // Auto populate base rent
                    if (val != null) {
                      final rm = widget.rooms.firstWhere((r) => r.roomNumber == val);
                      _rentController.text = rm.baseRentAmount.toStringAsFixed(0);
                      _depositController.text = (rm.baseRentAmount * 2).toStringAsFixed(0);
                      _meterController.text = rm.lastMeterReading.toStringAsFixed(1);
                    }
                  });
                },
                validator: (val) => val == null ? 'Room assignment is required' : null,
              ),
              const SizedBox(height: 16),

              // Grid parameters (Base Rent & Deposit)
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _rentController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Monthly Rent (₹)',
                        prefixIcon: const Icon(Icons.currency_rupee_rounded),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      validator: (val) {
                        if (val == null || val.isEmpty) return 'Required';
                        if (double.tryParse(val) == null) return 'Invalid number';
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _depositController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Security Deposit (₹)',
                        prefixIcon: const Icon(Icons.security_outlined),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      validator: (val) {
                        if (val == null || val.isEmpty) return 'Required';
                        if (double.tryParse(val) == null) return 'Invalid number';
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Starting Meter Reading
              TextFormField(
                controller: _meterController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Starting Meter Reading (kWh)',
                  prefixIcon: const Icon(Icons.bolt_outlined),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                validator: (val) {
                  if (val == null || val.isEmpty) return 'Required';
                  if (double.tryParse(val) == null) return 'Invalid number';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Join Date Picker Card
              InkWell(
                onTap: () => _selectDate(context),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[400]!),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.between,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.calendar_month_outlined, color: Colors.grey),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Agreement Start Date', style: TextStyle(fontSize: 11, color: AppTheme.textLight)),
                              const SizedBox(height: 4),
                              Text(
                                DateFormat('dd MMMM, yyyy').format(_selectedDate),
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Icon(Icons.arrow_drop_down, color: Colors.grey),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 36),

              // Submit
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(
                  _isEditing ? 'Update Tenant Record' : 'Complete Tenant Check-in',
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
