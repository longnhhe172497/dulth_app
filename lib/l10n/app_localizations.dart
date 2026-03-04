import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(
      context,
      AppLocalizations,
    )!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
  _AppLocalizationsDelegate();

  static const supportedLocales = [
    Locale('en'),
    Locale('vi'),
  ];

  static final _localizedValues = {
    'en': {
      'profile': 'Profile',
      'language': 'Language',
      'darkMode': 'Dark Mode',
      'logout': 'Logout',
    },
    'vi': {
      'profile': 'Hồ sơ',
      'language': 'Ngôn ngữ',
      'darkMode': 'Chế độ tối',
      'logout': 'Đăng xuất',
    },
  };

  String get profile =>
      _localizedValues[locale.languageCode]!['profile']!;

  String get language =>
      _localizedValues[locale.languageCode]!['language']!;

  String get darkMode =>
      _localizedValues[locale.languageCode]!['darkMode']!;

  String get logout =>
      _localizedValues[locale.languageCode]!['logout']!;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      ['en', 'vi'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_) => false;
}