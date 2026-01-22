import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'constants.dart';
import 'screens/auth/splash_screen.dart';

void main() {
  // Đảm bảo các dịch vụ hệ thống đã sẵn sàng
  WidgetsFlutterBinding.ensureInitialized();

  // Thiết lập màu thanh trạng thái (Status Bar) trong suốt để phù hợp với giao diện hiện đại
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const FinanceFlowApp());
}

class FinanceFlowApp extends StatelessWidget {
  const FinanceFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DULTH App',
      debugShowCheckedModeBanner: false,

      // --- 1. CẤU HÌNH THEME SÁNG (LIGHT MODE) ---
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.backgroundLight,
        fontFamily: 'Inter', // Sử dụng font chữ hiện đại từ Google Fonts
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.light,
          primary: AppColors.primary,
          background: AppColors.backgroundLight,
        ),
        // Cấu hình nút bấm mặc định cho toàn bộ App
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: AppStyles.primaryButtonStyle,
        ),
      ),

      // --- 2. CẤU HÌNH THEME TỐI (DARK MODE) ---
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.backgroundDark,
        fontFamily: 'Inter',
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.dark,
          primary: AppColors.primary,
          surface: AppColors.cardDark,
          background: AppColors.backgroundDark,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: AppStyles.primaryButtonStyle,
        ),
      ),

      // Tự động chuyển đổi giao diện theo cài đặt của hệ thống (điện thoại)
      themeMode: ThemeMode.system,

      // --- 3. ĐIỂM BẮT ĐẦU CỦA ỨNG DỤNG ---
      home: const SplashScreen(),
    );
  }
}