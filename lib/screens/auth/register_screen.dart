import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../constants.dart';
import '../../services/auth_service.dart';
import '../../services/firestore_service.dart';

class RegisterAccountScreen extends StatefulWidget {
  const RegisterAccountScreen({super.key});

  @override
  State<RegisterAccountScreen> createState() =>
      _RegisterAccountScreenState();
}

class _RegisterAccountScreenState extends State<RegisterAccountScreen> {

  final _formKey = GlobalKey<FormState>();

  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isTermsAgreed = false;
  bool _isLoading = false;

  String? _errorMessage;

  // ================= REGISTER =================

  Future<void> _register() async {

    if (!_formKey.currentState!.validate()) return;

    if (!_isTermsAgreed) {
      setState(() {
        _errorMessage = "Bạn phải đồng ý điều khoản trước khi đăng ký";
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {

      // 1️⃣ CREATE AUTH USER
      User? user = await _authService.register(
        _emailController.text.trim(),
        _passwordController.text.trim(),
        _fullNameController.text.trim(),
      );

      if (user == null) {
        throw Exception("Không tạo được user");
      }

      // 2️⃣ CREATE FIRESTORE PROFILE
      await _firestoreService.createUserProfile(
        fullName: _fullNameController.text.trim(),
        email: _emailController.text.trim(),
      );

      if (mounted) {

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Đăng ký thành công"),
          ),
        );

        Navigator.pop(context);

      }

    } on FirebaseAuthException catch (e) {

      if (!mounted) return;

      setState(() {

        switch (e.code) {

          case 'email-already-in-use':
            _errorMessage = "Email đã được sử dụng";
            break;

          case 'invalid-email':
            _errorMessage = "Email không hợp lệ";
            break;

          case 'weak-password':
            _errorMessage = "Mật khẩu phải tối thiểu 6 ký tự";
            break;

          default:
            _errorMessage = e.message ?? "Đăng ký thất bại";

        }

      });

    } catch (e) {

      if (!mounted) return;

      setState(() {
        _errorMessage = "Có lỗi xảy ra. Vui lòng thử lại.";
      });

    } finally {

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }

    }
  }

  // ================= UI =================

  @override
  Widget build(BuildContext context) {

    bool isDarkMode =
        Theme.of(context).brightness == Brightness.dark;

    return Scaffold(

      backgroundColor: isDarkMode
          ? AppColors.backgroundDark
          : AppColors.backgroundLight,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Register"),
        centerTitle: true,
      ),

      body: SafeArea(
        child: SingleChildScrollView(

          padding: const EdgeInsets.symmetric(horizontal: 24),

          child: Form(
            key: _formKey,

            child: Column(

              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                const SizedBox(height: 30),

                const Text(
                  'Create your account',
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 30),

                /// FULL NAME
                _label("Full Name", isDarkMode),

                const SizedBox(height: 8),

                _textField(
                  controller: _fullNameController,
                  hint: "Enter your full name",
                  isDarkMode: isDarkMode,
                ),

                const SizedBox(height: 20),

                /// EMAIL
                _label("Email", isDarkMode),

                const SizedBox(height: 8),

                _textField(
                  controller: _emailController,
                  hint: "name@example.com",
                  isDarkMode: isDarkMode,
                  keyboardType: TextInputType.emailAddress,
                ),

                const SizedBox(height: 20),

                /// PASSWORD
                _label("Password", isDarkMode),

                const SizedBox(height: 8),

                _passwordField(
                  controller: _passwordController,
                  hint: "Create password",
                  isVisible: _isPasswordVisible,
                  isDarkMode: isDarkMode,
                  toggle: () {
                    setState(() {
                      _isPasswordVisible =
                      !_isPasswordVisible;
                    });
                  },
                ),

                const SizedBox(height: 20),

                /// CONFIRM PASSWORD
                _label("Confirm Password", isDarkMode),

                const SizedBox(height: 8),

                _passwordField(
                  controller: _confirmPasswordController,
                  hint: "Confirm password",
                  isVisible: _isConfirmPasswordVisible,
                  isDarkMode: isDarkMode,
                  toggle: () {
                    setState(() {
                      _isConfirmPasswordVisible =
                      !_isConfirmPasswordVisible;
                    });
                  },
                ),

                if (_errorMessage != null)

                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),

                const SizedBox(height: 30),

                /// TERMS

                Row(
                  children: [

                    Checkbox(
                      value: _isTermsAgreed,
                      onChanged: (val) {
                        setState(() {
                          _isTermsAgreed = val!;
                        });
                      },
                    ),

                    const Text("I agree to Terms"),

                  ],
                ),

                const SizedBox(height: 20),

                /// REGISTER BUTTON

                SizedBox(

                  width: double.infinity,
                  height: 55,

                  child: ElevatedButton(

                    style: AppStyles.primaryButtonStyle,

                    onPressed:
                    _isLoading ? null : _register,

                    child: _isLoading

                        ? const CircularProgressIndicator(
                        color: Colors.white)

                        : const Text("Sign Up"),

                  ),

                ),

                const SizedBox(height: 30),

              ],
            ),
          ),
        ),
      ),
    );
  }

  // ================= COMPONENTS =================

  Widget _label(String text, bool isDark) {

    return Text(

      text,

      style: TextStyle(

          fontWeight: FontWeight.bold,

          color: isDark
              ? Colors.white
              : Colors.black),

    );

  }

  Widget _textField({

    required TextEditingController controller,

    required String hint,

    required bool isDarkMode,

    TextInputType? keyboardType,

  }) {

    return TextFormField(

      controller: controller,

      keyboardType: keyboardType,

      validator: (value) {

        if (value == null || value.isEmpty) {
          return "Không được để trống";
        }

        return null;

      },

      decoration: InputDecoration(

        hintText: hint,

        filled: true,

        fillColor:
        isDarkMode ? AppColors.inputBgDark : Colors.white,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
        ),

        contentPadding: const EdgeInsets.all(16),

      ),

    );

  }

  Widget _passwordField({

    required TextEditingController controller,

    required String hint,

    required bool isVisible,

    required bool isDarkMode,

    required VoidCallback toggle,

  }) {

    return TextFormField(

      controller: controller,

      obscureText: !isVisible,

      validator: (value) {

        if (value == null || value.isEmpty) {
          return "Không được để trống";
        }

        if (controller == _passwordController && value.length < 6) {
          return "Mật khẩu tối thiểu 6 ký tự";
        }

        if (controller == _confirmPasswordController &&
            value != _passwordController.text) {
          return "Mật khẩu không khớp";
        }

        return null;

      },

      decoration: InputDecoration(

        hintText: hint,

        filled: true,

        fillColor:
        isDarkMode ? AppColors.inputBgDark : Colors.white,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
        ),

        suffixIcon: IconButton(
          icon: Icon(
              isVisible ? Icons.visibility : Icons.visibility_off),
          onPressed: toggle,
        ),

        contentPadding: const EdgeInsets.all(16),

      ),

    );

  }

  @override
  void dispose() {

    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    super.dispose();

  }
}