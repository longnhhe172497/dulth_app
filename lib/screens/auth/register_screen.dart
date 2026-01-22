import 'package:flutter/material.dart';
import '../../constants.dart';

class RegisterAccountScreen extends StatefulWidget {
  const RegisterAccountScreen({super.key});

  @override
  State<RegisterAccountScreen> createState() => _RegisterAccountScreenState();
}

class _RegisterAccountScreenState extends State<RegisterAccountScreen> {
  // Quản lý trạng thái hiển thị mật khẩu và điều khoản
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isTermsAgreed = false;

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: _buildAppBar(isDarkMode),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              // --- 1. Headline & Description ---
              const Text(
                'Create your account',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Join our personal finance platform to manage your wealth seamlessly in Vietnamese and Korean.',
                style: TextStyle(
                    color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                    fontSize: 16,
                    height: 1.5
                ),
              ),
              const SizedBox(height: 32),

              // --- 2. Registration Form ---
              _buildLabel('Full Name / 성명', isDarkMode),
              _buildTextField(hintText: 'Enter your full name', isDarkMode: isDarkMode),
              const SizedBox(height: 20),

              _buildLabel('Email / 이메일', isDarkMode),
              _buildTextField(
                  hintText: 'name@example.com',
                  isDarkMode: isDarkMode,
                  keyboardType: TextInputType.emailAddress
              ),
              const SizedBox(height: 20),

              _buildLabel('Password / 비밀번호', isDarkMode),
              _buildPasswordField(
                hintText: 'Create a password',
                isVisible: _isPasswordVisible,
                isDarkMode: isDarkMode,
                toggleVisibility: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
              ),
              const SizedBox(height: 20),

              _buildLabel('Confirm Password / 비밀번호 확인', isDarkMode),
              _buildPasswordField(
                hintText: 'Confirm your password',
                isVisible: _isConfirmPasswordVisible,
                isDarkMode: isDarkMode,
                toggleVisibility: () => setState(() => _isConfirmPasswordVisible = !_isConfirmPasswordVisible),
              ),
              const SizedBox(height: 24),

              // --- 3. Terms and Conditions ---
              _buildTermsCheckbox(isDarkMode),

              const SizedBox(height: 32),

              // --- 4. Sign Up Button (Fixed shadowColor via styleFrom) ---
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isTermsAgreed ? () {
                    // Xử lý đăng ký
                  } : null, // Vô hiệu hóa nút nếu chưa đồng ý điều khoản
                  style: AppStyles.primaryButtonStyle.copyWith(
                    // Điều chỉnh opacity khi nút bị disabled
                    backgroundColor: MaterialStateProperty.resolveWith((states) =>
                    states.contains(MaterialState.disabled)
                        ? AppColors.primary.withOpacity(0.3)
                        : AppColors.primary
                    ),
                  ),
                  child: const Text('Sign Up / 회원가입'),
                ),
              ),

              // --- 5. Footer (Link to Login) ---
              _buildFooter(isDarkMode),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // --- Widget Components ---

  PreferredSizeWidget _buildAppBar(bool isDarkMode) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: Icon(
            Icons.arrow_back_ios,
            color: isDarkMode ? Colors.white : Colors.black,
            size: 20
        ),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text(
          'Register Account',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)
      ),
      centerTitle: true,
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 16, top: 12, bottom: 12),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4)
          ),
          child: const Text(
              'VN/KR',
              style: TextStyle(color: AppColors.primary, fontSize: 10, fontWeight: FontWeight.bold)
          ),
        )
      ],
    );
  }

  Widget _buildLabel(String text, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4),
      child: Text(
          text,
          style: TextStyle(
              color: isDarkMode ? Colors.white : Colors.black87,
              fontSize: 14,
              fontWeight: FontWeight.bold
          )
      ),
    );
  }

  Widget _buildTextField({required String hintText, required bool isDarkMode, TextInputType? keyboardType}) {
    return TextField(
      keyboardType: keyboardType,
      style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: isDarkMode ? AppColors.textMint.withOpacity(0.4) : Colors.grey[400]),
        filled: true,
        fillColor: isDarkMode ? AppColors.inputBgDark : Colors.white,
        contentPadding: const EdgeInsets.all(16),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: isDarkMode ? AppColors.borderColor : Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required String hintText,
    required bool isVisible,
    required bool isDarkMode,
    required VoidCallback toggleVisibility
  }) {
    return TextField(
      obscureText: !isVisible,
      style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: isDarkMode ? AppColors.textMint.withOpacity(0.4) : Colors.grey[400]),
        filled: true,
        fillColor: isDarkMode ? AppColors.inputBgDark : Colors.white,
        contentPadding: const EdgeInsets.all(16),
        suffixIcon: IconButton(
          icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off, color: Colors.grey),
          onPressed: toggleVisibility,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: isDarkMode ? AppColors.borderColor : Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
      ),
    );
  }

  Widget _buildTermsCheckbox(bool isDarkMode) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 24, width: 24,
          child: Checkbox(
            value: _isTermsAgreed,
            onChanged: (val) => setState(() => _isTermsAgreed = val!),
            activeColor: AppColors.primary,
            checkColor: Colors.black,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: TextStyle(
                  color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                  fontSize: 13,
                  height: 1.4,
                  fontFamily: 'Inter'
              ),
              children: [
                const TextSpan(text: 'I agree to the '),
                const TextSpan(text: 'Terms of Service', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                const TextSpan(text: ' and '),
                const TextSpan(text: 'Privacy Policy', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                const TextSpan(text: ' / 약관 및 개인정보 보호정책에 동의합니다.'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFooter(bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
              'Already have an account?',
              style: TextStyle(color: isDarkMode ? Colors.grey[400] : Colors.grey[600], fontSize: 14)
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Text(
                'Log In',
                style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 14)
            ),
          ),
        ],
      ),
    );
  }
}