import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/room_model.dart';
import '../models/tenant_model.dart';
import '../models/payment_model.dart';
import '../models/electricity_model.dart';
import '../theme/app_theme.dart';
import 'add_edit_room_screen.dart';
import 'add_edit_tenant_screen.dart';

class RoomsScreen extends StatefulWidget {
  final List<Room> rooms;
  final List<Tenant> tenants;
  final Function(Tenant, double) onAddTenant;
  final Function(String) onEvictTenant;
  final Function(Payment) onRecordPayment;
  final Function(ElectricityReading) onAddMeterReading;
  final Function(Room) onAddRoom;
  final double electricityRate;

  const RoomsScreen({
    super.key,
    required this.rooms,
    required this.tenants,
    required this.onAddTenant,
    required this.onEvictTenant,
    required this.onRecordPayment,
    required this.onAddMeterReading,
    required this.onAddRoom,
    required this.electricityRate,
  });

  @override
  State<RoomsScreen> createState() => _RoomsScreenState();
}

class _RoomsScreenState extends State<RoomsScreen> {
  String _filter = 'All'; // All, Occupied, Vacant, Pending

  @override
  Widget build(BuildContext context) {
    // Filter rooms
    List<Room> filteredRooms = widget.rooms;
    if (_filter == 'Occupied') {
      filteredRooms = widget.rooms.where((r) => r.isOccupied).toList();
    } else if (_filter == 'Vacant') {
      filteredRooms = widget.rooms.where((r) => !r.isOccupied).toList();
    } else if (_filter == 'Pending') {
      filteredRooms = widget.rooms.where((r) => r.pendingRent > 0 || r.pendingElectricity > 0).toList();
    }

    // Group rooms by floor
    final roomsByFloor = <int, List<Room>>{};
    for (var r in filteredRooms) {
      roomsByFloor.putIfAbsent(r.floor, () => []).add(r);
    }
    final sortedFloors = roomsByFloor.keys.toList()..sort((a, b) => b.compareTo(a)); // Higher floors first

    return Column(
      children: [
        // Add Room option
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Filter Units:', style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textLight, fontSize: 13)),
              OutlinedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddEditRoomScreen(
                        onSave: widget.onAddRoom,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.add_circle_outline, size: 16),
                label: const Text('Add Room', style: TextStyle(fontSize: 12)),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  minimumSize: Size.zero,
                ),
              ),
            ],
          ),
        ),
        // Grid Filter Chips
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildFilterChip('All', Icons.apps),
              _buildFilterChip('Occupied', Icons.vpn_key),
              _buildFilterChip('Vacant', Icons.door_front_slide),
              _buildFilterChip('Pending', Icons.priority_high),
            ],
          ),
        ),

        // Rooms Grid grouped by Floors
        Expanded(
          child: filteredRooms.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.meeting_room_outlined, size: 64, color: Colors.grey[300]),
                      const SizedBox(height: 12),
                      const Text('No rooms match selected filter', style: TextStyle(color: AppTheme.textLight)),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: sortedFloors.length,
                  itemBuilder: (context, floorIndex) {
                    final floor = sortedFloors[floorIndex];
                    final floorRooms = roomsByFloor[floor]!;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
                          child: Row(
                            children: [
                              const Icon(Icons.layers, size: 18, color: AppTheme.primaryColor),
                              const SizedBox(width: 8),
                              Text(
                                '${_getFloorName(floor)} Floor',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.textDark,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Divider(color: Colors.grey.withOpacity(0.2)),
                              ),
                            ],
                          ),
                        ),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 0.9,
                          ),
                          itemCount: floorRooms.length,
                          itemBuilder: (context, roomIndex) {
                            final room = floorRooms[roomIndex];
                            return _buildRoomCard(context, room);
                          },
                        ),
                      ],
                    );
                  },
                ),
        ),
      ],
    );
  }

  String _getFloorName(int floor) {
    if (floor == 1) return 'Ground';
    if (floor == 2) return 'First';
    if (floor == 3) return 'Second';
    if (floor == 4) return 'Third';
    return '${floor}th';
  }

  Widget _buildFilterChip(String label, IconData icon) {
    final isSelected = _filter == label;
    final color = label == 'Occupied'
        ? AppTheme.primaryColor
        : label == 'Vacant'
            ? AppTheme.secondaryColor
            : label == 'Pending'
                ? Colors.red[700]!
                : Colors.blue;

    return ChoiceChip(
      avatar: Icon(
        icon,
        size: 16,
        color: isSelected ? Colors.white : color,
      ),
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _filter = label;
          });
        }
      },
      selectedColor: color,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : AppTheme.textDark,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      backgroundColor: Colors.white,
    );
  }

  Widget _buildRoomCard(BuildContext context, Room room) {
    final currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);
    final hasDues = room.pendingRent > 0 || room.pendingElectricity > 0;
    
    return InkWell(
      onTap: () => _showRoomDetailsSheet(context, room),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: room.isOccupied ? Colors.white : const Color(0xFFF1F5F2),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: room.isOccupied
                ? (hasDues ? Colors.red[200]! : AppTheme.primaryColor.withOpacity(0.2))
                : AppTheme.secondaryColor.withOpacity(0.15),
            width: room.isOccupied ? 1.5 : 1,
          ),
          boxShadow: room.isOccupied
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  )
                ]
              : [],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Header Room Name + Status dot
            Row(
              mainAxisAlignment: MainAxisAlignment.between,
              children: [
                Text(
                  room.roomNumber,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textDark,
                  ),
                ),
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: room.isOccupied
                        ? (hasDues ? Colors.red : AppTheme.primaryColor)
                        : AppTheme.secondaryColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),

            // Content (Occupied Tenant Name or Vacant)
            Expanded(
              child: Center(
                child: Text(
                  room.isOccupied ? (room.currentTenantName?.split(' ')[0] ?? 'Occupied') : 'Vacant',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: room.isOccupied ? FontWeight.bold : FontWeight.w500,
                    color: room.isOccupied ? AppTheme.textDark : AppTheme.secondaryColor,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),

            // Footer (Price or Pending icon)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  currencyFormat.format(room.baseRentAmount),
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppTheme.textLight,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (room.isOccupied && hasDues)
                  const Icon(Icons.warning, color: Colors.red, size: 14)
                else if (room.isOccupied)
                  const Icon(Icons.check, color: AppTheme.secondaryColor, size: 14)
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showRoomDetailsSheet(BuildContext context, Room room) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);
            final tenant = widget.tenants.firstWhere(
              (t) => t.roomNumber == room.roomNumber && t.isActive,
              orElse: () => Tenant(id: '', name: 'Vacant', phone: '', roomNumber: room.roomNumber, joinDate: DateTime.now(), securityDeposit: 0.0, initialMeterReading: room.lastMeterReading),
            );

            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Center(
                    child: Container(
                      width: 40,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2.5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.between,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Room ${room.roomNumber}',
                            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.textDark),
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit_outlined, size: 18, color: AppTheme.primaryColor),
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddEditRoomScreen(
                                    room: room,
                                    onSave: widget.onAddRoom,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: room.isOccupied
                              ? AppTheme.primaryColor.withOpacity(0.12)
                              : AppTheme.secondaryColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          room.isOccupied ? 'Occupied' : 'Vacant',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: room.isOccupied ? AppTheme.primaryColor : AppTheme.secondaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24),

                  // Room stats
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildPopupMetric('Base Rent', currencyFormat.format(room.baseRentAmount)),
                      _buildPopupMetric('Last Meter Reading', '${room.lastMeterReading.toStringAsFixed(1)} kWh'),
                    ],
                  ),
                  const SizedBox(height: 16),

                  if (room.isOccupied) ...[
                    // Tenant Details Box
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('CURRENT TENANT', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.secondaryColor)),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.between,
                            children: [
                              Row(
                                children: [
                                  Text(tenant.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                  const SizedBox(width: 4),
                                  IconButton(
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    icon: const Icon(Icons.edit, size: 14, color: AppTheme.secondaryColor),
                                    onPressed: () {
                                      Navigator.pop(context);
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
                                  ),
                                ],
                              ),
                              Text(tenant.phone, style: const TextStyle(color: AppTheme.textLight, fontSize: 13)),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.between,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Rent Dues', style: TextStyle(fontSize: 12, color: AppTheme.textLight)),
                                  Text(currencyFormat.format(room.pendingRent), style: TextStyle(fontWeight: FontWeight.bold, color: room.pendingRent > 0 ? Colors.red : AppTheme.textDark)),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Electricity Dues', style: TextStyle(fontSize: 12, color: AppTheme.textLight)),
                                  Text(currencyFormat.format(room.pendingElectricity), style: TextStyle(fontWeight: FontWeight.bold, color: room.pendingElectricity > 0 ? Colors.red : AppTheme.textDark)),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Deposit Paid', style: TextStyle(fontSize: 12, color: AppTheme.textLight)),
                                  Text(currencyFormat.format(tenant.securityDeposit), style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Quick Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              _showRecordPaymentDialog(context, room);
                            },
                            icon: const Icon(Icons.payment, size: 18),
                            label: const Text('Add Payment'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              _showLogElectricityDialog(context, room);
                            },
                            icon: const Icon(Icons.bolt, size: 18),
                            label: const Text('Add Meter'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: TextButton.icon(
                        style: TextButton.styleFrom(foregroundColor: Colors.red),
                        onPressed: () {
                          // Confirm Checkout / Eviction
                          Navigator.pop(context);
                          _confirmEviction(context, room);
                        },
                        icon: const Icon(Icons.logout),
                        label: const Text('Vacate / Check-out Tenant'),
                      ),
                    )
                  ] else ...[
                    // Vacant actions: Check-in new tenant
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24.0),
                        child: Column(
                          children: [
                            Icon(Icons.person_add_outlined, size: 48, color: Colors.grey[400]),
                            const SizedBox(height: 8),
                            const Text('Room is available for immediate leasing.', style: TextStyle(color: AppTheme.textLight)),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddEditTenantScreen(
                                selectRoomNumber: room.roomNumber,
                                rooms: widget.rooms,
                                onSave: widget.onAddTenant,
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.vpn_key),
                        label: const Text('Check-in / Onboard Tenant'),
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildPopupMetric(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: AppTheme.textLight)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textDark)),
      ],
    );
  }

  // Sub Dialogs
  void _showRecordPaymentDialog(BuildContext context, Room room) {
    final rentController = TextEditingController(text: room.pendingRent.toString());
    final elecController = TextEditingController(text: room.pendingElectricity.toString());
    String payMode = 'UPI';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text('Record Rent for Room ${room.roomNumber}'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: rentController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Rent Cash Component (₹)'),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: elecController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Electricity Component (₹)'),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: payMode,
                    decoration: const InputDecoration(labelText: 'Payment Mode'),
                    items: ['UPI', 'Cash', 'Bank Transfer'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                    onChanged: (val) {
                      if (val != null) setDialogState(() => payMode = val);
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                ElevatedButton(
                  onPressed: () {
                    final rentPaid = double.tryParse(rentController.text) ?? 0.0;
                    final elecPaid = double.tryParse(elecController.text) ?? 0.0;
                    
                    widget.onRecordPayment(Payment(
                      id: 'P_${DateTime.now().millisecondsSinceEpoch}',
                      roomNumber: room.roomNumber,
                      tenantName: room.currentTenantName ?? 'Unknown',
                      date: DateTime.now(),
                      amountPaid: rentPaid + elecPaid,
                      rentComponent: rentPaid,
                      electricityComponent: elecPaid,
                      previousReading: room.lastMeterReading,
                      currentReading: room.lastMeterReading,
                      unitsConsumed: 0,
                      paymentMode: payMode,
                      monthYear: 'June 2026',
                    ));
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Payment registered successfully!')));
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showLogElectricityDialog(BuildContext context, Room room) {
    final readingController = TextEditingController(text: (room.lastMeterReading + 50).toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('New Meter Reading: Room ${room.roomNumber}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Previous Reading: ${room.lastMeterReading} kWh', style: const TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 12),
              TextField(
                controller: readingController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Current Reading (kWh)'),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                final current = double.tryParse(readingController.text) ?? 0.0;
                if (current < room.lastMeterReading) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error: Current reading must be higher than previous.')));
                  return;
                }
                
                widget.onAddMeterReading(ElectricityReading(
                  id: 'E_${room.roomNumber}_${DateTime.now().millisecondsSinceEpoch}',
                  roomNumber: room.roomNumber,
                  monthYear: 'June 2026',
                  previousReading: room.lastMeterReading,
                  currentReading: current,
                  ratePerUnit: widget.electricityRate,
                  readingDate: DateTime.now(),
                ));
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Meter reading logged!')));
              },
              child: const Text('Log Billing'),
            ),
          ],
        );
      },
    );
  }

  void _showCheckInTenantDialog(BuildContext context, Room room) {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final depositController = TextEditingController(text: (room.baseRentAmount * 2).toString());
    final rentController = TextEditingController(text: room.baseRentAmount.toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Onboard Room ${room.roomNumber} Tenant'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Tenant Full Name'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(labelText: 'Mobile Phone'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: rentController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Base Rental Rent (₹)'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: depositController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Security Deposit (₹)'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isEmpty || phoneController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill all fields')));
                  return;
                }
                
                final baseRent = double.tryParse(rentController.text) ?? room.baseRentAmount;
                final deposit = double.tryParse(depositController.text) ?? 0.0;
                
                widget.onAddTenant(Tenant(
                  id: 'T_${room.roomNumber}_${DateTime.now().millisecondsSinceEpoch}',
                  name: nameController.text,
                  phone: phoneController.text,
                  roomNumber: room.roomNumber,
                  joinDate: DateTime.now(),
                  securityDeposit: deposit,
                  initialMeterReading: room.lastMeterReading,
                ), baseRent);
                
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${nameController.text} is checked into Room ${room.roomNumber}!')));
              },
              child: const Text('Check-in'),
            ),
          ],
        );
      },
    );
  }

  void _confirmEviction(BuildContext context, Room room) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Check-out Room ${room.roomNumber}?'),
          content: Text('Are you sure you want to mark tenant ${room.currentTenantName} as Checked-out? All outstanding pending rent (₹${room.pendingRent}) and electricity (₹${room.pendingElectricity}) should ideally be settled first.'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('No, Cancel')),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                widget.onEvictTenant(room.roomNumber);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Tenant checked-out, room is now vacant.')));
              },
              child: const Text('Confirm Checkout'),
            ),
          ],
        );
      },
    );
  }
}
