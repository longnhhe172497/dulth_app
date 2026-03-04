import 'package:flutter/material.dart';
import '../../constants.dart';

class BudgetPlanningScreen extends StatefulWidget {
  const BudgetPlanningScreen({super.key});

  @override
  State<BudgetPlanningScreen> createState() => _BudgetPlanningScreenState();
}

class _BudgetPlanningScreenState extends State<BudgetPlanningScreen> {
  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Ngân sách / 예산 계획',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.history, color: AppColors.primary),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- 1. Tổng quan ngân sách (Budget Overview Card) ---
            _buildTotalBudgetCard(isDarkMode),
            const SizedBox(height: 32),

            // --- 2. Danh sách hạng mục (Category List) ---
            _buildSectionHeader('Hạng mục / 카테고리', 'Tháng 10'),
            const SizedBox(height: 16),
            _buildBudgetCategoryItem('Ăn uống / 식비', 1200000, 2000000, Icons.restaurant, isDarkMode),
            _buildBudgetCategoryItem('Nhà cửa / 주거비', 8500000, 10000000, Icons.home, isDarkMode),
            _buildBudgetCategoryItem('Mua sắm / 쇼핑', 450000, 1500000, Icons.shopping_bag, isDarkMode),
            _buildBudgetCategoryItem('Di chuyển / 교통비', 300000, 800000, Icons.directions_bus, isDarkMode),

            const SizedBox(height: 32),

            // --- 3. Nút hành động chính (Sửa lỗi shadowColor) ---
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Logic thêm hoặc chỉnh sửa ngân sách
                },
                icon: const Icon(Icons.add_task),
                label: const Text('Thiết lập ngân sách mới'),
                style: AppStyles.primaryButtonStyle, // ✅ Đã sửa lỗi shadowColor trong constants.dart
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- WIDGET COMPONENTS ---

  Widget _buildTotalBudgetCard(bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.cardDark, AppColors.cardDark.withOpacity(0.8)],
        ),
      ),
      child: Column(
        children: [
          const Text(
            'Tổng ngân sách còn lại',
            style: TextStyle(color: AppColors.textMint, fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          const Text(
            '₫ 4.550.000',
            style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: const LinearProgressIndicator(
              value: 0.72,
              minHeight: 10,
              backgroundColor: AppColors.borderColor,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Đã chi: ₫ 11.450.000', style: TextStyle(color: Colors.white70, fontSize: 12)),
              Text('72%', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, String subtitle) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text(subtitle, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildBudgetCategoryItem(String title, double spent, double total, IconData icon, bool isDarkMode) {
    double progress = spent / total;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.cardDark.withOpacity(0.5) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDarkMode ? AppColors.borderColor.withOpacity(0.2) : Colors.grey[200]!),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: AppColors.primary, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    Text('Còn lại: ₫ ${(total - spent).toInt()}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ),
              Text(
                '${(progress * 100).toInt()}%',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: isDarkMode ? AppColors.borderColor : Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(progress > 0.9 ? Colors.red : AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}