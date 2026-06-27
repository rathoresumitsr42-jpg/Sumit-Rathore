import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/expense_model.dart';
import '../theme/app_theme.dart';

class ExpenseScreen extends StatefulWidget {
  final List<Expense> expenses;
  final Function(Expense) onAddExpense;
  final Function(String) onDeleteExpense;

  const ExpenseScreen({
    super.key,
    required this.expenses,
    required this.onAddExpense,
    required this.onDeleteExpense,
  });

  @override
  State<ExpenseScreen> createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  String _categoryFilter = 'All';
  String _searchQuery = '';
  
  final List<String> _categories = [
    'All',
    'Water Tanker',
    'Repairs & Plumbing',
    'Cleaning & Waste',
    'Staff Salary',
    'Taxes & Electric',
    'Others',
  ];

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);
    
    // Filtering logic
    final filteredExpenses = widget.expenses.where((exp) {
      final matchesSearch = exp.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          (exp.remarks != null && exp.remarks!.toLowerCase().contains(_searchQuery.toLowerCase()));
      final matchesCategory = _categoryFilter == 'All' || exp.category == _categoryFilter;
      return matchesSearch && matchesCategory;
    }).toList();

    // Sort by date descending
    filteredExpenses.sort((a, b) => b.date.compareTo(a.date));

    // Calculate total expense
    final double totalExpenseAmount = filteredExpenses.fold(0.0, (sum, exp) => sum + exp.amount);

    return Scaffold(
      body: Column(
        children: [
          // Total Expense Display Panel
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFEF4444), Color(0xFFB91C1C)], // Red gradient for expenses
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.red.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'TOTAL OPERATIONAL OUTFLOW',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.white.withOpacity(0.8),
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.between,
                  children: [
                    Text(
                      currencyFormat.format(totalExpenseAmount),
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.black,
                        color: Colors.white,
                      ),
                    ),
                    const Icon(Icons.trending_up, color: Colors.white, size: 28),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Compiled from ${filteredExpenses.length} transaction listings.',
                  style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.7)),
                ),
              ],
            ),
          ),

          // Filters and Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                // Search field
                Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                    child: TextField(
                      onChanged: (val) {
                        setState(() {
                          _searchQuery = val;
                        });
                      },
                      decoration: const InputDecoration(
                        hintText: 'Search expenses, plumbing, cleaning...',
                        prefixIcon: Icon(Icons.search, color: Colors.red),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // Category selection chip list
                SizedBox(
                  height: 42,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      final cat = _categories[index];
                      final isSelected = _categoryFilter == cat;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(cat),
                          selected: isSelected,
                          selectedColor: Colors.red[600],
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : AppTheme.textDark,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                _categoryFilter = cat;
                              });
                            }
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Expense list
          Expanded(
            child: filteredExpenses.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.payments_outlined, size: 64, color: Colors.grey[300]),
                        const SizedBox(height: 12),
                        const Text(
                          'No expenses logged yet.',
                          style: TextStyle(color: AppTheme.textLight),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filteredExpenses.length,
                    itemBuilder: (context, index) {
                      final exp = filteredExpenses[index];
                      return Dismissible(
                        key: Key(exp.id),
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          color: Colors.red,
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        direction: DismissDirection.endToStart,
                        confirmDismiss: (direction) async {
                          return await showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Remove Expense Record?'),
                              content: const Text('Do you want to delete this operational expense log permanently?'),
                              actions: [
                                TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text('Delete'),
                                ),
                              ],
                            ),
                          );
                        },
                        onDismissed: (direction) {
                          widget.onDeleteExpense(exp.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Expense log deleted')),
                          );
                        },
                        child: Card(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: _getCategoryColor(exp.category).withOpacity(0.12),
                              child: Icon(_getCategoryIcon(exp.category), color: _getCategoryColor(exp.category)),
                            ),
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.between,
                              children: [
                                Text(exp.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                                Text(
                                  currencyFormat.format(exp.amount),
                                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                                ),
                              ],
                            ),
                            subtitle: Row(
                              mainAxisAlignment: MainAxisAlignment.between,
                              children: [
                                Text('${exp.category} • ${exp.paymentMode}'),
                                Text(DateFormat('dd MMM, yyyy').format(exp.date), style: const TextStyle(fontSize: 11)),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddExpenseDialog(context),
        backgroundColor: Colors.red[600],
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Water Tanker':
        return Icons.water_drop;
      case 'Repairs & Plumbing':
        return Icons.construction;
      case 'Cleaning & Waste':
        return Icons.cleaning_services_rounded;
      case 'Staff Salary':
        return Icons.people_alt_rounded;
      case 'Taxes & Electric':
        return Icons.electric_bolt_rounded;
      default:
        return Icons.payments_rounded;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Water Tanker':
        return Colors.blue;
      case 'Repairs & Plumbing':
        return Colors.orange;
      case 'Cleaning & Waste':
        return Colors.teal;
      case 'Staff Salary':
        return Colors.purple;
      case 'Taxes & Electric':
        return Colors.amber[800]!;
      default:
        return Colors.grey[700]!;
    }
  }

  void _showAddExpenseDialog(BuildContext context) {
    final titleController = TextEditingController();
    final amountController = TextEditingController();
    final remarksController = TextEditingController();
    String selectedCat = 'Water Tanker';
    String payMode = 'UPI';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Log Property Expense'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(labelText: 'Expense Title / Merchant'),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Expense Outflow (₹)'),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: selectedCat,
                      decoration: const InputDecoration(labelText: 'Expense Category'),
                      items: _categories.skip(1).map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                      onChanged: (val) {
                        if (val != null) setDialogState(() => selectedCat = val);
                      },
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: payMode,
                      decoration: const InputDecoration(labelText: 'Payment Mode'),
                      items: ['UPI', 'Cash', 'Bank Transfer'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                      onChanged: (val) {
                        if (val != null) setDialogState(() => payMode = val);
                      },
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: remarksController,
                      decoration: const InputDecoration(labelText: 'Additional Remarks (Optional)'),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () {
                    if (titleController.text.isEmpty || amountController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill mandatory fields')));
                      return;
                    }
                    final amt = double.tryParse(amountController.text) ?? 0.0;
                    
                    widget.onAddExpense(Expense(
                      id: 'EX_${DateTime.now().millisecondsSinceEpoch}',
                      title: titleController.text.trim(),
                      category: selectedCat,
                      amount: amt,
                      date: DateTime.now(),
                      paymentMode: payMode,
                      remarks: remarksController.text.trim().isEmpty ? null : remarksController.text.trim(),
                    ));
                    
                    Navigator.pop(context);
                  },
                  child: const Text('Log Expense'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
