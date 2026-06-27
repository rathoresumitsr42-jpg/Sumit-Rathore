import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'models/room_model.dart';
import 'models/tenant_model.dart';
import 'models/payment_model.dart';
import 'models/electricity_model.dart';
import 'models/expense_model.dart';
import 'screens/dashboard_screen.dart';
import 'screens/rooms_screen.dart';
import 'screens/tenants_screen.dart';
import 'screens/payments_screen.dart';
import 'screens/electricity_screen.dart';
import 'screens/reports_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/login_screen.dart';
import 'screens/expense_screen.dart';
import 'screens/notifications_screen.dart';
import 'services/auth_service.dart';

void main() {
  runApp(const ShreeRamRoomsManagerApp());
}

class ShreeRamRoomsManagerApp extends StatefulWidget {
  const ShreeRamRoomsManagerApp({super.key});

  @override
  State<ShreeRamRoomsManagerApp> createState() => _ShreeRamRoomsManagerAppState();
}

class _ShreeRamRoomsManagerAppState extends State<ShreeRamRoomsManagerApp> {
  final AuthService _authService = MockAuthService();
  bool _isLoggedIn = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shree Ram Rooms Manager',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: _isLoggedIn
          ? MainNavigationScreen(
              authService: _authService,
              onLogout: () {
                _authService.signOut().then((_) {
                  setState(() {
                    _isLoggedIn = false;
                  });
                });
              },
            )
          : LoginScreen(
              authService: _authService,
              onLoginSuccess: () {
                setState(() {
                  _isLoggedIn = true;
                });
              },
            ),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  final AuthService authService;
  final VoidCallback onLogout;

  const MainNavigationScreen({
    super.key,
    required this.authService,
    required this.onLogout,
  });

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  
  // App-wide state
  List<Room> rooms = [];
  List<Tenant> tenants = [];
  List<Payment> payments = [];
  List<ElectricityReading> electricityReadings = [];
  List<Expense> expenses = [];
  
  // Default Settings
  double electricityRate = 8.0;
  String upiId = "rathoresumit.SR42@okaxis";
  String ownerName = "Sumit Rathore";
  String buildingName = "Shree Ram Residency";

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    // Generate 36 rooms: Floors 1 to 4, 9 rooms per floor (e.g. 101-109, 201-209, etc.)
    final generatedRooms = <Room>[];
    for (int floor = 1; floor <= 4; floor++) {
      for (int r = 1; r <= 9; r++) {
        final roomNum = '$floor${r.toString().padLeft(2, '0')}';
        // Base rent varies slightly by floor (ground floor is cheaper, higher floor is premium or vice-versa)
        final baseRent = (floor == 1) ? 7500.0 : (floor == 2) ? 8000.0 : (floor == 3) ? 8500.0 : 9000.0;
        
        // Randomly pre-occupy some rooms for a realistic feel (70% occupancy)
        final isOccupied = (r % 3 != 0); 
        String? tenantId;
        String? tenantName;
        double pendingRent = 0.0;
        double pendingElec = 0.0;
        double lastReading = 150.0 + (r * 45);

        if (isOccupied) {
          tenantId = 'T_$roomNum';
          tenantName = _getPreseededTenantName(r, floor);
          // Some tenants have partial pending balances
          if (r % 4 == 0) {
            pendingRent = baseRent;
            pendingElec = 180.0;
          } else if (r % 5 == 0) {
            pendingRent = baseRent / 2;
            pendingElec = 90.0;
          }
        }

        generatedRooms.add(Room(
          roomNumber: roomNum,
          floor: floor,
          isOccupied: isOccupied,
          currentTenantId: tenantId,
          currentTenantName: tenantName,
          baseRentAmount: baseRent,
          lastMeterReading: lastReading,
          pendingRent: pendingRent,
          pendingElectricity: pendingElec,
        ));
      }
    }

    // Generate Preseeded Tenants
    final generatedTenants = <Tenant>[];
    for (var r in generatedRooms) {
      if (r.isOccupied && r.currentTenantId != null) {
        generatedTenants.add(Tenant(
          id: r.currentTenantId!,
          name: r.currentTenantName!,
          phone: "+91 98${r.roomNumber}0123",
          roomNumber: r.roomNumber,
          joinDate: DateTime.now().subtract(Duration(days: 30 * r.floor)),
          securityDeposit: r.baseRentAmount * 2,
          initialMeterReading: r.lastMeterReading - 120,
        ));
      }
    }

