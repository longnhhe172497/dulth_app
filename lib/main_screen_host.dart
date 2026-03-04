import 'package:flutter/material.dart';
import 'constants.dart';
// Import các màn hình chính để liên kết tab
import 'screens/home/home_dashboard_screen.dart';
import 'screens/calendar/calendar_screen.dart';
import 'screens/reports/monthly_reports_screen.dart';
import 'screens/profile/profile_screen.dart';
// Import Bottom Sheet thêm giao dịch
import 'widgets/add_transaction_bottom_sheet.dart';

class MainScreenHost extends StatefulWidget {
  const MainScreenHost({super.key});

  @override
  State<MainScreenHost> createState() => _MainScreenHostState();
}

class _MainScreenHostState extends State<MainScreenHost> {
  // Chỉ số tab hiện tại
  int _currentIndex = 0;

  // Danh sách các màn hình tương ứng với từng tab
  final List<Widget> _screens = [
    const HomeDashboardScreen(),
    const TransactionCalendarScreen(),
    const MonthlyReportsScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      // Sử dụng IndexedStack để giữ nguyên trạng thái (cuộn, dữ liệu) khi chuyển tab
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),

      // --- NÚT THÊM GIAO DỊCH (FAB) ---
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTransactionBottomSheet(context),
        backgroundColor: AppColors.primary,
        // ✅ ĐÃ SỬA LỖI: Xóa shadowColor ở đây để tránh lỗi gạch đỏ như bạn gặp phải
        elevation: 8,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: AppColors.backgroundDark, size: 32),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // --- THANH ĐIỀU HƯỚNG DƯỚI CÙNG (BOTTOM NAV) ---
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        color: isDarkMode ? const Color(0xFF112218) : Colors.white,
        child: Container(
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Tab: Trang chủ
              _buildTabItem(0, Icons.home_filled, 'Home', '홈'),
              // Tab: Lịch
              _buildTabItem(1, Icons.calendar_month, 'Calendar', '달력'),

              const SizedBox(width: 48), // Khoảng trống dành cho nút FAB ở giữa

              // Tab: Báo cáo
              _buildTabItem(2, Icons.analytics, 'Reports', '보고서'),
              // Tab: Hồ sơ
              _buildTabItem(3, Icons.person, 'Profile', '프로필'),
            ],
          ),
        ),
      ),
    );
  }

  // --- WIDGET COMPONENTS ---

  /// Hàm xây dựng từng mục Tab với nhãn song ngữ Việt - Hàn
  Widget _buildTabItem(int index, IconData icon, String label, String krLabel) {
    bool isActive = _currentIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _currentIndex = index),
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isActive ? AppColors.primary : Colors.grey,
              size: 26,
            ),
            const SizedBox(height: 4),
            Text(
              isActive ? label : krLabel,
              style: TextStyle(
                color: isActive ? AppColors.primary : Colors.grey,
                fontSize: 10,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Hàm mở Bottom Sheet để thêm giao dịch mới
  void _showAddTransactionBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Cho phép sheet chiếm toàn màn hình nếu cần
      backgroundColor: Colors.transparent,
      builder: (context) => const AddTransactionBottomSheet(),
    );
  }
}