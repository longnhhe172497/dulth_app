import 'dart:ui';
import 'package:flutter/material.dart';
import '../../constants.dart';
import 'schedule_future_transaction_screen.dart';
import 'transaction_details_screen.dart';

class HomeDashboardScreen extends StatelessWidget {
  const HomeDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: Stack(
        children: [
          // --- 1. NỘI DUNG CHÍNH (CUỘN ĐƯỢC) ---
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              const SliverToBoxAdapter(child: SizedBox(height: 100)),

              // Thẻ số dư chính (Balance Card)
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverToBoxAdapter(child: _buildBalanceCard(context, isDarkMode)),
              ),

              // Lưới thống kê & Quản lý nỗi lo tài chính
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverToBoxAdapter(child: _buildStatsAndAdvice(isDarkMode)),
              ),

              // Tiêu đề danh sách giao dịch
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverToBoxAdapter(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Giao dịch gần đây / 최근 거래',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text('Tất cả', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
              ),

              // Danh sách giao dịch mẫu (Dựa trên thói quen của sinh viên IT)
              SliverList(
                delegate: SliverChildListDelegate([
                  _buildTransactionItem(context, Icons.coffee, Colors.brown, 'Starbucks Coffee', 'Hôm nay • Ăn uống', '- ₫ 65.000', '- ₩ 3,500', isDarkMode),
                  _buildTransactionItem(context, Icons.computer, Colors.indigo, 'AWS Cloud Service', 'Hôm qua • Công việc IT', '- ₫ 250.000', '- ₩ 13,500', isDarkMode),
                  _buildTransactionItem(context, Icons.payments, AppColors.primary, 'Lương thực tập IT / IT 인턴 급여', '24 Oct • Thu nhập', '+ ₫ 5.500.000', '+ ₩ 296,000', isDarkMode, isIncome: true),
                  _buildTransactionItem(context, Icons.shopping_bag, Colors.orange, 'Lotteria / 롯데리아', '23 Oct • Ăn uống', '- ₫ 125.000', '- ₩ 6,800', isDarkMode),
                  const SizedBox(height: 120),
                ]),
              ),
            ],
          ),

          // --- 2. THANH ĐIỀU HƯỚNG TRÊN CÙNG (STICKY TOP BAR) ---
          Positioned(top: 0, left: 0, right: 0, child: _buildTopBar(isDarkMode)),
        ],
      ),
    );
  }

  // --- CÁC THÀNH PHẦN WIDGET CHI TIẾT ---

  Widget _buildTopBar(bool isDarkMode) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 48, 16, 12),
          color: (isDarkMode ? AppColors.backgroundDark : AppColors.backgroundLight).withValues(alpha: 0.8),
          child: Row(
            children: [
              const CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage('https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?q=80&w=100'),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Xin chào / 안녕하세요', style: TextStyle(fontSize: 11, color: AppColors.textMint, fontWeight: FontWeight.bold)),
                    Text('Nguyen Kim', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              _buildRoundIcon(Icons.translate, isDarkMode),
              const SizedBox(width: 10),
              _buildRoundIcon(Icons.notifications, isDarkMode, hasBadge: true),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBalanceCard(BuildContext context, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft, end: Alignment.bottomRight,
          colors: [AppColors.cardDark, Color(0xFF112218)],
        ),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('TỔNG SỐ DƯ / 총 잔액', style: TextStyle(color: AppColors.textMint, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
          const SizedBox(height: 8),
          const Text('₫ 150.000.000', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
          const Text('₩ 8,125,000', style: TextStyle(color: AppColors.textMint, fontSize: 18, fontWeight: FontWeight.w500)),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ScheduleFutureTransactionScreen())),
                  icon: const Icon(Icons.account_balance_wallet, size: 16),
                  label: const Text('Top up'),
                  // ✅ Sử dụng style chuẩn từ constants để tránh lỗi shadowColor
                  style: AppStyles.primaryButtonStyle,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.send, size: 16),
                  label: const Text('Send'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withValues(alpha: 0.1),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsAndAdvice(bool isDarkMode) {
    return Column(
      children: [
        Row(
          children: [
            _buildStatCard('Income / 수입', '₫ 12.5M', Icons.arrow_downward, AppColors.primary, isDarkMode),
            const SizedBox(width: 16),
            _buildStatCard('Expenses / 지출', '₫ 8.2M', Icons.arrow_upward, Colors.orange, isDarkMode),
          ],
        ),
        const SizedBox(height: 16),
        // Phần tư vấn tài chính (Sử dụng từ "고민" theo yêu cầu của bạn)
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
          ),
          child: Row(
            children: [
              const Icon(Icons.lightbulb_outline, color: AppColors.primary),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Giải quyết nỗi lo tài chính / tài chính 고민 해결',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                ),
              ),
              Icon(Icons.chevron_right, color: AppColors.primary.withValues(alpha: 0.5)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String label, String amount, IconData icon, Color color, bool isDarkMode) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDarkMode ? AppColors.cardDark : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [Icon(icon, size: 14, color: color), const SizedBox(width: 6), Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold))]),
            const SizedBox(height: 8),
            Text(amount, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionItem(BuildContext context, IconData icon, Color color, String title, String sub, String val, String subVal, bool isDarkMode, {bool isIncome = false}) {
    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const TransactionDetailsScreen())),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(border: Border(bottom: BorderSide(color: isDarkMode ? Colors.white10 : Colors.black12))),
        child: Row(
          children: [
            Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: color, size: 22)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  Text(sub, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(val, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: isIncome ? AppColors.primary : (isDarkMode ? Colors.white : Colors.black))),
                Text(subVal, style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoundIcon(IconData icon, bool isDarkMode, {bool hasBadge = false}) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: isDarkMode ? AppColors.cardDark : Colors.grey[200], shape: BoxShape.circle),
          child: Icon(icon, size: 20, color: isDarkMode ? Colors.white : Colors.black),
        ),
        if (hasBadge)
          Positioned(right: 8, top: 8, child: Container(width: 8, height: 8, decoration: BoxDecoration(color: AppColors.primary, shape: BoxShape.circle, border: Border.all(color: isDarkMode ? AppColors.cardDark : Colors.white, width: 1.5)))),
      ],
    );
  }
}
