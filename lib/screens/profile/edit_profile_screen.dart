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

  final _nameController =
  TextEditingController();
  final _emailController =
  TextEditingController();
  final _phoneController =
  TextEditingController();
  final _majorController =
  TextEditingController();

  String _selectedLanguage =
      'Vietnamese';

  bool _isLoading = false;

  final user =
      FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // 🔥 LOAD DATA FROM FIRESTORE
  Future<void> _loadUserData() async {
    if (user == null) return;

    final doc =
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();

    if (doc.exists) {
      final data =
      doc.data() as Map<String, dynamic>;

      _nameController.text =
          data['fullName'] ?? '';
      _emailController.text =
          data['email'] ?? '';
      _phoneController.text =
          data['phone'] ?? '';
      _majorController.text =
          data['major'] ?? 'IT Student';
      _selectedLanguage =
          data['language'] ?? 'Vietnamese';

      setState(() {});
    }
  }

  // 🔥 SAVE TO FIRESTORE
  Future<void> _saveProfile() async {
    if (!_formKey.currentState!
        .validate()) return;

    setState(() => _isLoading = true);

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .update({
        "fullName":
        _nameController.text.trim(),
        "email":
        _emailController.text.trim(),
        "phone":
        _phoneController.text.trim(),
        "major":
        _majorController.text.trim(),
        "language": _selectedLanguage,
      });

      if (mounted) Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
            content:
            Text("Lỗi khi lưu dữ liệu")),
      );
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode =
        Theme.of(context).brightness ==
            Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode
          ? AppColors.backgroundDark
          : AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor:
        Colors.transparent,
        elevation: 0,
        title: const Text(
          'Edit Profile',
          style: TextStyle(
              fontWeight:
              FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding:
        const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 20),

              _buildTextField(
                  "Full Name",
                  _nameController,
                  isDarkMode),

              const SizedBox(height: 16),

              _buildTextField(
                  "Email",
                  _emailController,
                  isDarkMode,
                  type:
                  TextInputType.emailAddress),

              const SizedBox(height: 16),

              _buildTextField(
                  "Phone",
                  _phoneController,
                  isDarkMode,
                  type:
                  TextInputType.phone),

              const SizedBox(height: 16),

              _buildTextField(
                  "Major",
                  _majorController,
                  isDarkMode),

              const SizedBox(height: 24),

              _buildLanguageSelector(
                  isDarkMode),

              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                height: 55,
                child:
                ElevatedButton.icon(
                  onPressed: _isLoading
                      ? null
                      : _saveProfile,
                  icon: const Icon(
                      Icons.save),
                  label: _isLoading
                      ? const CircularProgressIndicator(
                      color:
                      Colors.white)
                      : const Text(
                      "Save Changes"),
                  style: AppStyles
                      .primaryButtonStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label,
      TextEditingController
      controller,
      bool isDarkMode,
      {TextInputType? type}) {
    return TextFormField(
      controller: controller,
      keyboardType: type,
      validator: (value) {
        if (value == null ||
            value.isEmpty) {
          return "Không được để trống";
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
          borderRadius:
          BorderRadius.circular(16),
        ),
      ),
    );
  }

  Widget _buildLanguageSelector(
      bool isDarkMode) {
    final langs = [
      'Vietnamese',
      'Korean',
      'English'
    ];

    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        const Text(
          "Preferred Language",
          style: TextStyle(
              fontWeight:
              FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Row(
          children: langs.map((lang) {
            bool isSelected =
                _selectedLanguage ==
                    lang;

            return Expanded(
              child: GestureDetector(
                onTap: () => setState(
                        () => _selectedLanguage =
                        lang),
                child: Container(
                  margin:
                  const EdgeInsets
                      .all(4),
                  padding:
                  const EdgeInsets
                      .all(10),
                  decoration:
                  BoxDecoration(
                    color: isSelected
                        ? AppColors
                        .primary
                        .withOpacity(
                        0.2)
                        : Colors
                        .transparent,
                    borderRadius:
                    BorderRadius
                        .circular(
                        10),
                    border: Border.all(
                      color: isSelected
                          ? AppColors
                          .primary
                          : Colors.grey,
                    ),
                  ),
                  alignment:
                  Alignment
                      .center,
                  child: Text(
                    lang,
                    style: TextStyle(
                        fontWeight:
                        FontWeight
                            .bold),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
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