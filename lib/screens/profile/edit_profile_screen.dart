import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../constants.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() =>
      _EditProfileScreenState();
}

class _EditProfileScreenState
    extends State<EditProfileScreen> {

  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _majorController = TextEditingController();

  bool _isLoading = false;

  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // ================= LOAD USER =================

  Future<void> _loadUserData() async {

    if (user == null) return;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();

    if (!doc.exists) return;

    final data = doc.data() as Map<String, dynamic>;

    _nameController.text = data['fullName'] ?? '';
    _emailController.text = data['email'] ?? '';
    _phoneController.text = data['phone'] ?? '';
    _majorController.text = data['major'] ?? 'IT Student';

    setState(() {});
  }

  // ================= SAVE PROFILE =================

  Future<void> _saveProfile() async {

    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .update({

        "fullName": _nameController.text.trim(),
        "email": _emailController.text.trim(),
        "phone": _phoneController.text.trim(),
        "major": _majorController.text.trim(),

      });

      if (mounted) {
        Navigator.pop(context);
      }

    } catch (e) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Error saving profile"),
        ),
      );

    }

    setState(() => _isLoading = false);
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
        centerTitle: true,
        title: const Text(
          "Edit Profile",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Form(

          key: _formKey,

          child: Column(

            children: [

              const SizedBox(height: 20),

              _buildTextField(
                "Full Name",
                _nameController,
                isDarkMode,
              ),

              const SizedBox(height: 16),

              _buildTextField(
                "Email",
                _emailController,
                isDarkMode,
                type: TextInputType.emailAddress,
              ),

              const SizedBox(height: 16),

              _buildTextField(
                "Phone",
                _phoneController,
                isDarkMode,
                type: TextInputType.phone,
              ),

              const SizedBox(height: 16),

              _buildTextField(
                "Major",
                _majorController,
                isDarkMode,
              ),

              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                height: 55,

                child: ElevatedButton.icon(

                  onPressed:
                  _isLoading ? null : _saveProfile,

                  icon: const Icon(Icons.save),

                  label: _isLoading
                      ? const CircularProgressIndicator(
                      color: Colors.white)
                      : const Text("Save Changes"),

                  style: AppStyles.primaryButtonStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================= TEXT FIELD =================

  Widget _buildTextField(
      String label,
      TextEditingController controller,
      bool isDarkMode,
      {TextInputType? type}) {

    return TextFormField(

      controller: controller,

      keyboardType: type,

      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Required field";
        }
        return null;
      },

      decoration: InputDecoration(

        labelText: label,

        filled: true,

        fillColor: isDarkMode
            ? AppColors.inputBgDark
            : Colors.white,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  @override
  void dispose() {

    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _majorController.dispose();

    super.dispose();
  }
}