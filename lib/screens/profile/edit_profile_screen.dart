import 'package:flutter/material.dart';
import '../../constants.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  String _selectedLanguage = 'Vietnamese';

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
              Icons.arrow_back_ios_new,
              color: isDarkMode ? Colors.white : Colors.black,
              size: 20
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
            'Edit Profile',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // --- 1. NỘI DUNG CHÍNH (CUỘN ĐƯỢC) ---
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 120),
            child: Column(
              children: [
                // Phần ảnh đại diện và nút đổi ảnh
                _buildPhotoSection(isDarkMode),

                // Các trường nhập liệu (Form Fields)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel('Full Name / 성명 / Họ và tên', isDarkMode),
                      _buildTextField(initialValue: 'Nguyen Kim', isDarkMode: isDarkMode),
                      const SizedBox(height: 20),

                      _buildLabel('Email', isDarkMode),
                      _buildTextField(
                        initialValue: 'kim.nguyen@finance.app',
                        isDarkMode: isDarkMode,
                        suffixIcon: Icons.mail,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 20),

                      _buildLabel('Phone / 전화번호 / Số điện thoại', isDarkMode),
                      _buildPhoneField(isDarkMode),
                      const SizedBox(height: 32),

                      // Tùy chọn ngôn ngữ yêu thích (Dành cho người học tiếng Hàn)
                      _buildLabel('Preferred Language / Ngôn ngữ / 언어', isDarkMode, isUppercase: true),
                      const SizedBox(height: 8),
                      _buildLanguageSelector(isDarkMode),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // --- 2. NÚT LƯU THAY ĐỔI CỐ ĐỊNH (FIXED BOTTOM BUTTON) ---
          _buildBottomSaveButton(isDarkMode),
        ],
      ),
    );
  }

  // --- CÁC THÀNH PHẦN WIDGET CHI TIẾT ---

  Widget _buildPhotoSection(bool isDarkMode) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: 128, height: 128,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white.withOpacity(0.1), width: 4),
                  image: const DecorationImage(
                    image: NetworkImage('https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?q=80&w=200'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                bottom: 0, right: 0,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    border: Border.all(color: isDarkMode ? AppColors.backgroundDark : AppColors.backgroundLight, width: 4),
                  ),
                  child: const Icon(Icons.photo_camera, size: 20, color: Colors.black),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text('Change Photo', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Text(
              'Lưu thay đổi / 변경 사항 저장',
              style: TextStyle(color: isDarkMode ? AppColors.textMint : Colors.grey[600], fontSize: 14)
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text, bool isDarkMode, {bool isUppercase = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4),
      child: Text(
        isUppercase ? text.toUpperCase() : text,
        style: TextStyle(
          color: isDarkMode ? Colors.white70 : Colors.black87,
          fontSize: isUppercase ? 11 : 14,
          fontWeight: isUppercase ? FontWeight.bold : FontWeight.w500,
          letterSpacing: isUppercase ? 1.2 : null,
        ),
      ),
    );
  }

  Widget _buildTextField({required String initialValue, required bool isDarkMode, IconData? suffixIcon, TextInputType? keyboardType}) {
    return TextFormField(
      initialValue: initialValue,
      keyboardType: keyboardType,
      style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
      decoration: InputDecoration(
        filled: true,
        fillColor: isDarkMode ? AppColors.inputBgDark : Colors.white,
        suffixIcon: suffixIcon != null ? Icon(suffixIcon, color: AppColors.textMint) : null,
        contentPadding: const EdgeInsets.all(16),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: isDarkMode ? AppColors.borderColor : Colors.grey[200]!)
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: AppColors.primary, width: 2)
        ),
      ),
    );
  }

  Widget _buildPhoneField(bool isDarkMode) {
    return Row(
      children: [
        Container(
          height: 56, padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: isDarkMode ? const Color(0xFF132B1D) : Colors.grey[100],
            borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
            border: Border.all(color: isDarkMode ? AppColors.borderColor : Colors.grey[200]!),
          ),
          alignment: Alignment.center,
          child: const Text('+84', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        ),
        Expanded(
          child: TextFormField(
            initialValue: '912 345 678',
            keyboardType: TextInputType.phone,
            style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
            decoration: InputDecoration(
              filled: true,
              fillColor: isDarkMode ? AppColors.inputBgDark : Colors.white,
              contentPadding: const EdgeInsets.all(16),
              border: OutlineInputBorder(
                  borderRadius: const BorderRadius.horizontal(right: Radius.circular(16)),
                  borderSide: BorderSide(color: isDarkMode ? AppColors.borderColor : Colors.grey[200]!)
              ),
              focusedBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.horizontal(right: Radius.circular(16)),
                  borderSide: const BorderSide(color: AppColors.primary, width: 2)
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLanguageSelector(bool isDarkMode) {
    final langs = ['Vietnamese', 'Korean', 'English'];
    return Row(
      children: langs.map((lang) {
        bool isSelected = _selectedLanguage == lang;
        return Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _selectedLanguage = lang),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color: isSelected ? AppColors.primary : (isDarkMode ? AppColors.borderColor : Colors.grey[200]!),
                    width: 2
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                  lang,
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? (isDarkMode ? Colors.white : Colors.black) : Colors.grey
                  )
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBottomSaveButton(bool isDarkMode) {
    return Positioned(
      bottom: 0, left: 0, right: 0,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity, height: 56,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.save),
                label: const Text('Save Changes'),
                // ✅ ĐÃ SỬA LỖI: Sử dụng AppStyles.primaryButtonStyle chuẩn để bọc shadowColor
                style: AppStyles.primaryButtonStyle,
              ),
            ),
            const SizedBox(height: 12),
            // Theo yêu cầu, sử dụng từ "고민" cho các nỗi lo/quan tâm tài chính nếu có ghi chú
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Lưu thay đổi', style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
                Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: CircleAvatar(radius: 1, backgroundColor: Colors.grey)),
                Text('변경 사항 저장', style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}