    // Generate Preseeded Payments (Recent 15 payments)
    final generatedPayments = <Payment>[];
    final monthYears = ["June 2026", "May 2026"];
    int count = 1;
    for (var room in generatedRooms) {
      if (room.isOccupied && count <= 15) {
        generatedPayments.add(Payment(
          id: 'P_$count',
          roomNumber: room.roomNumber,
          tenantName: room.currentTenantName!,
          date: DateTime.now().subtract(Duration(days: count * 2)),
          amountPaid: room.baseRentAmount + 240.0,
          rentComponent: room.baseRentAmount,
          electricityComponent: 240.0,
          previousReading: room.lastMeterReading - 30,
          currentReading: room.lastMeterReading,
          unitsConsumed: 30,
          paymentMode: (count % 3 == 0) ? 'UPI' : (count % 3 == 1) ? 'Cash' : 'Bank Transfer',
          monthYear: monthYears[count % 2],
          transactionId: (count % 3 != 1) ? 'TXN72910${800 + count}' : null,
          remarks: 'Rent & Electricity cleared.',
        ));
        count++;
      }
    }

    // Generate Preseeded Electricity readings
    final generatedReadings = <ElectricityReading>[];
    for (var r in generatedRooms) {
      generatedReadings.add(ElectricityReading(
        id: 'E_${r.roomNumber}_202606',
        roomNumber: r.roomNumber,
        monthYear: 'June 2026',
        previousReading: r.lastMeterReading - 45,
        currentReading: r.lastMeterReading,
        ratePerUnit: electricityRate,
        readingDate: DateTime.now().subtract(const Duration(days: 5)),
        isBilled: true,
        isPaid: r.pendingElectricity == 0,
      ));
    }

    // Generate Preseeded Expenses
    final generatedExpenses = <Expense>[
      Expense(
        id: 'EX_1',
        title: 'Sai Water Supplies',
        category: 'Water Tanker',
        amount: 1200,
        date: DateTime.now().subtract(const Duration(days: 4)),
        paymentMode: 'UPI',
        remarks: 'Two 5000L tankers delivered.',
      ),
      Expense(
        id: 'EX_2',
        title: 'Ramesh Plumbing & Sanitations',
        category: 'Repairs & Plumbing',
        amount: 850,
        date: DateTime.now().subtract(const Duration(days: 7)),
        paymentMode: 'Cash',
        remarks: 'Room 203 washroom leak fixed.',
      ),
      Expense(
        id: 'EX_3',
        title: 'Daily Waste collector tip',
        category: 'Cleaning & Waste',
        amount: 300,
        date: DateTime.now().subtract(const Duration(days: 10)),
        paymentMode: 'Cash',
      ),
    ];

