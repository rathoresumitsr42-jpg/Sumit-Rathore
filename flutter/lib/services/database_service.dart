import '../models/room_model.dart';
import '../models/tenant_model.dart';
import '../models/payment_model.dart';
import '../models/electricity_model.dart';
import '../models/expense_model.dart';

abstract class DatabaseService {
  // Rooms
  Future<List<Room>> getRooms();
  Future<void> saveRoom(Room room);
  Future<void> deleteRoom(String roomNumber);

  // Tenants
  Future<List<Tenant>> getTenants();
  Future<void> saveTenant(Tenant tenant);
  Future<void> deleteTenant(String id);

  // Payments
  Future<List<Payment>> getPayments();
  Future<void> savePayment(Payment payment);

  // Electricity
  Future<List<ElectricityReading>> getElectricityReadings();
  Future<void> saveElectricityReading(ElectricityReading reading);

  // Expenses
  Future<List<Expense>> getExpenses();
  Future<void> saveExpense(Expense expense);
  Future<void> deleteExpense(String id);
}

class MockDatabaseService implements DatabaseService {
  final List<Room> _rooms = [];
  final List<Tenant> _beTenants = [];
  final List<Payment> _payments = [];
  final List<ElectricityReading> _readings = [];
  final List<Expense> _expenses = [];

  @override
  Future<List<Room>> getRooms() async {
    return _rooms;
  }

  @override
  Future<void> saveRoom(Room room) async {
    final idx = _rooms.indexWhere((r) => r.roomNumber == room.roomNumber);
    if (idx != -1) {
      _rooms[idx] = room;
    } else {
      _rooms.add(room);
    }
  }

  @override
  Future<void> deleteRoom(String roomNumber) async {
    _rooms.removeWhere((r) => r.roomNumber == roomNumber);
  }

  @override
  Future<List<Tenant>> getTenants() async {
    return _beTenants;
  }

  @override
  Future<void> saveTenant(Tenant tenant) async {
    final idx = _beTenants.indexWhere((t) => t.id == tenant.id);
    if (idx != -1) {
      _beTenants[idx] = tenant;
    } else {
      _beTenants.add(tenant);
    }
  }

  @override
  Future<void> deleteTenant(String id) async {
    _beTenants.removeWhere((t) => t.id == id);
  }

  @override
  Future<List<Payment>> getPayments() async {
    return _payments;
  }

  @override
  Future<void> savePayment(Payment payment) async {
    _payments.insert(0, payment);
  }

  @override
  Future<List<ElectricityReading>> getElectricityReadings() async {
    return _readings;
  }

  @override
  Future<void> saveElectricityReading(ElectricityReading reading) async {
    _readings.removeWhere((r) => r.roomNumber == reading.roomNumber && r.monthYear == reading.monthYear);
    _readings.add(reading);
  }

  @override
  Future<List<Expense>> getExpenses() async {
    return _expenses;
  }

  @override
  Future<void> saveExpense(Expense expense) async {
    final idx = _expenses.indexWhere((e) => e.id == expense.id);
    if (idx != -1) {
      _expenses[idx] = expense;
    } else {
      _expenses.add(expense);
    }
  }

  @override
  Future<void> deleteExpense(String id) async {
    _expenses.removeWhere((e) => e.id == id);
  }
}
