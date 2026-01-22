import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../main_screen_host.dart';
import 'register_screen.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              // --- 1. Top Header App Bar ---
              _buildHeader(isDarkMode),
              const SizedBox(height: 48),

              // --- 2. Headline & Welcome ---
              const Text(
                'Chào mừng trở lại',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '다시 오신 것을 환영합니다 (Welcome back)',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textMint,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 40),

              // --- 3. Login Form ---
              _buildLabel('Email', isDarkMode),
              _buildTextField(
                hintText: 'example@email.com',
                isDarkMode: isDarkMode,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildLabel('Password', isDarkMode),
                  TextButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ForgotPasswordScreen()),
                    ),
                    child: const Text(
                      'Forgot password?',
                      style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              _buildPasswordField(isDarkMode),
              const SizedBox(height: 32),

              // --- 4. Login Button (Fixed shadowColor via constants) ---
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const MainScreenHost()),
                  ),
                  style: AppStyles.primaryButtonStyle,
                  child: const Text('Login'),
                ),
              ),

              // --- 5. Social Login Section ---
              _buildDivider(isDarkMode),
              _buildSocialButton('Google', Icons.g_mobiledata, Colors.blue, isDarkMode),
              const SizedBox(height: 12),
              _buildSocialButton('Apple', Icons.apple, isDarkMode ? Colors.white : Colors.black, isDarkMode),

              const SizedBox(height: 40),

              // --- 6. Footer (Link to Register) ---
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Don’t have an account?',
                      style: TextStyle(color: isDarkMode ? AppColors.textMint : Colors.grey[600]),
                    ),
                    TextButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const RegisterAccountScreen()),
                      ),
                      child: const Text(
                        'Register',
                        style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // --- Widget Components ---

  Widget _buildHeader(bool isDarkMode) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(10)),
              child: const Icon(Icons.account_balance_wallet, color: AppColors.backgroundDark, size: 20),
            ),
            const SizedBox(width: 12),
            const Text(
              'FinanceFlow',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isDarkMode ? AppColors.inputBgDark : Colors.grey[200],
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(
            'VN | KR | EN',
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textMint),
          ),
        ),
      ],
    );
  }

  Widget _buildLabel(String text, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: isDarkMode ? Colors.white : Colors.black87,
        ),
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

  Widget _buildPasswordField(bool isDarkMode) {
    return TextField(
      obscureText: !_isPasswordVisible,
      style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
      decoration: InputDecoration(
        hintText: '••••••••',
        hintStyle: TextStyle(color: isDarkMode ? AppColors.textMint.withOpacity(0.4) : Colors.grey[400]),
        filled: true,
        fillColor: isDarkMode ? AppColors.inputBgDark : Colors.white,
        contentPadding: const EdgeInsets.all(16),
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            color: isDarkMode ? AppColors.textMint : Colors.grey[400],
          ),
          onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
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

  Widget _buildDivider(bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32.0),
      child: Row(
        children: [
          Expanded(child: Divider(color: isDarkMode ? AppColors.borderColor : Colors.grey[300])),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Or continue with',
              style: TextStyle(color: isDarkMode ? AppColors.textMint : Colors.grey[500], fontSize: 13),
            ),
          ),
          Expanded(child: Divider(color: isDarkMode ? AppColors.borderColor : Colors.grey[300])),
        ],
      ),
    );
  }

  Widget _buildSocialButton(String label, IconData icon, Color iconColor, bool isDarkMode) {
    return OutlinedButton(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        side: BorderSide(color: isDarkMode ? AppColors.borderColor : Colors.grey[300]!),
        backgroundColor: isDarkMode ? Colors.transparent : Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: iconColor, size: 24),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              color: isDarkMode ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}