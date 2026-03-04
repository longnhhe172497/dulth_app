import 'package:flutter/material.dart';
import '../../constants.dart';

class CategoryTransactionScreen extends StatelessWidget {
  const CategoryTransactionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: isDarkMode ? Colors.white : Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Chi tiết hạng mục / 카테고리 상세',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // --- 1. TỔNG QUAN CHI TIÊU HẠNG MỤC (CATEGORY SUMMARY) ---
            _buildCategoryHeader(isDarkMode),

            // --- 2. BIỂU ĐỒ XU HƯỚNG NHỎ (MINI TREND) ---
            _buildMiniTrendSection(isDarkMode),

            // --- 3. DANH SÁCH GIAO DIỆN (TRANSACTION LIST) ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Lịch sử / 거래 내역', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text('Tháng 10', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                ],
              ),
            ),

            _buildTransactionList(isDarkMode),

            const SizedBox(height: 32),

            // Nút giải quyết nỗi lo (Sử dụng từ "고민" theo yêu cầu)
            _buildAdviceButton(isDarkMode),

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  // --- CÁC THÀNH PHẦN WIDGET CHI TIẾT ---

  Widget _buildCategoryHeader(bool isDarkMode) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.restaurant, color: AppColors.primary, size: 40),
          ),
          const SizedBox(height: 16),
          const Text('Ăn uống / 식비', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text(
            '₫ 16.020.000',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: AppColors.primary),
          ),
          Text(
            '₩ 865,000 equiv.',
            style: TextStyle(color: isDarkMode ? AppColors.textMint : Colors.grey, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniTrendSection(bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDarkMode ? AppColors.cardDark : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isDarkMode ? AppColors.borderColor.withOpacity(0.2) : Colors.grey[200]!),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('So với tháng trước', style: TextStyle(color: Colors.grey, fontSize: 12)),
                const SizedBox(height: 4),
                Row(
                  children: const [
                    Icon(Icons.trending_up, color: Colors.red, size: 16),
                    SizedBox(width: 4),
                    Text('+12%', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
            _buildMiniBarChart(),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniBarChart() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(5, (index) {
        double height = [20.0, 35.0, 25.0, 45.0, 30.0][index];
        return Container(
          width: 8,
          height: height,
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            color: index == 3 ? AppColors.primary : AppColors.primary.withOpacity(0.2),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }

  Widget _buildTransactionList(bool isDarkMode) {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        _buildItem(Icons.lunch_dining, 'Lotteria / 롯데리아', '24 Oct', '- ₫ 125.000', isDarkMode),
        _buildItem(Icons.local_cafe, 'Starbucks', '22 Oct', '- ₫ 85.000', isDarkMode),
        _buildItem(Icons.restaurant_menu, 'K-BBQ Dinner', '18 Oct', '- ₫ 1.250.000', isDarkMode),
        _buildItem(Icons.shopping_cart, 'GS25 Mart', '15 Oct', '- ₫ 45.000', isDarkMode),
      ],
    );
  }

  Widget _buildItem(IconData icon, String title, String date, String amount, bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.cardDark.withOpacity(0.5) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDarkMode ? Colors.white10 : Colors.grey[100]!),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.textMint, size: 20),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(date, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          Text(amount, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildAdviceButton(bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.psychology_alt),
          label: const Text('Giải quyết 고민 về chi tiêu này'),
          // ✅ ĐÃ SỬA LỖI: shadowColor được bọc trong styleFrom thông qua AppStyles
          style: AppStyles.primaryButtonStyle,
        ),
      ),
    );
  }
}