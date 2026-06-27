import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../models/payment_model.dart';
import '../models/room_model.dart';
import '../theme/app_theme.dart';

class PaymentsScreen extends StatefulWidget {
  final List<Payment> payments;
  final List<Room> rooms;
  final Function(Payment) onRecordPayment;
  final String upiId;

  const PaymentsScreen({
    super.key,
    required this.payments,
    required this.rooms,
    required this.onRecordPayment,
    required this.upiId,
  });

  @override
  State<PaymentsScreen> createState() => _PaymentsScreenState();
}

class _PaymentsScreenState extends State<PaymentsScreen> {
  String _selectedMonth = 'All';

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);

    // Get unique months in payment history
    final months = ['All', ...widget.payments.map((p) => p.monthYear).toSet().toList()];

    // Filter payments
    final filteredPayments = _selectedMonth == 'All'
        ? widget.payments
        : widget.payments.where((p) => p.monthYear == _selectedMonth).toList();

    return Column(
      children: [
        // Action card for new payment & UPI QR Generator
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _openRecordPaymentForm(context),
                  icon: const Icon(Icons.add_card),
                  label: const Text('Add Payment'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _openQrGenerator(context),
                  icon: const Icon(Icons.qr_code_2),
                  label: const Text('UPI QR Code'),
                ),
              ),
            ],
          ),
        ),

        // Month filter slider
        Container(
          height: 48,
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: months.length,
            itemBuilder: (context, index) {
              final month = months[index];
              final isSelected = _selectedMonth == month;
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: ChoiceChip(
                  label: Text(month),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) setState(() => _selectedMonth = month);
                  },
                  selectedColor: AppTheme.secondaryColor,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : AppTheme.textDark,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              );
            },
          ),
        ),

        // Payments list
        Expanded(
          child: filteredPayments.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.payment, size: 64, color: Colors.grey[300]),
                      const SizedBox(height: 12),
                      const Text('No transactions recorded for this period', style: TextStyle(color: AppTheme.textLight)),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: filteredPayments.length,
                  itemBuilder: (context, index) {
                    final p = filteredPayments[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.between,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: AppTheme.primaryColor.withOpacity(0.12),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(Icons.apartment, color: AppTheme.primaryColor, size: 18),
                                    ),
                                    const SizedBox(width: 12),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Room ${p.roomNumber}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.textDark)),
                                        Text(p.tenantName, style: const TextStyle(color: AppTheme.textLight, fontSize: 13)),
                                      ],
                                    )
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(currencyFormat.format(p.amountPaid), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppTheme.secondaryColor)),
                                    Container(
                                      margin: const EdgeInsets.only(top: 4),
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(p.paymentMode, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.textDark)),
                                    )
                                  ],
                                )
                              ],
                            ),
                            const Divider(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.between,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.calendar_today, size: 12, color: AppTheme.textLight),
                                    const SizedBox(width: 4),
                                    Text(DateFormat('dd MMM yyyy, hh:mm a').format(p.date), style: const TextStyle(fontSize: 12, color: AppTheme.textLight)),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Icon(Icons.receipt, size: 12, color: AppTheme.textLight),
                                    const SizedBox(width: 4),
                                    Text('Month: ${p.monthYear}', style: const TextStyle(fontSize: 12, color: AppTheme.textLight)),
                                  ],
                                )
                              ],
                            ),
                            if (p.rentComponent > 0 || p.electricityComponent > 0) ...[
                              const SizedBox(height: 10),
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFBFDFA),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Text('Rent: ${currencyFormat.format(p.rentComponent)}', style: const TextStyle(fontSize: 11, color: AppTheme.textLight)),
                                    const Text('|', style: TextStyle(color: Colors.grey, fontSize: 10)),
                                    Text('Electricity: ${currencyFormat.format(p.electricityComponent)}', style: const TextStyle(fontSize: 11, color: AppTheme.textLight)),
                                  ],
                                ),
                              )
                            ]
                          ],
                        ),
                      );
                  },
                ),
        ),
      ],
    );
  }

  void _openRecordPaymentForm(BuildContext context) {
    final occupiedRooms = widget.rooms.where((r) => r.isOccupied).toList();
    if (occupiedRooms.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No occupied rooms to record payments for!')));
      return;
    }

    Room selectedRoom = occupiedRooms.first;
    final rentController = TextEditingController(text: selectedRoom.pendingRent.toString());
    final elecController = TextEditingController(text: selectedRoom.pendingElectricity.toString());
    String paymentMode = 'UPI';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
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
                  const Text('Record Rent & Utility Payments', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.textDark)),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<Room>(
                    value: selectedRoom,
                    decoration: const InputDecoration(labelText: 'Select Occupied Room'),
                    items: occupiedRooms.map((r) => DropdownMenuItem(value: r, child: Text('Room ${r.roomNumber} - ${r.currentTenantName}'))).toList(),
                    onChanged: (Room? r) {
                      if (r != null) {
                        setModalState(() {
                          selectedRoom = r;
                          rentController.text = r.pendingRent.toString();
                          elecController.text = r.pendingElectricity.toString();
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: rentController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: 'Rent Paid (₹)', helperText: 'Dues outstanding'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: elecController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: 'Electricity Paid (₹)', helperText: 'Dues outstanding'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: paymentMode,
                    decoration: const InputDecoration(labelText: 'Payment Gateway Mode'),
                    items: ['UPI', 'Cash', 'Bank Transfer'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                    onChanged: (val) {
                      if (val != null) setModalState(() => paymentMode = val);
                    },
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        final rPaid = double.tryParse(rentController.text) ?? 0.0;
                        final ePaid = double.tryParse(elecController.text) ?? 0.0;
                        
                        if (rPaid + ePaid <= 0) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter an amount higher than 0.')));
                          return;
                        }

                        widget.onRecordPayment(Payment(
                          id: 'P_${DateTime.now().millisecondsSinceEpoch}',
                          roomNumber: selectedRoom.roomNumber,
                          tenantName: selectedRoom.currentTenantName ?? 'Unknown',
                          date: DateTime.now(),
                          amountPaid: rPaid + ePaid,
                          rentComponent: rPaid,
                          electricityComponent: ePaid,
                          previousReading: selectedRoom.lastMeterReading,
                          currentReading: selectedRoom.lastMeterReading,
                          unitsConsumed: 0,
                          paymentMode: paymentMode,
                          monthYear: 'June 2026',
                        ));
                        
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Rent and Utility payment logged successfully.')));
                      },
                      child: const Text('Log Ledger Entry'),
                    ),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _openQrGenerator(BuildContext context) {
    final occupiedRooms = widget.rooms.where((r) => r.isOccupied).toList();
    if (occupiedRooms.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No occupied rooms available.')));
      return;
    }

    Room selectedRoom = occupiedRooms.first;
    double customAmount = selectedRoom.pendingRent + selectedRoom.pendingElectricity;
    if (customAmount <= 0) {
      customAmount = selectedRoom.baseRentAmount;
    }
    final amountController = TextEditingController(text: customAmount.toString());

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            // Build UPI Payment URL
            // Format: upi://pay?pa=address@okaxis&pn=Sumit%20Rathore&am=1000&cu=INR&tn=Rent%20Room%20101
            final upiUrl = 'upi://pay?pa=${widget.upiId}&pn=Shree%20Ram%20Rooms&am=$customAmount&cu=INR&tn=Rent%20Room%20${selectedRoom.roomNumber}';

            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(width: 40, height: 5, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2.5))),
                  const SizedBox(height: 16),
                  const Text('On-Demand UPI Payment QR', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textDark)),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<Room>(
                    value: selectedRoom,
                    decoration: const InputDecoration(labelText: 'Select Room'),
                    items: occupiedRooms.map((r) => DropdownMenuItem(value: r, child: Text('Room ${r.roomNumber} - ${r.currentTenantName}'))).toList(),
                    onChanged: (Room? r) {
                      if (r != null) {
                        setModalState(() {
                          selectedRoom = r;
                          double total = r.pendingRent + r.pendingElectricity;
                          if (total <= 0) total = r.baseRentAmount;
                          customAmount = total;
                          amountController.text = total.toString();
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Invoice Bill Amount (₹)'),
                    onChanged: (val) {
                      final parsed = double.tryParse(val) ?? 0.0;
                      setModalState(() {
                        customAmount = parsed;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  
                  // QR Container
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: QrImageView(
                      data: upiUrl,
                      version: QrVersions.auto,
                      size: 200.0,
                    ),
                  ),
                  
                  const SizedBox(height: 12),
                  Text(
                    'Scan using GPay, BHIM, PhonePe or Paytm',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'UPI Destination: ${widget.upiId}',
                    style: const TextStyle(fontSize: 11, fontStyle: FontStyle.italic, color: AppTheme.textLight),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(backgroundColor: AppTheme.secondaryColor),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.check),
                      label: const Text('Done'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
