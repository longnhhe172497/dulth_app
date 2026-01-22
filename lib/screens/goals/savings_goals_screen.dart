import 'package:flutter/material.dart';
import '../../constants.dart';
import 'goal_details_screen.dart';

class SavingsGoalsScreen extends StatefulWidget {
  const SavingsGoalsScreen({super.key});

  @override
  State<SavingsGoalsScreen> createState() => _SavingsGoalsScreenState();
}

class _SavingsGoalsScreenState extends State<SavingsGoalsScreen> {
  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Mục tiêu tiết kiệm / 저축 목표',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.sort, color: AppColors.primary),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // --- 1. Tổng kết mục tiêu (Goals Summary Card) ---
            _buildTotalSavingsCard(isDarkMode),
            const SizedBox(height: 32),

            // --- 2. Danh sách mục tiêu (Goals List) ---
            _buildSectionHeader('Đang thực hiện / 진행 중'),
            const SizedBox(height: 16),

            // Mục tiêu: Mua Laptop (Liên quan đến sinh viên IT)
            _buildGoalItem(
              context,
              'Buy Laptop (MacBook Pro)',
              'Mục tiêu công việc / công việc mục tiêu',
              15000000, 25000000,
              Icons.laptop_mac,
              isDarkMode,
            ),

            // Mục tiêu: Du lịch Seoul (Liên quan đến sở thích học tiếng Hàn)
            _buildGoalItem(
              context,
              'Travel to Seoul',
              'Du lịch & Khám phá / 여행',
              8000000, 20000000,
              Icons.flight_takeoff,
              isDarkMode,
            ),

            // Mục tiêu: Build PC (Liên quan đến việc build PC cũ)
            _buildGoalItem(
              context,
              'Upgrade Gaming PC',
              'Giải trí / giải trí',
              5000000, 12000000,
              Icons.desktop_windows,
              isDarkMode,
            ),

            const SizedBox(height: 32),

            // --- 3. Nút thêm mục tiêu mới (Sửa lỗi shadowColor) ---
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Logic thêm mục tiêu mới
                },
                icon: const Icon(Icons.add_circle_outline),
                label: const Text('Thêm mục tiêu mới / mục tiêu 추가'),
                style: AppStyles.primaryButtonStyle, // ✅ Đã sửa lỗi shadowColor
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- WIDGET COMPONENTS ---

  Widget _buildTotalSavingsCard(bool isDarkMode) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Column(
        children: [
          const Text(
            'Tổng số tiền đã tiết kiệm',
            style: TextStyle(color: AppColors.textMint, fontSize: 13, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            '28,000,000 ₫',
            style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            '₩ 1,512,000 equiv.',
            style: TextStyle(color: AppColors.textMint, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
            letterSpacing: 1.2
        ),
      ),
    );
  }

  Widget _buildGoalItem(
      BuildContext context,
      String title,
      String category,
      double current,
      double target,
      IconData icon,
      bool isDarkMode,
      ) {
    double progress = current / target;

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const GoalDetailsScreen()),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDarkMode ? AppColors.cardDark.withOpacity(0.6) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isDarkMode ? AppColors.borderColor.withOpacity(0.2) : Colors.grey[200]!),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: AppColors.primary, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text(category, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                ),
                Text(
                  '${(progress * 100).toInt()}%',
                  style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor: isDarkMode ? AppColors.borderColor : Colors.grey[300],
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${current.toInt()} ₫',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                Text(
                  'Mục tiêu: ${target.toInt()} ₫',
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}