import 'package:flutter/material.dart';
import '../../constants.dart';

class ScheduleFutureTransactionScreen extends StatefulWidget {
  const ScheduleFutureTransactionScreen({super.key});

  @override
  State<ScheduleFutureTransactionScreen> createState() => _ScheduleFutureTransactionScreenState();
}

class _ScheduleFutureTransactionScreenState extends State<ScheduleFutureTransactionScreen> {
  // Trạng thái cho các thành phần UI
  bool _isRecurring = true;
  String _selectedFrequency = 'Hàng tháng';
  String _selectedCategory = 'Ăn uống';

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: _buildAppBar(isDarkMode),
      body: Stack(
        children: [
          // --- 1. NỘI DUNG CHÍNH (CUỘN ĐƯỢC) ---
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDateSelector(isDarkMode),
                _buildAmountInput(isDarkMode),
                _buildCategorySelector(isDarkMode),
                _buildRecurringSection(isDarkMode),
                _buildNotesSection(isDarkMode),
              ],
            ),
          ),

          // --- 2. NÚT XÁC NHẬN CỐ ĐỊNH PHÍA DƯỚI (FIXED FOOTER) ---
          _buildStickyFooter(isDarkMode),
        ],
      ),
    );
  }

  // --- CÁC THÀNH PHẦN WIDGET CHI TIẾT ---

  PreferredSizeWidget _buildAppBar(bool isDarkMode) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leadingWidth: 80,
      leading: TextButton(
        onPressed: () => Navigator.pop(context),
        child: Text(
            'Hủy / Cancel',
            style: TextStyle(color: isDarkMode ? Colors.white60 : Colors.black54, fontSize: 12)
        ),
      ),
      title: const Text('Đặt lịch / Schedule', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      centerTitle: true,
      actions: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 16),
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
              color: isDarkMode ? Colors.white10 : Colors.black.withOpacity(0.05),
              borderRadius: BorderRadius.circular(4)
          ),
          child: const Text('VN | KR', style: TextStyle(fontSize: 10, color: AppColors.textMint)),
        ),
        IconButton(
          icon: Icon(Icons.settings, color: isDarkMode ? Colors.white60 : Colors.black54),
          onPressed: () {},
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(color: isDarkMode ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05), height: 1),
      ),
    );
  }

  Widget _buildDateSelector(bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
              'Ngày thực hiện / 날짜 (Date)',
              style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.2)
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDarkMode ? AppColors.cardDark : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: isDarkMode ? AppColors.borderColor.withOpacity(0.3) : Colors.grey[200]!),
              boxShadow: [if(!isDarkMode) BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Icon(Icons.chevron_left, color: Colors.grey),
                    Text('Tháng 10, 2023 / 10월 2023', style: TextStyle(fontWeight: FontWeight.bold)),
                    Icon(Icons.chevron_right, color: Colors.grey),
                  ],
                ),
                const SizedBox(height: 16),
                _buildCalendarGrid(isDarkMode),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid(bool isDarkMode) {
    return Column(
      children: [
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: ['S', 'M', 'T', 'W', 'T', 'F', 'S'].map((d) => Text(
                d,
                style: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)
            )).toList()
        ),
        const SizedBox(height: 8),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7, mainAxisSpacing: 4, crossAxisSpacing: 4
          ),
          itemCount: 14 + 3,
          itemBuilder: (context, index) {
            if (index < 3) return const SizedBox();
            int day = index - 2;
            bool isSelected = day == 5;
            return Container(
              alignment: Alignment.center,
              decoration: isSelected ? const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle) : null,
              child: Text(
                  '$day',
                  style: TextStyle(
                      color: isSelected ? Colors.black : (isDarkMode ? Colors.white : Colors.black),
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      fontSize: 14
                  )
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildAmountInput(bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
              'Số tiền / 금액 (Amount)',
              style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.2)
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
                color: isDarkMode ? AppColors.inputBgDark : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: isDarkMode ? AppColors.borderColor : Colors.grey[300]!)
            ),
            child: Row(
              children: [
                const Expanded(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                        hintText: '0',
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(16)
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                      color: isDarkMode ? Colors.white10 : Colors.grey[100],
                      border: Border(left: BorderSide(color: isDarkMode ? AppColors.borderColor : Colors.grey[300]!))
                  ),
                  child: const Text('VND', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySelector(bool isDarkMode) {
    final categories = [
      {'icon': Icons.restaurant, 'name': 'Ăn uống'},
      {'icon': Icons.home, 'name': 'Nhà cửa'},
      {'icon': Icons.shopping_bag, 'name': 'Mua sắm'},
      {'icon': Icons.receipt_long, 'name': 'Hóa đơn'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 24, 16, 12),
          child: Text(
              'Danh mục / 카테고리',
              style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.2)
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: categories.map((cat) {
              bool isSelected = _selectedCategory == cat['name'];
              return GestureDetector(
                onTap: () => setState(() => _selectedCategory = cat['name'] as String),
                child: Container(
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : (isDarkMode ? const Color(0xFF234833) : Colors.grey[200]),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(cat['icon'] as IconData, size: 20, color: isSelected ? Colors.black : (isDarkMode ? Colors.white : Colors.black54)),
                      const SizedBox(width: 8),
                      Text(
                          cat['name'] as String,
                          style: TextStyle(
                              color: isSelected ? Colors.black : (isDarkMode ? Colors.white : Colors.black54),
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal
                          )
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildRecurringSection(bool isDarkMode) {
    final frequencies = ['Hàng tháng', 'Hàng tuần', 'Hàng năm', 'Tùy chỉnh'];
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
            color: isDarkMode ? AppColors.cardDark : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: isDarkMode ? AppColors.borderColor.withOpacity(0.3) : Colors.grey[200]!)
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Định kỳ / 반복 설정 (Recurring)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      Text('Tự động lặp lại giao dịch', style: TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                  Switch.adaptive(
                    value: _isRecurring,
                    onChanged: (val) => setState(() => _isRecurring = val),
                    activeColor: AppColors.primary,
                  ),
                ],
              ),
            ),
            if (_isRecurring) ...[
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 3,
                  children: frequencies.map((freq) {
                    bool isSelected = _selectedFrequency == freq;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedFrequency = freq),
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: isSelected ? AppColors.primary : Colors.grey.withOpacity(0.3)),
                        ),
                        child: Text(
                            freq,
                            style: TextStyle(
                                color: isSelected ? AppColors.primary : Colors.grey,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                fontSize: 13
                            )
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildNotesSection(bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
              'Ghi chú / 메모 (Note)',
              style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.2)
          ),
          const SizedBox(height: 8),
          TextField(
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Nhập chi tiết giao dịch...',
              filled: true,
              fillColor: isDarkMode ? AppColors.inputBgDark : Colors.white,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: isDarkMode ? AppColors.borderColor : Colors.grey[300]!)
              ),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: isDarkMode ? AppColors.borderColor : Colors.grey[300]!)
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStickyFooter(bool isDarkMode) {
    return Positioned(
      bottom: 0, left: 0, right: 0,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 40),
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                isDarkMode ? AppColors.backgroundDark : AppColors.backgroundLight,
                (isDarkMode ? AppColors.backgroundDark : AppColors.backgroundLight).withOpacity(0)
              ]
          ),
        ),
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: () {
              // Thực hiện lên lịch và quay lại Dashboard
              Navigator.pop(context);
            },
            // ✅ ĐÃ SỬA LỖI: Sử dụng AppStyles.primaryButtonStyle chuẩn để bọc shadowColor
            style: AppStyles.primaryButtonStyle,
            child: const Text('Lên lịch giao dịch / 일정 추가'),
          ),
        ),
      ),
    );
  }
}