import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../constants.dart';
import '../services/firestore_service.dart';
import '../l10n/app_localizations.dart';
import '../utils/currency_formatter.dart';

class AddTransactionBottomSheet extends StatefulWidget {
  const AddTransactionBottomSheet({super.key});

  @override
  State<AddTransactionBottomSheet> createState() =>
      _AddTransactionBottomSheetState();
}

class _AddTransactionBottomSheetState
    extends State<AddTransactionBottomSheet> {

  bool _isExpense = true;
  String _selectedCategory = "food";

  DateTime _selectedDate = DateTime.now();

  final TextEditingController _amountController =
  TextEditingController();

  final TextEditingController _noteController =
  TextEditingController();

  bool _isLoading = false;

  /// DATE PICKER
  Future<void> _pickDate() async {

    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  /// WARNING DIALOG
  void _showInsufficientBalance(double balance, double amount) {

    final loc = AppLocalizations.of(context);

    showDialog(

      context: context,

      builder: (context) {

        return AlertDialog(

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),

          title: Row(
            children: [
              const Icon(Icons.warning, color: Colors.red),
              const SizedBox(width: 8),
              Text(loc.insufficientBalance),
            ],
          ),

          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Text(
                "${loc.yourBalance}: ${formatVND(balance)}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 8),

              Text(
                "${loc.youTriedToSpend}: ${formatVND(amount)}",
                style: const TextStyle(color: Colors.red),
              ),

              const SizedBox(height: 12),

              Text(loc.balanceWarningMessage),

            ],
          ),

          actions: [

            ElevatedButton(

              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),

              onPressed: () {
                Navigator.pop(context);
              },

              child: Text(loc.ok),

            )
          ],
        );
      },
    );
  }

  /// SAVE TRANSACTION
  Future<void> _saveTransaction() async {

    if (_amountController.text.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    try {

      final amount = double.parse(_amountController.text);

      final uid = FirebaseAuth.instance.currentUser!.uid;

      /// LẤY BALANCE HIỆN TẠI
      final userDoc = await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .get();

      final data = userDoc.data() as Map<String, dynamic>;

      final balance = (data["balance"] ?? 0).toDouble();

      /// KIỂM TRA VƯỢT SỐ DƯ
      if (_isExpense && amount > balance) {

        _showInsufficientBalance(balance, amount);

        setState(() {
          _isLoading = false;
        });

        return;
      }

      /// LƯU TRANSACTION
      await FirestoreService().addTransaction(

        amount: amount,

        category: _selectedCategory,

        type: _isExpense ? "expense" : "income",

        note: _noteController.text,

        date: _selectedDate,

      );

      if (mounted) Navigator.pop(context);

    } catch (e) {

      ScaffoldMessenger.of(context).showSnackBar(

        const SnackBar(
          content: Text("Error saving transaction"),
        ),

      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    final loc = AppLocalizations.of(context);

    bool isDarkMode =
        Theme.of(context).brightness == Brightness.dark;

    return Container(

      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),

      decoration: BoxDecoration(
        color: isDarkMode
            ? AppColors.backgroundDark
            : AppColors.backgroundLight,
        borderRadius:
        const BorderRadius.vertical(top: Radius.circular(32)),
      ),

      child: SingleChildScrollView(

        padding: const EdgeInsets.all(24),

        child: Column(

          mainAxisSize: MainAxisSize.min,

          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            /// DRAG BAR
            Center(
              child: Container(
                width: 48,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            const SizedBox(height: 24),

            /// EXPENSE / INCOME SWITCH
            _buildToggleSwitch(isDarkMode, loc),

            const SizedBox(height: 32),

            /// AMOUNT
            _buildLabel(loc.amount, isDarkMode),

            _buildAmountInput(isDarkMode),

            const SizedBox(height: 24),

            /// CATEGORY
            _buildLabel(loc.category, isDarkMode),

            _buildCategoryGrid(isDarkMode, loc),

            const SizedBox(height: 24),

            /// DATE
            _buildLabel(loc.date, isDarkMode),

            _buildDatePicker(isDarkMode),

            const SizedBox(height: 24),

            /// NOTES
            _buildLabel(loc.notes, isDarkMode),

            _buildNotesInput(isDarkMode, loc),

            const SizedBox(height: 32),

            /// SAVE BUTTON
            SizedBox(

              width: double.infinity,

              height: 56,

              child: ElevatedButton(

                onPressed: _isLoading ? null : _saveTransaction,

                style: AppStyles.primaryButtonStyle,

                child: _isLoading
                    ? const CircularProgressIndicator(
                    color: Colors.white)
                    : Text(loc.saveTransaction),

              ),
            ),

            const SizedBox(height: 12),

          ],
        ),
      ),
    );
  }

  /// LABEL
  Widget _buildLabel(String text, bool isDarkMode) {

    return Padding(

      padding: const EdgeInsets.only(bottom: 8, left: 4),

      child: Text(

        text,

        style: TextStyle(
          color: isDarkMode
              ? AppColors.textMint
              : Colors.grey[600],
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// AMOUNT INPUT
  Widget _buildAmountInput(bool isDarkMode) {

    return TextField(

      controller: _amountController,

      keyboardType: TextInputType.number,

      style: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: _isExpense ? Colors.red : Colors.green,
      ),

      decoration: InputDecoration(

        hintText: '0',

        suffixText: 'VND',

        filled: true,

        fillColor:
        isDarkMode ? AppColors.inputBgDark : Colors.white,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  /// CATEGORY GRID
  Widget _buildCategoryGrid(bool isDarkMode, AppLocalizations loc) {

    final expenseCategories = [

      {'icon': Icons.restaurant, 'key': 'food', 'label': loc.food},

      {'icon': Icons.shopping_bag, 'key': 'shopping', 'label': loc.shopping},

      {'icon': Icons.directions_bus, 'key': 'transport', 'label': loc.transport},

      {'icon': Icons.computer, 'key': 'tech', 'label': loc.tech},

    ];

    final incomeCategories = [

      {'icon': Icons.payments, 'key': 'salary', 'label': loc.income},

      {'icon': Icons.card_giftcard, 'key': 'gift', 'label': "Gift"},

      {'icon': Icons.trending_up, 'key': 'investment', 'label': "Investment"},

      {'icon': Icons.attach_money, 'key': 'other_income', 'label': "Other"},

    ];

    final categories =
    _isExpense ? expenseCategories : incomeCategories;

    return Wrap(

      spacing: 12,

      runSpacing: 12,

      children: categories.map((cat) {

        bool isSelected =
            _selectedCategory == cat['key'];

        return GestureDetector(

          onTap: () {

            setState(() {
              _selectedCategory =
              cat['key'] as String;
            });

          },

          child: Container(

            padding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 10),

            decoration: BoxDecoration(

              color: isSelected
                  ? (_isExpense
                  ? Colors.red.withOpacity(0.15)
                  : Colors.green.withOpacity(0.15))
                  : (isDarkMode
                  ? AppColors.cardDark
                  : Colors.white),

              borderRadius: BorderRadius.circular(12),

              border: Border.all(
                color: isSelected
                    ? (_isExpense
                    ? Colors.red
                    : Colors.green)
                    : (isDarkMode
                    ? Colors.white10
                    : Colors.grey[300]!),
              ),
            ),

            child: Row(

              mainAxisSize: MainAxisSize.min,

              children: [

                Icon(
                  cat['icon'] as IconData,
                  size: 18,
                  color: isSelected
                      ? (_isExpense
                      ? Colors.red
                      : Colors.green)
                      : Colors.grey,
                ),

                const SizedBox(width: 8),

                Text(
                  cat['label'] as String,
                  style: TextStyle(
                    color: isSelected
                        ? (_isExpense
                        ? Colors.red
                        : Colors.green)
                        : Colors.grey,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),

              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  /// DATE PICKER
  Widget _buildDatePicker(bool isDarkMode) {

    return GestureDetector(

      onTap: _pickDate,

      child: Container(

        padding: const EdgeInsets.symmetric(
            horizontal: 16, vertical: 16),

        decoration: BoxDecoration(

          color: isDarkMode
              ? AppColors.inputBgDark
              : Colors.white,

          borderRadius: BorderRadius.circular(16),

          border: Border.all(
            color: Colors.grey.shade300,
          ),
        ),

        child: Row(

          mainAxisAlignment:
          MainAxisAlignment.spaceBetween,

          children: [

            Text(
              "${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}",
            ),

            const Icon(Icons.calendar_today),

          ],
        ),
      ),
    );
  }

  /// NOTES
  Widget _buildNotesInput(bool isDarkMode, AppLocalizations loc) {

    return TextField(

      controller: _noteController,

      maxLines: 2,

      decoration: InputDecoration(

        hintText: loc.addNote,

        filled: true,

        fillColor:
        isDarkMode ? AppColors.inputBgDark : Colors.white,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildToggleSwitch(bool isDarkMode, AppLocalizations loc) {

    return Row(

      children: [

        Expanded(

          child: GestureDetector(

            onTap: () {

              setState(() {
                _isExpense = true;
              });

            },

            child: Container(

              padding: const EdgeInsets.symmetric(vertical: 12),

              decoration: BoxDecoration(

                color: _isExpense
                    ? Colors.red
                    : (isDarkMode ? Colors.grey[800] : Colors.grey[200]),

                borderRadius: BorderRadius.circular(12),

              ),

              child: Center(

                child: Text(

                  loc.expenses,

                  style: TextStyle(

                    color: _isExpense
                        ? Colors.white
                        : (isDarkMode ? Colors.white70 : Colors.black54),

                    fontWeight: FontWeight.bold,

                  ),

                ),

              ),

            ),

          ),

        ),

        const SizedBox(width: 12),

        Expanded(

          child: GestureDetector(

            onTap: () {

              setState(() {
                _isExpense = false;
              });

            },

            child: Container(

              padding: const EdgeInsets.symmetric(vertical: 12),

              decoration: BoxDecoration(

                color: !_isExpense
                    ? Colors.green
                    : (isDarkMode ? Colors.grey[800] : Colors.grey[200]),

                borderRadius: BorderRadius.circular(12),

              ),

              child: Center(

                child: Text(

                  loc.income,

                  style: TextStyle(

                    color: !_isExpense
                        ? Colors.white
                        : (isDarkMode ? Colors.white70 : Colors.black54),

                    fontWeight: FontWeight.bold,

                  ),

                ),

              ),

            ),

          ),

        ),

      ],

    );
  }
}