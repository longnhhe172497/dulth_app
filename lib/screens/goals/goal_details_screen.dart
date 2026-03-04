import 'dart:ui';
import 'package:flutter/material.dart';
import '../../constants.dart';

class GoalDetailsScreen extends StatelessWidget {
  const GoalDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: Stack(
        children: [
          // --- 1. NỘI DUNG CHÍNH (CUỘN ĐƯỢC) ---
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 80), // Khoảng trống cho Top Bar

                // Hình ảnh Header & Tên mục tiêu
                _buildHeroHeader(isDarkMode),

                // Tổng quan tiến độ (60% Complete)
                _buildProgressOverview(isDarkMode),

                // Lưới thông số chính (Target vs Remaining)
                _buildStatsGrid(isDarkMode),

                // Lịch sử đóng góp (Contribution History)
                _buildHistorySection(isDarkMode),

                const SizedBox(height: 120), // Khoảng trống cho Bottom Bar
              ],
            ),
          ),

          // --- 2. THANH ĐIỀU HƯỚNG TRÊN CÙNG (STICKY TOP BAR) ---
          Positioned(top: 0, left: 0, right: 0, child: _buildTopBar(isDarkMode, context)),

          // --- 3. THANH HÀNH ĐỘNG DƯỚI CÙNG (FIXED BOTTOM BAR) ---
          Positioned(bottom: 0, left: 0, right: 0, child: _buildBottomActionBar(isDarkMode)),
        ],
      ),
    );
  }

  // --- CÁC THÀNH PHẦN WIDGET CHI TIẾT ---

  Widget _buildTopBar(bool isDarkMode, BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 48, 16, 12),
          color: (isDarkMode ? AppColors.backgroundDark : AppColors.backgroundLight).withOpacity(0.8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back_ios, color: isDarkMode ? Colors.white : Colors.black, size: 20),
                onPressed: () => Navigator.pop(context),
              ),
              const Text('Goal Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const Icon(Icons.more_horiz, size: 28),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroHeader(bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        height: 220,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: const DecorationImage(
            image: NetworkImage('https://images.unsplash.com/photo-1496181133206-80ce9b88a853?q=80&w=600'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, (isDarkMode ? AppColors.backgroundDark : Colors.black).withOpacity(0.9)],
            ),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
                child: const Text('Electronics', style: TextStyle(color: AppColors.primary, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 4),
              const Text('Buy Laptop', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900)),
              const Text('MacBook Pro 14-inch M3', style: TextStyle(color: Colors.white70, fontSize: 14)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressOverview(bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('STATUS / TRẠNG THÁI', style: TextStyle(color: isDarkMode ? AppColors.textMint : Colors.grey, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                  const Text('60% Complete', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: const [
                  Text('15,000,000 ₫', style: TextStyle(color: AppColors.primary, fontSize: 18, fontWeight: FontWeight.bold)),
                  Text('800,000 ₩ equiv.', style: TextStyle(color: AppColors.textMint, fontSize: 11, fontWeight: FontWeight.w500)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: const LinearProgressIndicator(
              value: 0.6,
              minHeight: 12,
              backgroundColor: AppColors.borderColor,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          _buildStatCard('Target / Mục tiêu', '25,000,000 ₫', '₩1,350,000', Icons.flag, isDarkMode, Colors.grey),
          const SizedBox(width: 16),
          _buildStatCard('Remaining / Còn lại', '10,000,000 ₫', '₩550,000', Icons.pending_actions, isDarkMode, AppColors.primary),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String amount, String sub, IconData icon, bool isDarkMode, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDarkMode ? AppColors.cardDark : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [Icon(icon, size: 18, color: color), const SizedBox(width: 8), Text(label.toUpperCase(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.2))]),
            const SizedBox(height: 12),
            Text(amount, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(sub, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildHistorySection(bool isDarkMode) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('History / Lịch sử đóng góp', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const Text('See All', style: TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        _buildHistoryItem('Monthly Savings', 'Oct 12, 2023', '+2,000,000 ₫', '₩108,000', Icons.add_circle, isDarkMode),
        _buildHistoryItem('Bonus Deposit', 'Sep 28, 2023', '+5,000,000 ₫', '₩270,000', Icons.payments, isDarkMode),
        _buildHistoryItem('Rounding Up', 'Sep 15, 2023', '+500,000 ₫', '₩27,000', Icons.savings, isDarkMode),
      ],
    );
  }

  Widget _buildHistoryItem(String title, String date, String val, String subVal, IconData icon, bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.cardDark.withOpacity(0.4) : Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          CircleAvatar(backgroundColor: AppColors.primary.withOpacity(0.1), child: Icon(icon, color: AppColors.primary, size: 20)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                Text(date, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(val, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 14)),
              Text(subVal, style: const TextStyle(color: Colors.grey, fontSize: 10)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActionBar(bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [isDarkMode ? AppColors.backgroundDark : AppColors.backgroundLight, (isDarkMode ? AppColors.backgroundDark : AppColors.backgroundLight).withOpacity(0)],
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add),
              label: const Text('Add Savings / Tiết kiệm thêm'),
              // ✅ Đã sửa lỗi shadowColor bằng cách dùng AppStyles.primaryButtonStyle chuẩn
              style: AppStyles.primaryButtonStyle,
            ),
          ),
          const SizedBox(width: 12),
          Container(
            height: 56, width: 56,
            decoration: BoxDecoration(
                color: isDarkMode ? const Color(0xFF234833) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.1))
            ),
            child: const Icon(Icons.language),
          ),
        ],
      ),
    );
  }
}