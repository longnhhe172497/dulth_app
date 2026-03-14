import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../constants.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState
    extends State<ForgotPasswordScreen> {

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController =
  TextEditingController();

  bool _isLoading = false;

  String? _message;

  Future<void> _resetPassword() async {

    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _message = null;
    });

    try {

      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _emailController.text.trim(),
      );

      setState(() {
        _message =
        "Link đặt lại mật khẩu đã được gửi vào email của bạn.";
      });

    } on FirebaseAuthException catch (e) {

      setState(() {

        switch (e.code) {

          case 'user-not-found':
            _message = "Không tìm thấy tài khoản";
            break;

          case 'invalid-email':
            _message = "Email không hợp lệ";
            break;

          default:
            _message = "Không thể gửi email reset";
        }

      });

    } finally {

      setState(() {
        _isLoading = false;
      });

    }

  }

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

        leading: IconButton(

          icon: Icon(
            Icons.chevron_left,
            color: isDarkMode ? Colors.white : Colors.black,
            size: 32,
          ),

          onPressed: () => Navigator.pop(context),

        ),

        title: const Text(
          'Forgot Password',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),

        centerTitle: true,

      ),

      body: SafeArea(

        child: Form(

          key: _formKey,

          child: SingleChildScrollView(

            padding:
            const EdgeInsets.symmetric(horizontal: 24),

            child: Column(

              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

                const SizedBox(height: 40),

                /// ICON

                Center(

                  child: Container(

                    width: 96,
                    height: 96,

                    decoration: BoxDecoration(

                      color: AppColors.primary
                          .withOpacity(0.2),

                      shape: BoxShape.circle,

                    ),

                    child: const Icon(
                      Icons.lock_reset,
                      color: AppColors.primary,
                      size: 48,
                    ),

                  ),

                ),

                const SizedBox(height: 32),

                /// TITLE

                const Text(

                  'Reset your password',

                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),

                ),

                const SizedBox(height: 12),

                Text(

                  'Enter your registered email address. '
                      'We will send you a reset link.',

                  style: TextStyle(

                    color: isDarkMode
                        ? Colors.white70
                        : Colors.black54,

                    fontSize: 16,

                  ),

                ),

                const SizedBox(height: 32),

                /// EMAIL

                const Text(
                  'Email Address',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 8),

                TextFormField(

                  controller: _emailController,

                  validator: (value) {

                    if (value == null || value.isEmpty) {
                      return "Vui lòng nhập email";
                    }

                    if (!value.contains("@")) {
                      return "Email không hợp lệ";
                    }

                    return null;

                  },

                  decoration: InputDecoration(

                    hintText: "example@email.com",

                    prefixIcon:
                    const Icon(Icons.email_outlined),

                    filled: true,

                    fillColor: isDarkMode
                        ? AppColors.inputBgDark
                        : Colors.white,

                    border: OutlineInputBorder(
                      borderRadius:
                      BorderRadius.circular(16),
                    ),

                    focusedBorder: OutlineInputBorder(
                      borderRadius:
                      BorderRadius.circular(16),
                      borderSide: const BorderSide(
                        color: AppColors.primary,
                        width: 2,
                      ),
                    ),

                  ),

                ),

                const SizedBox(height: 24),

                /// MESSAGE

                if (_message != null)

                  Text(

                    _message!,

                    style: TextStyle(

                      color: _message!.contains("gửi")
                          ? Colors.green
                          : Colors.red,

                    ),

                  ),

                const SizedBox(height: 24),

                /// BUTTON

                SizedBox(

                  width: double.infinity,
                  height: 56,

                  child: ElevatedButton(

                    onPressed:
                    _isLoading ? null : _resetPassword,

                    style: AppStyles.primaryButtonStyle,

                    child: _isLoading
                        ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                        : const Text("Send Reset Link"),

                  ),

                ),

                const SizedBox(height: 40),

                /// BACK TO LOGIN

                Center(

                  child: TextButton(

                    onPressed: () {
                      Navigator.pop(context);
                    },

                    child: const Text(
                      "Back to Login",
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                  ),

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

    super.dispose();

  }

}