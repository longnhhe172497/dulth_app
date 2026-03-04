import 'dart:ui';
import 'package:flutter/material.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  String _selectedFrequency = 'monthly';
  final Color primaryColor = const Color(0xFF13EC6D);
  final Color backgroundDark = const Color(0xFF102218);
  final Color backgroundLight = const Color(0xFFF6F8F7);

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? backgroundDark : backgroundLight,
      body: Stack(
        children: [
          // Nội dung chính
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 100), // Khoảng trống cho Top Bar

                // 1. Amount Entry Section
                _buildAmountSection(isDarkMode),

                // 2. Frequency Selection
                _buildSectionLabel('Frequency / Tần suất / 빈도'),
                _buildFrequencySelector(isDarkMode),

                const SizedBox(height: 32),

                // 3. Start Date & Category Info Rows
                _buildInfoRow(Icons.calendar_today, 'Start Date / Ngày bắt đầu / 시작일', 'Next Monday, Oct 14', isDarkMode),
                const SizedBox(height: 16),
                _buildInfoRow(Icons.category, 'Category / Danh mục / 카테고리', 'Rent & Utilities', isDarkMode),

                const SizedBox(height: 32),

                // 4. Quick Select Grid
                _buildQuickSelectHeader(),
                _buildQuickSelectGrid(isDarkMode),

                const SizedBox(height: 32),

                // 5. Memo Input
                _buildSectionLabel('Memo / Ghi chú / 메모'),
                _buildMemoInput(isDarkMode),

                const SizedBox(height: 120), // Khoảng trống cho Footer
              ],
            ),
          ),

          // Top Navigation Bar (Sticky with Blur)
          Positioned(top: 0, left: 0, right: 0, child: _buildTopBar(isDarkMode, context)),

          // Fixed Footer Action Button
          Positioned(bottom: 0, left: 0, right: 0, child: _buildFooterButton(isDarkMode)),
        ],
      ),
    );
  }

  // --- WIDGET COMPONENTS ---

  Widget _buildTopBar(bool isDarkMode, BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 48, 16, 12),
          color: (isDarkMode ? backgroundDark : backgroundLight).withOpacity(0.8),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                onPressed: () => Navigator.pop(context),
              ),
              const Expanded(
                child: Text(
                  'Schedule / Lên lịch / 예약',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const Text('Help', style: TextStyle(color: Color(0xFF13EC6D), fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAmountSection(bool isDarkMode) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Column(
        children: [
          Text('Amount / Số tiền / 금액'.toUpperCase(), style: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
          const SizedBox(height: 8),
          Text('₩ 50,000', style: TextStyle(color: primaryColor, fontSize: 48, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.swap_horiz, size: 16),
            label: const Text('Switch to 950.000 ₫', style: TextStyle(decoration: TextDecoration.underline)),
            style: ElevatedButton.styleFrom(
              backgroundColor: isDarkMode ? Colors.white10 : Colors.black.withOpacity(0.05),
              foregroundColor: isDarkMode ? Colors.white : Colors.black,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Text(label.toUpperCase(), style: const TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1)),
    );
  }

  Widget _buildFrequencySelector(bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(color: isDarkMode ? Colors.white10 : Colors.black.withOpacity(0.05), borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          _buildFreqTab('Daily', 'Hàng ngày / 매일', _selectedFrequency == 'daily', isDarkMode, () => setState(() => _selectedFrequency = 'daily')),
          _buildFreqTab('Weekly', 'Hàng tuần / 매주', _selectedFrequency == 'weekly', isDarkMode, () => setState(() => _selectedFrequency = 'weekly')),
          _buildFreqTab('Monthly', 'Hàng tháng / 매월', _selectedFrequency == 'monthly', isDarkMode, () => setState(() => _selectedFrequency = 'monthly')),
        ],
      ),
    );
  }

  Widget _buildFreqTab(String label, String sub, bool isActive, bool isDarkMode, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isActive ? (isDarkMode ? backgroundDark : Colors.white) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isActive ? [const BoxShadow(color: Colors.black12, blurRadius: 4)] : [],
          ),
          child: Column(
            children: [
              Text(label, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: isActive ? primaryColor : Colors.grey)),
              Text(sub, style: TextStyle(fontSize: 9, color: isActive ? primaryColor.withOpacity(0.7) : Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: primaryColor.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: primaryColor, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(color: Colors.grey, fontSize: 10)),
                Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildQuickSelectHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildSectionLabel('Quick Select'),
        const Padding(
          padding: EdgeInsets.only(bottom: 12),
          child: Text('View all', style: TextStyle(color: Color(0xFF13EC6D), fontSize: 12, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Widget _buildQuickSelectGrid(bool isDarkMode) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildCategoryIcon(Icons.home, 'Rent', true, isDarkMode),
        _buildCategoryIcon(Icons.shopping_cart, 'Grocery', false, isDarkMode),
        _buildCategoryIcon(Icons.electric_bolt, 'Bills', false, isDarkMode),
        _buildCategoryIcon(Icons.restaurant, 'Dining', false, isDarkMode),
      ],
    );
  }

  Widget _buildCategoryIcon(IconData icon, String label, bool isSelected, bool isDarkMode) {
    return Column(
      children: [
        Container(
          width: 56, height: 56,
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.white10 : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: isSelected ? primaryColor : Colors.transparent, width: 2),
          ),
          child: Icon(icon, color: isSelected ? primaryColor : Colors.grey),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Colors.grey)),
      ],
    );
  }

  Widget _buildMemoInput(bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const TextField(
        decoration: InputDecoration(
          hintText: 'Add a note (Optional)...',
          border: InputBorder.none,
          hintStyle: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildFooterButton(bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 40),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter, end: Alignment.topCenter,
          colors: [isDarkMode ? backgroundDark : backgroundLight, (isDarkMode ? backgroundDark : backgroundLight).withOpacity(0)],
        ),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 64,
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            elevation: 8,
            shadowColor: primaryColor.withOpacity(0.4),
          ),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Confirm Schedule', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
              Text('Xác nhận lịch • 일정 확인', style: TextStyle(color: Colors.black54, fontSize: 11, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}