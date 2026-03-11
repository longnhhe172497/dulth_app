import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'firebase_options.dart';
import 'constants.dart';

import 'screens/auth/splash_screen.dart';
import 'screens/auth/login_screen.dart';
import 'main_screen_host.dart';

import 'l10n/app_localizations.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const FinanceFlowApp());
}

class FinanceFlowApp extends StatefulWidget {
  const FinanceFlowApp({super.key});

  @override
  State<FinanceFlowApp> createState() => _FinanceFlowAppState();
}

class _FinanceFlowAppState extends State<FinanceFlowApp> {

  ThemeMode _themeMode = ThemeMode.light;
  Locale _locale = const Locale('en');

  Stream<DocumentSnapshot>? _userStream;

  @override
  void initState() {
    super.initState();
    _listenAuth();
  }

  void _listenAuth() {

    FirebaseAuth.instance.authStateChanges().listen((user) {

      if (user == null) {

        // reset khi logout
        setState(() {
          _themeMode = ThemeMode.light;
          _locale = const Locale('en');
        });

      } else {

        // lắng nghe document user
        _userStream = FirebaseFirestore.instance
            .collection("users")
            .doc(user.uid)
            .snapshots();

        _userStream!.listen((doc) {

          if (!doc.exists) return;

          final data = doc.data() as Map<String, dynamic>;

          final bool darkMode = data["darkMode"] ?? false;
          final String language = data["language"] ?? "en";

          if (!mounted) return;

          setState(() {

            _themeMode = darkMode ? ThemeMode.dark : ThemeMode.light;
            _locale = Locale(language);

          });

        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(

      title: 'DULTH App',
      debugShowCheckedModeBanner: false,

      // LANGUAGE
      locale: _locale,

      supportedLocales: AppLocalizations.supportedLocales,

      localizationsDelegates: const [

        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,

      ],

      // LIGHT THEME
      theme: ThemeData(

        useMaterial3: true,
        brightness: Brightness.light,
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.backgroundLight,
        fontFamily: 'Inter',

        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.light,
        ),

      ),

      // DARK THEME
      darkTheme: ThemeData(

        useMaterial3: true,
        brightness: Brightness.dark,
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.backgroundDark,
        fontFamily: 'Inter',

        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.dark,
        ),

      ),

      themeMode: _themeMode,

      home: const AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatelessWidget {

  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {

    return StreamBuilder<User?>(

      stream: FirebaseAuth.instance.authStateChanges(),

      builder: (context, snapshot) {

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SplashScreen();
        }

        if (snapshot.hasData) {
          return const MainScreenHost();
        }

        return const LoginScreen();

      },
    );
  }
}