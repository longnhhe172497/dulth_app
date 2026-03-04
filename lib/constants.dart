import 'package:flutter/material.dart';

/// Quản lý toàn bộ hệ thống màu sắc nhận diện thương hiệu FinanceFlow
class AppColors {
  // Màu chủ đạo (Xanh neon từ thiết kế Tailwind)
  static const primary = Color(0xFF13EC6D);

  // Hệ thống màu nền (Background)
  static const backgroundDark = Color(0xFF102218);
  static const backgroundLight = Color(0xFFF6F8F7);

  // Thành phần thẻ và ô nhập liệu (Cards & Inputs)
  static const cardDark = Color(0xFF193324);
  static const inputBgDark = Color(0xFF193324);
  static const borderColor = Color(0xFF326748);

  // Màu chữ bổ trợ (Accent Text)
  static const textMint = Color(0xFF92C9A9);
}

/// Quản lý các kiểu nút bấm để đảm bảo tính nhất quán và sửa lỗi shadowColor
class AppStyles {
  // ✅ ĐÃ SỬA LỖI: Thuộc tính shadowColor được đưa vào trong styleFrom theo đúng chuẩn
  static ButtonStyle primaryButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: AppColors.primary,
    foregroundColor: Colors.black, // Chữ đen trên nền xanh neon
    elevation: 8,
    shadowColor: AppColors.primary.withOpacity(0.4),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    padding: const EdgeInsets.symmetric(vertical: 16),
    textStyle: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      fontFamily: 'Inter',
    ),
  );

  static ButtonStyle secondaryButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: Colors.white.withOpacity(0.1),
    foregroundColor: Colors.white,
    elevation: 0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    padding: const EdgeInsets.symmetric(vertical: 16),
  );
}

/// Quản lý các chuỗi văn bản cố định hoặc thuật ngữ đặc biệt
class AppStrings {
  // Sử dụng "고민" (nỗi lo) thay cho "걱정" theo yêu cầu cá nhân hóa
  static const financialWorryVN = "Giải quyết nỗi lo tài chính";
  static const financialWorryKR = "tài chính 고민 해결";

  static const appName = "DULTH App";
}