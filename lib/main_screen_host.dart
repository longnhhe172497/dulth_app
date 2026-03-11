import 'package:flutter/material.dart';
import 'constants.dart';

// Localization
import '../../l10n/app_localizations.dart';

// Import các màn hình
import 'screens/home/home_dashboard_screen.dart';
import 'screens/calendar/calendar_screen.dart';
import 'screens/reports/monthly_reports_screen.dart';
import 'screens/profile/profile_screen.dart';

// Import BottomSheet
import 'widgets/add_transaction_bottom_sheet.dart';

class MainScreenHost extends StatefulWidget {
  const MainScreenHost({super.key});

  @override
  State<MainScreenHost> createState() => _MainScreenHostState();
}

class _MainScreenHostState extends State<MainScreenHost> {

  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeDashboardScreen(),
    const TransactionCalendarScreen(),
    const MonthlyReportsScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {

    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final lang = AppLocalizations.of(context)!;

    return Scaffold(

      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),

      // FAB
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTransactionBottomSheet(context),
        backgroundColor: AppColors.primary,
        elevation: 8,
        shape: const CircleBorder(),
        child: const Icon(
          Icons.add,
          color: AppColors.backgroundDark,
          size: 32,
        ),
      ),

      floatingActionButtonLocation:
      FloatingActionButtonLocation.centerDocked,

      // Bottom Navigation
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

              _buildTabItem(
                0,
                Icons.home_filled,
                lang.home,
              ),

              _buildTabItem(
                1,
                Icons.calendar_month,
                lang.calendar,
              ),

              const SizedBox(width: 48),

              _buildTabItem(
                2,
                Icons.analytics,
                lang.reports,
              ),

              _buildTabItem(
                3,
                Icons.person,
                lang.profile,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Tab Item
  Widget _buildTabItem(int index, IconData icon, String label) {

    bool isActive = _currentIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _currentIndex = index;
          });
        },
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
              label,
              style: TextStyle(
                color: isActive ? AppColors.primary : Colors.grey,
                fontSize: 11,
                fontWeight:
                isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // BottomSheet thêm giao dịch
  void _showAddTransactionBottomSheet(BuildContext context) {

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return const AddTransactionBottomSheet();
      },
    );
  }
}