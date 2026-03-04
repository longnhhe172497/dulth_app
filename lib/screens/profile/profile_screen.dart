import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../constants.dart';
import '../../services/auth_service.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Center(child: Text("Chưa đăng nhập"));
    }

    final bool isDarkMode =
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
          'Hồ sơ / 프로필',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      // 🔥 REALTIME FIRESTORE LISTENER
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .snapshots(),
        builder: (context, snapshot) {
          // Loading
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator());
          }

          // Không có document
          if (!snapshot.hasData ||
              !snapshot.data!.exists) {
            return const Center(
                child: Text("Không tìm thấy dữ liệu"));
          }

          // Lấy data an toàn
          final doc = snapshot.data!;
          final data =
              doc.data() as Map<String, dynamic>? ?? {};

          final String fullName =
              data['fullName'] ?? 'No Name';
          final String email =
              data['email'] ?? user.email ?? '';
          final String major =
              data['major'] ?? 'IT Student';
          final String avatar =
              data['avatar'] ??
                  'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?q=80&w=200';
          final int balance =
              data['balance'] ?? 0;
          final String currency =
              data['currency'] ?? 'VND';

          return SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 30),

                // ===== AVATAR =====
                CircleAvatar(
                  radius: 50,
                  backgroundImage:
                  NetworkImage(avatar),
                ),

                const SizedBox(height: 16),

                // ===== NAME =====
                Text(
                  fullName,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                // ===== EMAIL =====
                Text(
                  email,
                  style: TextStyle(
                    color: isDarkMode
                        ? AppColors.textMint
                        : Colors.grey[600],
                  ),
                ),

                const SizedBox(height: 4),

                // ===== MAJOR =====
                Text(
                  major,
                  style: TextStyle(
                    color: isDarkMode
                        ? AppColors.textMint
                        : Colors.grey[600],
                  ),
                ),

                const SizedBox(height: 20),

                // ===== BALANCE CARD =====
                Container(
                  margin:
                  const EdgeInsets.symmetric(
                      horizontal: 24),
                  padding:
                  const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? AppColors.cardDark
                        : Colors.white,
                    borderRadius:
                    BorderRadius.circular(20),
                    boxShadow: [
                      if (!isDarkMode)
                        BoxShadow(
                          color: Colors.black
                              .withOpacity(0.05),
                          blurRadius: 10,
                        )
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text(
                        "Số dư hiện tại",
                        style: TextStyle(
                            fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "$balance $currency",
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight:
                          FontWeight.bold,
                          color:
                          AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // ===== ACCOUNT SECTION =====
                _sectionLabel(
                    "Tài khoản / 계정",
                    isDarkMode),

                _settingTile(
                  icon: Icons.person_outline,
                  title:
                  "Chỉnh sửa hồ sơ",
                  isDarkMode:
                  isDarkMode,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                        const EditProfileScreen(),
                      ),
                    );
                  },
                ),
                // ===== LANGUAGE SETTING =====
                _settingTile(
                  icon: Icons.language,
                  title: "Ngôn ngữ / Language",
                  isDarkMode: isDarkMode,
                  onTap: () {
                    _showLanguageSelector(
                      context,
                      user.uid,
                      data['language'] ?? "vi",
                    );
                  },
                ),

// ===== DARK MODE SETTING =====
                SwitchListTile(
                  secondary: const Icon(Icons.dark_mode,
                      color: AppColors.primary),
                  title: const Text("Chế độ tối / Dark Mode"),
                  value: data['darkMode'] ?? false,
                  onChanged: (value) async {
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(user.uid)
                        .update({
                      "darkMode": value
                    });
                  },
                ),

                const SizedBox(height: 24),

                // ===== LOGOUT =====
                Padding(
                  padding:
                  const EdgeInsets.all(16),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      icon:
                      const Icon(Icons.logout),
                      label:
                      const Text("Đăng xuất"),
                      style:
                      ElevatedButton.styleFrom(
                        backgroundColor:
                        Colors.red
                            .withOpacity(0.1),
                        foregroundColor:
                        Colors.red,
                        elevation: 0,
                        shape:
                        RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(
                              16),
                        ),
                      ),
                      onPressed: () async {
                        await AuthService()
                            .logout();
                        // AuthWrapper tự chuyển về login
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
    );
  }

  // ===== SECTION LABEL =====
  Widget _sectionLabel(
      String label,
      bool isDarkMode) {
    return Container(
      width: double.infinity,
      padding:
      const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 8),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          color: isDarkMode
              ? AppColors.textMint
              : Colors.grey,
          fontSize: 11,
          fontWeight:
          FontWeight.bold,
        ),
      ),
    );
  }

  // ===== SETTING TILE =====
  Widget _settingTile({
    required IconData icon,
    required String title,
    required bool isDarkMode,
    VoidCallback? onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Icon(
        icon,
        color: AppColors.primary,
      ),
      title: Text(title),
      trailing:
      const Icon(Icons.chevron_right),
    );
  }
  void _showLanguageSelector(
      BuildContext context,
      String uid,
      String currentLang,
      ) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Chọn ngôn ngữ / Select Language",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              // ===== VIETNAMESE =====
              ListTile(
                title: const Text("Tiếng Việt"),
                trailing: currentLang == "vi"
                    ? const Icon(Icons.check,
                    color: AppColors.primary)
                    : null,
                onTap: () async {
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(uid)
                      .update({
                    "language": "vi"
                  });

                  Navigator.pop(context);
                },
              ),

              // ===== ENGLISH =====
              ListTile(
                title: const Text("English"),
                trailing: currentLang == "en"
                    ? const Icon(Icons.check,
                    color: AppColors.primary)
                    : null,
                onTap: () async {
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(uid)
                      .update({
                    "language": "en"
                  });

                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}