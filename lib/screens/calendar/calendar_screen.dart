import 'package:flutter/material.dart';
import '../../constants.dart';

class TransactionCalendarScreen extends StatefulWidget {
  const TransactionCalendarScreen({super.key});

  @override
  State<TransactionCalendarScreen> createState() => _TransactionCalendarScreenState();
}

class _TransactionCalendarScreenState extends State<TransactionCalendarScreen> {
  DateTime _focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Lịch giao dịch / giao dịch 달력',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.filter_list, color: AppColors.primary),
          ),
        ],
      ),
      body: Column(
        children: [
          // --- 1. Calendar Header / Month Selector ---
          _buildMonthHeader(isDarkMode),

          // --- 2. Weekdays Header ---
          _buildWeekdaysRow(),

          // --- 3. Calendar Grid ---
          _buildCalendarGrid(isDarkMode),

          const SizedBox(height: 16),

          // --- 4. Daily Transactions List ---
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(top: 24),
              decoration: BoxDecoration(
                color: isDarkMode ? AppColors.cardDark.withOpacity(0.5) : Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: _buildDailyTransactionList(isDarkMode),
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGET COMPONENTS ---

  Widget _buildMonthHeader(bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Tháng 10, 2023',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Row(
            children: [
              _buildSmallIconButton(Icons.chevron_left, isDarkMode),
              const SizedBox(width: 8),
              _buildSmallIconButton(Icons.chevron_right, isDarkMode),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSmallIconButton(IconData icon, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.borderColor.withOpacity(0.2) : Colors.grey[200],
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: 20),
    );
  }

  Widget _buildWeekdaysRow() {
    final days = ['CN', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7'];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: days.map((day) => Text(
            day,
            style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 12)
        )).toList(),
      ),
    );
  }

  Widget _buildCalendarGrid(bool isDarkMode) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      itemCount: 31,
      itemBuilder: (context, index) {
        int day = index + 1;
        bool isSelected = day == 24;
        bool hasIncome = day == 10 || day == 24;
        bool hasExpense = day == 15 || day == 24;

        return Column(
          children: [
            Container(
              height: 36,
              width: 36,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Text(
                '$day',
                style: TextStyle(
                  color: isSelected ? Colors.black : (isDarkMode ? Colors.white : Colors.black),
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (hasIncome) Container(width: 4, height: 4, decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle)),
                if (hasIncome && hasExpense) const SizedBox(width: 2),
                if (hasExpense) Container(width: 4, height: 4, decoration: const BoxDecoration(color: Colors.orange, shape: BoxShape.circle)),
              ],
            )
          ],
        );
      },
    );
  }

  Widget _buildDailyTransactionList(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            '24 Tháng 10 / 10월 24일',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textMint),
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              _buildTransactionItem(Icons.restaurant, 'Lotteria', '12:45 PM • Ăn uống', '- ₫ 125.000', isDarkMode),
              _buildTransactionItem(Icons.payments, 'Lương / 급여', '09:00 AM • Thu nhập', '+ ₫ 15.000.000', isDarkMode, isIncome: true),
              _buildTransactionItem(Icons.shopping_bag, 'Uniqlo', '06:30 PM • Mua sắm', '- ₫ 850.000', isDarkMode),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionItem(IconData icon, String title, String time, String amount, bool isDarkMode, {bool isIncome = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.backgroundDark.withOpacity(0.5) : Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                Text(time, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          Text(
            amount,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isIncome ? AppColors.primary : (isDarkMode ? Colors.white : Colors.black)
            ),
          ),
        ],
      ),
    );
  }
}