    setState(() {
      rooms = generatedRooms;
      tenants = generatedTenants;
      payments = generatedPayments;
      electricityReadings = generatedReadings;
      expenses = generatedExpenses;
    });
  }

  String _getPreseededTenantName(int r, int floor) {
    final firstNames = ["Amit", "Rakesh", "Sanjay", "Vijay", "Rahul", "Priya", "Anjali", "Ramesh", "Deepak"];
    final lastNames = ["Sharma", "Verma", "Yadav", "Singh", "Patel", "Gupta", "Rao", "Mishra", "Joshi"];
    return "${firstNames[(r - 1) % firstNames.length]} ${lastNames[(floor + r) % lastNames.length]}";
  }

  // Update State Callbacks
  void onAddRoom(Room room) {
    setState(() {
      final index = rooms.indexWhere((r) => r.roomNumber == room.roomNumber);
      if (index != -1) {
        rooms[index] = room;
      } else {
        rooms.add(room);
      }
    });
  }

  void onAddExpense(Expense expense) {
    setState(() {
      expenses.add(expense);
    });
  }

  void onDeleteExpense(String id) {
    setState(() {
      expenses.removeWhere((e) => e.id == id);
    });
  }

  void onAddTenant(Tenant tenant, double baseRent) {
    setState(() {
      // Avoid duplicate tenants
      tenants.removeWhere((t) => t.id == tenant.id);
      tenants.add(tenant);
      final index = rooms.indexWhere((r) => r.roomNumber == tenant.roomNumber);
      if (index != -1) {
        rooms[index] = rooms[index].copyWith(
          isOccupied: true,
          currentTenantId: tenant.id,
          currentTenantName: tenant.name,
          baseRentAmount: baseRent,
          lastMeterReading: tenant.initialMeterReading,
          pendingRent: 0.0,
          pendingElectricity: 0.0,
        );
      }
    });
  }

  void onEvictTenant(String roomNumber) {
    setState(() {
      final index = rooms.indexWhere((r) => r.roomNumber == roomNumber);
      if (index != -1) {
        final tenantId = rooms[index].currentTenantId;
        rooms[index] = rooms[index].copyWith(
          isOccupied: false,
          currentTenantId: null,
          currentTenantName: null,
          pendingRent: 0.0,
          pendingElectricity: 0.0,
        );
        tenants.removeWhere((t) => t.id == tenantId);
      }
    });
  }

  void onRecordPayment(Payment payment) {
    setState(() {
      payments.insert(0, payment);
      final index = rooms.indexWhere((r) => r.roomNumber == payment.roomNumber);
      if (index != -1) {
        // Adjust outstanding balances based on what was paid
        double newPendingRent = (rooms[index].pendingRent - payment.rentComponent).clamp(0, double.infinity);
        double newPendingElec = (rooms[index].pendingElectricity - payment.electricityComponent).clamp(0, double.infinity);
        
        rooms[index] = rooms[index].copyWith(
          pendingRent: newPendingRent,
          pendingElectricity: newPendingElec,
        );
      }
    });
  }

  void onAddMeterReading(ElectricityReading reading) {
    setState(() {
      electricityReadings.removeWhere((e) => e.roomNumber == reading.roomNumber && e.monthYear == reading.monthYear);
      electricityReadings.add(reading);
      
      final index = rooms.indexWhere((r) => r.roomNumber == reading.roomNumber);
      if (index != -1) {
        rooms[index] = rooms[index].copyWith(
          lastMeterReading: reading.currentReading,
          pendingElectricity: rooms[index].pendingElectricity + reading.totalAmount,
        );
      }
    });
  }

  void onUpdateSettings(double rate, String upi, String owner, String building) {
    setState(() {
      electricityRate = rate;
      upiId = upi;
      ownerName = owner;
      buildingName = building;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      DashboardScreen(
        rooms: rooms, 
        payments: payments, 
        electricityReadings: electricityReadings,
        electricityRate: electricityRate,
        onQuickRecordPayment: onRecordPayment,
        onQuickAddTenant: onAddTenant,
      ),
      RoomsScreen(
        rooms: rooms,
        tenants: tenants,
        onAddTenant: onAddTenant,
        onEvictTenant: onEvictTenant,
        onRecordPayment: onRecordPayment,
        onAddMeterReading: onAddMeterReading,
        electricityRate: electricityRate,
        onAddRoom: onAddRoom,
      ),
      PaymentsScreen(
        payments: payments,
        rooms: rooms,
        onRecordPayment: onRecordPayment,
        upiId: upiId,
      ),
      ReportsScreen(
        rooms: rooms,
        payments: payments,
        electricityReadings: electricityReadings,
        buildingName: buildingName,
        ownerName: ownerName,
      ),
      SettingsScreen(
        electricityRate: electricityRate,
        upiId: upiId,
        ownerName: ownerName,
        buildingName: buildingName,
        onUpdateSettings: onUpdateSettings,
        totalRooms: rooms.length,
        occupiedRooms: rooms.where((r) => r.isOccupied).length,
      )
    ];

    return Scaffold(
      drawer: NavigationDrawer(
        onDestinationSelected: (value) {
          Navigator.pop(context); // Close Drawer
          if (value < 5) {
            setState(() {
              _currentIndex = value;
            });
          } else {
            _openDrawerPage(value);
          }
        },
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(28, 20, 16, 10),
            child: Row(
              children: [
                const Icon(Icons.apartment, color: AppTheme.primaryColor, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        buildingName,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppTheme.primaryDarkColor,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'Owner: $ownerName',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(indent: 20, endIndent: 20),
          const NavigationDrawerDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard, color: AppTheme.primaryColor),
            label: Text('Dashboard'),
          ),
          const NavigationDrawerDestination(
            icon: Icon(Icons.meeting_room_outlined),
            selectedIcon: Icon(Icons.meeting_room, color: AppTheme.primaryColor),
            label: Text('Rooms'),
          ),
          const NavigationDrawerDestination(
            icon: Icon(Icons.payment_outlined),
            selectedIcon: Icon(Icons.payment, color: AppTheme.primaryColor),
            label: Text('Payments'),
          ),
          const NavigationDrawerDestination(
            icon: Icon(Icons.analytics_outlined),
            selectedIcon: Icon(Icons.analytics, color: AppTheme.primaryColor),
            label: Text('Reports'),
          ),
          const NavigationDrawerDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings, color: AppTheme.primaryColor),
            label: Text('Settings'),
          ),
          const Divider(indent: 20, endIndent: 20),
          const Padding(
            padding: EdgeInsets.fromLTRB(28, 10, 16, 10),
            child: Text('Operational Sheets', style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.secondaryColor)),
          ),
          const NavigationDrawerDestination(
            icon: Icon(Icons.people_alt_outlined),
            selectedIcon: Icon(Icons.people_alt, color: AppTheme.secondaryColor),
            label: Text('Tenants Directory'),
          ),
          const NavigationDrawerDestination(
            icon: Icon(Icons.electric_bolt_outlined),
            selectedIcon: Icon(Icons.electric_bolt, color: AppTheme.secondaryColor),
            label: Text('Electricity Ledger'),
          ),
          const NavigationDrawerDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long, color: AppTheme.secondaryColor),
            label: Text('Expense Ledger'),
          ),
          const NavigationDrawerDestination(
            icon: Icon(Icons.share_outlined),
            selectedIcon: Icon(Icons.share, color: AppTheme.secondaryColor),
            label: Text('Rent Reminders'),
          ),
          const Divider(indent: 20, endIndent: 20),
          const NavigationDrawerDestination(
            icon: Icon(Icons.logout, color: Colors.red),
            label: Text('Sign Out', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.apartment, color: AppTheme.primaryColor),
            const SizedBox(width: 8),
            Text(
              _currentIndex == 0 ? buildingName : _currentIndex == 1 ? 'Rooms List' : _currentIndex == 2 ? 'Payments Hub' : _currentIndex == 3 ? 'Revenue Reports' : 'System Settings',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_active_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Scaffold(
                    appBar: AppBar(title: const Text('Property Alerts & Reminders')),
                    body: NotificationsScreen(
                      rooms: rooms,
                      proprietorUpi: upiId,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: screens[_currentIndex],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.meeting_room_outlined),
            selectedIcon: Icon(Icons.meeting_room),
            label: 'Rooms',
          ),
          NavigationDestination(
            icon: Icon(Icons.payment_outlined),
            selectedIcon: Icon(Icons.payment),
            label: 'Payments',
          ),
          NavigationDestination(
            icon: Icon(Icons.analytics_outlined),
            selectedIcon: Icon(Icons.analytics),
            label: 'Reports',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  void _openDrawerPage(int index) {
    if (index == 5) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(title: const Text('Tenants Directory')),
            body: TenantsScreen(
              tenants: tenants,
              rooms: rooms,
              onAddTenant: onAddTenant,
              onEvictTenant: onEvictTenant,
            ),
          ),
        ),
      );
    } else if (index == 6) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(title: const Text('Electricity Ledger')),
            body: ElectricityScreen(
              rooms: rooms,
              electricityRate: electricityRate,
              onAddMeterReading: onAddMeterReading,
            ),
          ),
        ),
      );
    } else if (index == 7) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(title: const Text('Expenses Tracker')),
            body: ExpenseScreen(
              expenses: expenses,
              onAddExpense: onAddExpense,
              onDeleteExpense: onDeleteExpense,
            ),
          ),
        ),
      );
    } else if (index == 8) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(title: const Text('Reminders & Shared Template')),
            body: NotificationsScreen(
              rooms: rooms,
              proprietorUpi: upiId,
            ),
          ),
        ),
      );
    } else if (index == 9) {
      widget.onLogout();
    }
  }
}
