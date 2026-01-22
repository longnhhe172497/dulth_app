import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; // Đảm bảo bạn đã thêm fl_chart vào pubspec.yaml
import '../../constants.dart';
import 'category_transaction_screen.dart';

class MonthlyReportsScreen extends StatefulWidget {
  const MonthlyReportsScreen({super.key});

  @override
  State<MonthlyReportsScreen> createState() => _MonthlyReportsScreenState();
}

class _MonthlyReportsScreenState extends State<MonthlyReportsScreen> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Báo cáo tháng / 월간 보고서',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.share_outlined, color: AppColors.primary),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // --- 1. CHỌN THÁNG (MONTH PICKER) ---
            _buildMonthSelector(isDarkMode),

            // --- 2. BIỂU ĐỒ TRÒN TỔNG QUAN (PIE CHART) ---
            _buildChartSection(isDarkMode),

            // --- 3. CHI TIẾT THEO HẠNG MỤC (CATEGORY BREAKDOWN) ---
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader('Phân bổ chi tiêu / 지출 분포'),
                  const SizedBox(height: 16),
                  _buildCategoryReportItem(
                      context,
                      Icons.restaurant, 'Ăn uống / 식비',
                      '16.020.000 ₫', '45%', AppColors.primary, isDarkMode
                  ),
                  _buildCategoryReportItem(
                      context,
                      Icons.computer, 'Thiết bị IT / IT 장비',
                      '8.500.000 ₫', '25%', Colors.blue, isDarkMode
                  ),
                  _buildCategoryReportItem(
                      context,
                      Icons.school, 'Học tập (Tiếng Hàn) / 한국어 공부',
                      '3.200.000 ₫', '15%', Colors.orange, isDarkMode
                  ),
                  _buildCategoryReportItem(
                      context,
                      Icons.more_horiz, 'Khác / 기타',
                      '2.100.000 ₫', '15%', Colors.grey, isDarkMode
                  ),
                ],
              ),
            ),

            const SizedBox(height: 100), // Khoảng trống cho Bottom Nav
          ],
        ),
      ),
    );
  }

  // --- CÁC THÀNH PHẦN WIDGET CHI TIẾT ---

  Widget _buildMonthSelector(bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.chevron_left, color: isDarkMode ? Colors.white54 : Colors.black54),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              'Tháng 10, 2023',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Icon(Icons.chevron_right, color: isDarkMode ? Colors.white54 : Colors.black54),
        ],
      ),
    );
  }

  Widget _buildChartSection(bool isDarkMode) {
    return SizedBox(
      height: 280,
      child: Stack(
        alignment: Alignment.center,
        children: [
          PieChart(
            PieChartData(
              pieTouchData: PieTouchData(
                touchCallback: (FlTouchEvent event, pieTouchResponse) {
                  setState(() {
                    if (!event.isInterestedForInteractions ||
                        pieTouchResponse == null ||
                        pieTouchResponse.touchedSection == null) {
                      touchedIndex = -1;
                      return;
                    }
                    touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                  });
                },
              ),
              borderData: FlBorderData(show: false),
              sectionsSpace: 4,
              centerSpaceRadius: 70,
              sections: _showingSections(),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Tổng chi',
                style: TextStyle(color: isDarkMode ? Colors.white54 : Colors.black54, fontSize: 14),
              ),
              const Text(
                '29.820.000 ₫',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _showingSections() {
    return List.generate(4, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 20.0 : 16.0;
      final radius = isTouched ? 30.0 : 20.0;

      switch (i) {
        case 0:
          return PieChartSectionData(
            color: AppColors.primary, value: 45, title: '', radius: radius,
          );
        case 1:
          return PieChartSectionData(
            color: Colors.blue, value: 25, title: '', radius: radius,
          );
        case 2:
          return PieChartSectionData(
            color: Colors.orange, value: 15, title: '', radius: radius,
          );
        case 3:
          return PieChartSectionData(
            color: Colors.grey, value: 15, title: '', radius: radius,
          );
        default:
          throw Error();
      }
    });
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildCategoryReportItem(
      BuildContext context, IconData icon, String title,
      String amount, String percent, Color color, bool isDarkMode
      ) {
    return InkWell(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CategoryTransactionScreen())
      ),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDarkMode ? AppColors.cardDark : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isDarkMode ? Colors.white10 : Colors.grey[200]!),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  Text(percent, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ),
            Text(amount, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
          ],
        ),
      ),
    );
  }
}