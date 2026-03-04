import 'package:flutter/material.dart';
import '../constants.dart';

class AddTransactionBottomSheet extends StatefulWidget {
  const AddTransactionBottomSheet({super.key});

  @override
  State<AddTransactionBottomSheet> createState() => _AddTransactionBottomSheetState();
}

class _AddTransactionBottomSheetState extends State<AddTransactionBottomSheet> {
  bool _isExpense = true;
  String _selectedCategory = 'Ăn uống';

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom, // Đẩy lên khi mở bàn phím
      ),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.backgroundDark : AppColors.backgroundLight,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- 1. THANH KÉO (DRAG HANDLE) ---
            Center(
              child: Container(
                width: 48, height: 5,
                decoration: BoxDecoration(color: Colors.grey[400], borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 24),

            // --- 2. CHUYỂN ĐỔI THU NHẬP / CHI TIÊU ---
            _buildToggleSwitch(isDarkMode),
            const SizedBox(height: 32),

            // --- 3. NHẬP SỐ TIỀN (AMOUNT INPUT) ---
            _buildLabel('Số tiền / 금액 (Amount)', isDarkMode),
            _buildAmountInput(isDarkMode),
            const SizedBox(height: 24),

            // --- 4. CHỌN DANH MỤC (CATEGORY SELECTOR) ---
            _buildLabel('Danh mục / 카테고리 (Category)', isDarkMode),
            _buildCategoryGrid(isDarkMode),
            const SizedBox(height: 24),

            // --- 5. GHI CHÚ (NOTES) ---
            _buildLabel('Ghi chú / 메모 (Notes)', isDarkMode),
            _buildNotesInput(isDarkMode),
            const SizedBox(height: 32),

            // --- 6. NÚT LƯU (SAVE BUTTON - FIXED SHADOWCOLOR) ---
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                // ✅ Sửa lỗi shadowColor bằng cách dùng AppStyles đã định nghĩa
                style: AppStyles.primaryButtonStyle,
                child: const Text('Lưu giao dịch / 저장 (Save)'),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  // --- CÁC THÀNH PHẦN WIDGET CHI TIẾT ---

  Widget _buildToggleSwitch(bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.cardDark : Colors.grey[200],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          _buildToggleButton('Chi tiêu / 지출', _isExpense, () => setState(() => _isExpense = true)),
          _buildToggleButton('Thu nhập / 수입', !_isExpense, () => setState(() => _isExpense = false)),
        ],
      ),
    );
  }

  Widget _buildToggleButton(String label, bool isActive, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isActive ? Colors.black : Colors.grey,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4),
      child: Text(
        text,
        style: TextStyle(
          color: isDarkMode ? AppColors.textMint : Colors.grey[600],
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildAmountInput(bool isDarkMode) {
    return TextField(
      keyboardType: TextInputType.number,
      autofocus: true,
      style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
      decoration: InputDecoration(
        hintText: '0',
        suffixText: 'VND',
        suffixStyle: const TextStyle(color: AppColors.primary, fontSize: 18, fontWeight: FontWeight.bold),
        filled: true,
        fillColor: isDarkMode ? AppColors.inputBgDark : Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.primary, width: 2)),
      ),
    );
  }

  Widget _buildCategoryGrid(bool isDarkMode) {
    final categories = [
      {'icon': Icons.restaurant, 'name': 'Ăn uống'},
      {'icon': Icons.shopping_bag, 'name': 'Mua sắm'},
      {'icon': Icons.directions_bus, 'name': 'Di chuyển'},
      {'icon': Icons.computer, 'name': 'Thiết bị IT'},
    ];

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: categories.map((cat) {
        bool isSelected = _selectedCategory == cat['name'];
        return GestureDetector(
          onTap: () => setState(() => _selectedCategory = cat['name'] as String),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary.withOpacity(0.15) : (isDarkMode ? AppColors.cardDark : Colors.white),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: isSelected ? AppColors.primary : (isDarkMode ? Colors.white10 : Colors.grey[300]!)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(cat['icon'] as IconData, size: 18, color: isSelected ? AppColors.primary : Colors.grey),
                const SizedBox(width: 8),
                Text(cat['name'] as String, style: TextStyle(color: isSelected ? AppColors.primary : Colors.grey, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildNotesInput(bool isDarkMode) {
    return TextField(
      maxLines: 2,
      decoration: InputDecoration(
        hintText: 'Thêm nỗi lo tài chính / tài chính 고민 추가...', // Sử dụng 고민 theo yêu cầu
        filled: true,
        fillColor: isDarkMode ? AppColors.inputBgDark : Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
      ),
    );
  }
}