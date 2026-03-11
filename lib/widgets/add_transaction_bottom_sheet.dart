import 'package:flutter/material.dart';
import '../constants.dart';
import '../services/firestore_service.dart';
import '../l10n/app_localizations.dart';

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

  Future<void> _saveTransaction() async {

    if (_amountController.text.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    try {

      await FirestoreService().addTransaction(

        amount: double.parse(_amountController.text),

        category: _selectedCategory,

        type: _isExpense ? "expense" : "income",

        note: _noteController.text,

        date: _selectedDate,

      );

      if (mounted) Navigator.pop(context);

    } catch (e) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Error saving transaction")),
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

            _buildToggleSwitch(isDarkMode, loc),

            const SizedBox(height: 32),

            _buildLabel(loc.amount, isDarkMode),

            _buildAmountInput(isDarkMode),

            const SizedBox(height: 24),

            _buildLabel(loc.category, isDarkMode),

            _buildCategoryGrid(isDarkMode, loc),

            const SizedBox(height: 24),

            _buildLabel(loc.date, isDarkMode),

            _buildDatePicker(isDarkMode),

            const SizedBox(height: 24),

            _buildLabel(loc.notes, isDarkMode),

            _buildNotesInput(isDarkMode, loc),

            const SizedBox(height: 32),

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

  Widget _buildToggleSwitch(bool isDarkMode, AppLocalizations loc) {

    return Container(

      padding: const EdgeInsets.all(4),

      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.cardDark : Colors.grey[200],
        borderRadius: BorderRadius.circular(16),
      ),

      child: Row(

        children: [

          _buildToggleButton(
            loc.expenses,
            _isExpense,
                () => setState(() => _isExpense = true),
          ),

          _buildToggleButton(
            loc.income,
            !_isExpense,
                () => setState(() => _isExpense = false),
          ),

        ],
      ),
    );
  }

  Widget _buildToggleButton(
      String label,
      bool isActive,
      VoidCallback onTap) {

    return Expanded(

      child: GestureDetector(

        onTap: onTap,

        child: Container(

          padding:
          const EdgeInsets.symmetric(vertical: 12),

          decoration: BoxDecoration(
            color: isActive
                ? AppColors.primary
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),

          child: Center(

            child: Text(

              label,

              style: TextStyle(
                fontWeight: FontWeight.bold,
                color:
                isActive ? Colors.black : Colors.grey,
              ),
            ),
          ),
        ),
      ),
    );
  }

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

  Widget _buildAmountInput(bool isDarkMode) {

    return TextField(

      controller: _amountController,

      keyboardType: TextInputType.number,

      style: const TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),

      decoration: InputDecoration(

        hintText: '0',

        suffixText: 'VND',

        filled: true,

        fillColor: isDarkMode
            ? AppColors.inputBgDark
            : Colors.white,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
              color: AppColors.primary, width: 2),
        ),
      ),
    );
  }

  Widget _buildCategoryGrid(
      bool isDarkMode,
      AppLocalizations loc) {

    final categories = [

      {'icon': Icons.restaurant, 'key': 'food', 'label': loc.food},

      {'icon': Icons.shopping_bag, 'key': 'shopping', 'label': loc.shopping},

      {'icon': Icons.directions_bus, 'key': 'transport', 'label': loc.transport},

      {'icon': Icons.computer, 'key': 'tech', 'label': loc.tech},

    ];

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
                  ? AppColors.primary.withOpacity(0.15)
                  : (isDarkMode
                  ? AppColors.cardDark
                  : Colors.white),

              borderRadius: BorderRadius.circular(12),

              border: Border.all(
                color: isSelected
                    ? AppColors.primary
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
                      ? AppColors.primary
                      : Colors.grey,
                ),

                const SizedBox(width: 8),

                Text(
                  cat['label'] as String,
                  style: TextStyle(
                    color: isSelected
                        ? AppColors.primary
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

  Widget _buildNotesInput(
      bool isDarkMode,
      AppLocalizations loc) {

    return TextField(

      controller: _noteController,

      maxLines: 2,

      decoration: InputDecoration(

        hintText: loc.addNote,

        filled: true,

        fillColor: isDarkMode
            ? AppColors.inputBgDark
            : Colors.white,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}