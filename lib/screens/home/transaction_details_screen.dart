import 'dart:ui';
import 'package:flutter/material.dart';
import '../../constants.dart';

class TransactionDetailsScreen extends StatelessWidget {
  const TransactionDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme
        .of(context)
        .brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? AppColors.backgroundDark : AppColors
          .backgroundLight,
      body: Stack(
        children: [
          // --- 1. NỘI DUNG CHÍNH (CUỘN ĐƯỢC) ---
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  const SizedBox(height: 100),
                  // Khoảng trống cho Sticky Top Bar

                  // Header hiển thị số tiền và hạng mục
                  _buildAmountHeader(isDarkMode),

                  // Phần Thông tin (Information)
                  _buildSectionLabel(
                      'Information / thông tin / 정보', isDarkMode),
                  _buildInfoCard(isDarkMode),

                  // Phần Ghi chú (Notes)
                  _buildSectionLabel('Notes / Ghi chú / 메모', isDarkMode),
                  _buildNotesCard(isDarkMode),

                  // Phần Hóa đơn (Receipt)
                  _buildSectionLabel('Receipt / Hóa đơn / 영수증', isDarkMode),
                  _buildReceiptCard(isDarkMode),

                  // Nút Xóa giao dịch
                  const SizedBox(height: 32),
                  _buildDeleteButton(),

                  const SizedBox(height: 120),
                  // Khoảng trống cho Bottom Nav
                ],
              ),
            ),
          ),

          // --- 2. THANH ĐIỀU HƯỚNG TRÊN CÙNG (STICKY TOP BAR) ---
          Positioned(top: 0,
              left: 0,
              right: 0,
              child: _buildTopBar(isDarkMode, context)),
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
          color: (isDarkMode ? AppColors.backgroundDark : AppColors
              .backgroundLight).withValues(alpha: 0.8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back_ios,
                    color: isDarkMode ? Colors.white : Colors.black, size: 20),
                onPressed: () => Navigator.pop(context),
              ),
              const Text('Transaction Details',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              TextButton(
                onPressed: () {}, // Chuyển sang màn hình chỉnh sửa
                child: const Text('Edit', style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAmountHeader(bool isDarkMode) {
    return Column(
      children: [
        Container(
          width: 64, height: 64,
          decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.2),
              shape: BoxShape.circle),
          child: const Icon(
              Icons.restaurant, color: AppColors.primary, size: 36),
        ),
        const SizedBox(height: 16),
        const Text('- 500.000 VND',
            style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        const Text(
          'Food & Beverage | Ẩm thực | 식비',
          style: TextStyle(color: AppColors.primary,
              fontWeight: FontWeight.bold,
              fontSize: 14),
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildSectionLabel(String label, bool isDarkMode) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(4, 16, 4, 8),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
            color: isDarkMode ? AppColors.textMint : Colors.grey,
            fontSize: 11,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2
        ),
      ),
    );
  }

  Widget _buildInfoCard(bool isDarkMode) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDarkMode
            ? AppColors.borderColor.withValues(alpha: 0.2)
            : Colors.grey[200]!),
      ),
      child: Column(
        children: [
          _buildInfoRow('Date & Time', 'Oct 24, 2023 • 12:45 PM', isDarkMode),
          _buildInfoRow('Payment Method', 'Techcombank (VND)', isDarkMode,
              icon: Icons.account_balance_wallet),
          _buildInfoRow(
              'Status', 'CLEARED', isDarkMode, isStatus: true, isLast: true),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, bool isDarkMode,
      {IconData? icon, bool isStatus = false, bool isLast = false}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: isLast ? null : Border(bottom: BorderSide(
            color: isDarkMode ? Colors.white.withValues(alpha: 0.05) : Colors
                .grey[100]!)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
          Row(
            children: [
              if (icon != null) ...[
                Icon(icon, color: AppColors.primary, size: 16),
                const SizedBox(width: 8)
              ],
              if (isStatus)
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(4)),
                  child: Text(value, style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 11,
                      fontWeight: FontWeight.bold)),
                )
              else
                Text(value, style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 14)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNotesCard(bool isDarkMode) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDarkMode
            ? AppColors.borderColor.withValues(alpha: 0.2)
            : Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Lunch with the team at the new Korean BBQ place. Tried the marinated beef.',
            style: TextStyle(fontSize: 14,
                color: isDarkMode ? Colors.white : Colors.black87,
                height: 1.5),
          ),
          const SizedBox(height: 8),
          const Text(
            '팀원들과 점심 식사. 새로 생긴 한국 고깃집. (Bữa trưa cùng đội ngũ)',
            style: TextStyle(fontSize: 12,
                color: AppColors.textMint,
                fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }

  Widget _buildReceiptCard(bool isDarkMode) {
    return Container(
      width: double.infinity,
      height: 220,
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.cardDark : Colors.grey[200],
        borderRadius: BorderRadius.circular(16),
        image: const DecorationImage(
          image: NetworkImage(
              'https://images.unsplash.com/photo-1556742049-13da7336b719?q=80&w=500'),
          fit: BoxFit.cover,
          opacity: 0.5,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.8),
                      Colors.transparent
                    ]
                ),
                borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(16)),
              ),
              child: Row(
                children: const [
                  Icon(Icons.zoom_in, color: Colors.white, size: 20),
                  SizedBox(width: 8),
                  Text('Tap to view full image', style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeleteButton() {
    return SizedBox(
      width: double.infinity,
      child: TextButton.icon(
        onPressed: () {}, // Thực hiện xóa giao dịch
        icon: const Icon(Icons.delete, color: Colors.red),
        label: const Text('Delete Transaction',
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
        style: TextButton.styleFrom(
          backgroundColor: Colors.red.withValues(alpha: 0.1),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16)),
          elevation: 0,
        ),
      ),
    );
  }
}