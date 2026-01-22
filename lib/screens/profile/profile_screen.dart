import 'package:flutter/material.dart';
import '../../constants.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Hồ sơ / 프로필',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings, color: AppColors.primary),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 24),

            // --- 1. PHẦN ĐẦU TRANG (USER HEADER) ---
            _buildUserHeader(isDarkMode),

            const SizedBox(height: 32),

            // --- 2. CÁC TÙY CHỌN TÀI KHOẢN (ACCOUNT OPTIONS) ---
            _buildSectionLabel('Tài khoản / 계정', isDarkMode),
            _buildSettingTile(
              icon: Icons.person_outline,
              title: 'Chỉnh sửa hồ sơ / 프로필 수정',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const EditProfileScreen()),
              ),
              isDarkMode: isDarkMode,
            ),
            _buildSettingTile(
              icon: Icons.language,
              title: 'Cài đặt ngôn ngữ / 언어 설정',
              subtitle: 'Tiếng Việt | 한국어',
              isDarkMode: isDarkMode,
            ),

            const SizedBox(height: 24),

            // --- 3. TIỆN ÍCH & TƯ VẤN (UTILITIES) ---
            _buildSectionLabel('Tiện ích / 유틸리티', isDarkMode),
            _buildSettingTile(
              icon: Icons.lightbulb_outline,
              title: 'Nỗi lo tài chính / tài chính 고민', // Sử dụng "고민" theo yêu cầu
              isDarkMode: isDarkMode,
            ),
            _buildSettingTile(
              icon: Icons.dark_mode_outlined,
              title: 'Chế độ tối / 다크 모드',
              trailing: Switch.adaptive(
                value: isDarkMode,
                onChanged: (val) {},
                activeColor: AppColors.primary,
              ),
              isDarkMode: isDarkMode,
            ),

            const SizedBox(height: 32),

            // --- 4. NÚT ĐĂNG XUẤT (LOGOUT BUTTON) ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.logout),
                  label: const Text('Đăng xuất / 로그아웃'),
                  // ✅ Đã sửa lỗi shadowColor bằng cách dùng style chuẩn từ constants
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.withOpacity(0.1),
                    foregroundColor: Colors.red,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 48),
            const Text(
              'FinanceFlow v1.0.24',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 100), // Khoảng trống cho Bottom Nav
          ],
        ),
      ),
    );
  }

  // --- CÁC THÀNH PHẦN WIDGET CHI TIẾT ---

  Widget _buildUserHeader(bool isDarkMode) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              width: 100, height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primary, width: 2),
                image: const DecorationImage(
                  image: NetworkImage('https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?q=80&w=100'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              bottom: 0, right: 0,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                child: const Icon(Icons.camera_alt, size: 16, color: Colors.black),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Text(
          'Nguyen Kim',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          'IT Student | Sinh viên IT', // Cá nhân hóa ngành học
          style: TextStyle(color: isDarkMode ? AppColors.textMint : Colors.grey[600], fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildSectionLabel(String label, bool isDarkMode) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          color: isDarkMode ? AppColors.textMint : Colors.grey,
          fontSize: 11,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
    required bool isDarkMode,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isDarkMode ? AppColors.cardDark : Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: AppColors.primary, size: 20),
      ),
      title: Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
      subtitle: subtitle != null ? Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)) : null,
      trailing: trailing ?? const Icon(Icons.chevron_right, size: 20, color: Colors.grey),
    );
  }
}