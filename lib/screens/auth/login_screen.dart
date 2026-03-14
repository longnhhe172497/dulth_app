import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../constants.dart';
import '../../services/auth_service.dart';
import 'register_screen.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final AuthService _authService = AuthService();

  bool _isPasswordVisible = false;
  bool _isLoading = false;

  String? _errorMessage;

  Future<void> _login() async {

    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {

      await _authService.login(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

    } on FirebaseAuthException catch (e) {

      setState(() {

        switch (e.code) {

          case 'user-not-found':
            _errorMessage = "Không tìm thấy tài khoản";
            break;

          case 'wrong-password':
            _errorMessage = "Sai mật khẩu";
            break;

          case 'invalid-email':
            _errorMessage = "Email không hợp lệ";
            break;

          default:
            _errorMessage = "Đăng nhập thất bại";
        }

      });

    } finally {

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }

    }

  }

  @override
  Widget build(BuildContext context) {

    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    return Scaffold(

      backgroundColor: isDark
          ? AppColors.backgroundDark
          : AppColors.backgroundLight,

      body: SafeArea(

        child: SingleChildScrollView(

          padding: const EdgeInsets.symmetric(horizontal: 24),

          child: Form(

            key: _formKey,

            child: Column(

              children: [

                const SizedBox(height: 80),

                /// LOGO

                Container(

                  width: 90,
                  height: 90,

                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),

                  child: const Icon(
                    Icons.account_balance_wallet,
                    size: 40,
                    color: AppColors.primary,
                  ),

                ),

                const SizedBox(height: 30),

                /// TITLE

                const Text(
                  "Welcome Back",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  "Sign in to continue",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 40),

                /// LOGIN CARD

                Container(

                  padding: const EdgeInsets.all(24),

                  decoration: BoxDecoration(

                    color: isDark
                        ? AppColors.inputBgDark
                        : Colors.white,

                    borderRadius: BorderRadius.circular(20),

                    boxShadow: [

                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      )

                    ],

                  ),

                  child: Column(

                    children: [

                      /// EMAIL

                      TextFormField(

                        controller: _emailController,

                        keyboardType: TextInputType.emailAddress,

                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.email_outlined),
                          hintText: "Email",
                        ),

                        validator: (value) {

                          if (value == null || value.isEmpty) {
                            return "Vui lòng nhập email";
                          }

                          return null;

                        },

                      ),

                      const SizedBox(height: 20),

                      /// PASSWORD

                      TextFormField(

                        controller: _passwordController,

                        obscureText: !_isPasswordVisible,

                        decoration: InputDecoration(

                          prefixIcon:
                          const Icon(Icons.lock_outline),

                          hintText: "Password",

                          suffixIcon: IconButton(

                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),

                            onPressed: () {

                              setState(() {
                                _isPasswordVisible =
                                !_isPasswordVisible;
                              });

                            },

                          ),

                        ),

                        validator: (value) {

                          if (value == null || value.length < 6) {
                            return "Mật khẩu tối thiểu 6 ký tự";
                          }

                          return null;

                        },

                      ),

                      const SizedBox(height: 10),

                      /// FORGOT PASSWORD

                      Align(

                        alignment: Alignment.centerRight,

                        child: TextButton(

                          onPressed: () {

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                const ForgotPasswordScreen(),
                              ),
                            );

                          },

                          child: const Text("Forgot Password?"),

                        ),

                      ),

                      const SizedBox(height: 10),

                      /// ERROR

                      if (_errorMessage != null)
                        Text(
                          _errorMessage!,
                          style: const TextStyle(
                            color: Colors.red,
                          ),
                        ),

                      const SizedBox(height: 10),

                      /// LOGIN BUTTON

                      SizedBox(

                        width: double.infinity,
                        height: 50,

                        child: ElevatedButton(

                          style: AppStyles.primaryButtonStyle,

                          onPressed:
                          _isLoading ? null : _login,

                          child: _isLoading
                              ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                              : const Text("Login"),

                        ),

                      ),

                    ],

                  ),

                ),

                const SizedBox(height: 30),

                /// REGISTER

                Row(

                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [

                    const Text("Don't have an account?"),

                    TextButton(

                      onPressed: () {

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                            const RegisterAccountScreen(),
                          ),
                        );

                      },

                      child: const Text(
                        "Register",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),

                    )

                  ],

                ),

                const SizedBox(height: 40),

              ],

            ),

          ),

        ),

      ),

    );

  }

  @override
  void dispose() {

    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();

  }

}