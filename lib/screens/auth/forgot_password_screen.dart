import 'package:flutter/material.dart';
import '../../constants.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

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
              Icons.chevron_left,
              color: isDarkMode ? Colors.white : Colors.black,
              size: 32
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
            'Forgot Password',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Language Switcher (EN/VN/KR)
                    _buildLanguageSwitcher(isDarkMode),

                    // 2. Illustration Section
                    Center(
                      child: Container(
                        width: 96,
                        height: 96,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                            Icons.lock_reset,
                            color: AppColors.primary,
                            size: 48
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // 3. Headline Content
                    const Text(
                      'Reset your password',
                      style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Enter your registered email address below. We will send you a link to reset your password.',
                      style: TextStyle(
                        color: isDarkMode ? Colors.white70 : Colors.black54,
                        fontSize: 16,
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 32),

                    // 4. Email Input Field
                    _buildEmailInput(isDarkMode),

                    const SizedBox(height: 24),

                    // 5. Send Reset Link Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          // Logic gửi link reset mật khẩu
                        },
                        // Sử dụng style đã được sửa lỗi shadowColor trong constants.dart
                        style: AppStyles.primaryButtonStyle,
                        child: const Text('Send Reset Link'),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 6. Secondary Option (Back to Login)
            _buildBackToLogin(isDarkMode, context),

            // 7. Footer - International Support Context
            _buildFooter(isDarkMode),
          ],
        ),
      ),
    );
  }

  // --- CÁC THÀNH PHẦN WIDGET HỖ TRỢ ---

  Widget _buildLanguageSwitcher(bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _buildLangBadge('EN', true, isDarkMode),
          const SizedBox(width: 8),
          _buildLangBadge('VN', false, isDarkMode),
          const SizedBox(width: 8),
          _buildLangBadge('KR', false, isDarkMode),
        ],
      ),
    );
  }

  Widget _buildLangBadge(String label, bool isActive, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isActive
            ? (isDarkMode ? Colors.white10 : Colors.black.withValues(alpha: 0.05))
            : Colors.transparent,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          color: isActive
              ? (isDarkMode ? Colors.white : Colors.black)
              : (isDarkMode ? Colors.white38 : Colors.black38),
        ),
      ),
    );
  }

  Widget _buildEmailInput(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
            'Email Address',
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16)
        ),
        const SizedBox(height: 8),
        TextField(
          style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
          decoration: InputDecoration(
            hintText: 'example@finance.com',
            hintStyle: TextStyle(
                color: isDarkMode ? AppColors.textMint.withValues(alpha: 0.5) : Colors.grey[400]
            ),
            prefixIcon: Icon(
                Icons.mail,
                color: isDarkMode ? AppColors.textMint : Colors.grey[400]
            ),
            filled: true,
            fillColor: isDarkMode ? AppColors.inputBgDark : Colors.white,
            contentPadding: const EdgeInsets.all(16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                  color: isDarkMode ? AppColors.borderColor : Colors.grey[300]!
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBackToLogin(bool isDarkMode, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32.0),
      child: Column(
        children: [
          Text(
              'Remember your password?',
              style: TextStyle(color: isDarkMode ? Colors.white54 : Colors.black45, fontSize: 14)
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.login, color: AppColors.primary, size: 20),
                SizedBox(width: 8),
                Text(
                    'Back to Login',
                    style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 16
                    )
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: isDarkMode ? Colors.white10 : Colors.black12)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              _buildFooterText('Hỗ trợ', isDarkMode),
              const SizedBox(width: 16),
              _buildFooterText('지원', isDarkMode),
            ],
          ),
          Row(
            children: [
              Icon(
                  Icons.security,
                  color: isDarkMode ? Colors.white24 : Colors.black26,
                  size: 14
              ),
              const SizedBox(width: 4),
              _buildFooterText('Secure Reset', isDarkMode),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFooterText(String text, bool isDarkMode) {
    return Text(
      text.toUpperCase(),
      style: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.5,
        color: isDarkMode ? Colors.white24 : Colors.black26,
      ),
    );
  }
}
