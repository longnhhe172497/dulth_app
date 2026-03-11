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

  static final Map<String, Map<String, String>> _localizedValues = {

    /// ================= ENGLISH =================
    'en': {

      /// Bottom Navigation
      'home': 'Home',
      'calendar': 'Calendar',
      'reports': 'Reports',
      'profile': 'Profile',

      /// Calendar
      'calendarTitle': 'Transaction Calendar',
      'month': 'Month',
      'sun': 'Sun',
      'mon': 'Mon',
      'tue': 'Tue',
      'wed': 'Wed',
      'thu': 'Thu',
      'fri': 'Fri',
      'sat': 'Sat',
      'noTransaction': 'No transactions',

      /// Profile
      'language': 'Language',
      'darkMode': 'Dark Mode',
      'logout': 'Logout',

      /// Account
      'balance': 'Current Balance',
      'account': 'Account',
      'editProfile': 'Edit Profile',

      /// Dashboard
      'hello': 'Hello',
      'totalBalance': 'TOTAL BALANCE',
      'recentTransactions': 'Recent Transactions',
      'categories': 'Categories',
      'addMoney': 'Add Money',
      'withdrawMoney': 'Withdraw',

      /// Transaction Filter
      'all': 'All',
      'income': 'Income',
      'expenses': 'Expenses',

      /// Features
      'financialAdvice': 'Solve your financial worries',
      'topUp': 'Top Up',
      'send': 'Send',

      /// Add Transaction
      'amount': 'Amount',
      'category': 'Category',
      'notes': 'Notes',
      'saveTransaction': 'Save Transaction',
      'addNote': 'Add note...',

      /// Transaction Details
      'transactionDetails': 'Transaction Details',
      'information': 'Information',
      'date': 'Date',
      'type': 'Type',
      'deleteTransaction': 'Delete Transaction',
      'noNotes': 'No notes',

      /// Categories
      'food': 'Food',
      'shopping': 'Shopping',
      'transport': 'Transport',
      'tech': 'Technology',

      /// Warning Dialog
      'insufficientBalance': 'Insufficient Balance',
      'yourBalance': 'Your balance',
      'youTriedToSpend': 'You tried to spend',
      'balanceWarningMessage':
      'You cannot spend more than your available balance.',
      'ok': 'OK',
    },

    /// ================= VIETNAMESE =================
    'vi': {

      /// Bottom Navigation
      'home': 'Trang chủ',
      'calendar': 'Lịch',
      'reports': 'Báo cáo',
      'profile': 'Hồ sơ',

      /// Calendar
      'calendarTitle': 'Lịch giao dịch',
      'month': 'Tháng',
      'sun': 'CN',
      'mon': 'T2',
      'tue': 'T3',
      'wed': 'T4',
      'thu': 'T5',
      'fri': 'T6',
      'sat': 'T7',
      'noTransaction': 'Không có giao dịch',

      /// Profile
      'language': 'Ngôn ngữ',
      'darkMode': 'Chế độ tối',
      'logout': 'Đăng xuất',

      /// Account
      'balance': 'Số dư hiện tại',
      'account': 'Tài khoản',
      'editProfile': 'Chỉnh sửa hồ sơ',

      /// Dashboard
      'hello': 'Xin chào',
      'totalBalance': 'TỔNG SỐ DƯ',
      'recentTransactions': 'Giao dịch gần đây',
      'categories': 'Danh mục',
      'addMoney': 'Nạp tiền',
      'withdrawMoney': 'Rút tiền',

      /// Transaction Filter
      'all': 'Tất cả',
      'income': 'Thu nhập',
      'expenses': 'Chi tiêu',

      /// Features
      'financialAdvice': 'Giải quyết nỗi lo tài chính',
      'topUp': 'Nạp tiền',
      'send': 'Chuyển tiền',

      /// Add Transaction
      'amount': 'Số tiền',
      'category': 'Danh mục',
      'notes': 'Ghi chú',
      'saveTransaction': 'Lưu giao dịch',
      'addNote': 'Thêm ghi chú...',

      /// Transaction Details
      'transactionDetails': 'Chi tiết giao dịch',
      'information': 'Thông tin',
      'date': 'Ngày',
      'type': 'Loại',
      'deleteTransaction': 'Xóa giao dịch',
      'noNotes': 'Không có ghi chú',

      /// Categories
      'food': 'Ăn uống',
      'shopping': 'Mua sắm',
      'transport': 'Di chuyển',
      'tech': 'Công nghệ',

      /// Warning Dialog
      'insufficientBalance': 'Số dư không đủ',
      'yourBalance': 'Số dư của bạn',
      'youTriedToSpend': 'Bạn cố chi',
      'balanceWarningMessage':
      'Bạn không thể chi nhiều hơn số dư hiện có.',
      'ok': 'Đồng ý',
    },
  };

  String _get(String key) {
    return _localizedValues[locale.languageCode]![key]!;
  }

  /// Bottom Navigation
  String get home => _get('home');
  String get calendar => _get('calendar');
  String get reports => _get('reports');
  String get profile => _get('profile');

  /// Calendar
  String get calendarTitle => _get('calendarTitle');
  String get month => _get('month');
  String get sun => _get('sun');
  String get mon => _get('mon');
  String get tue => _get('tue');
  String get wed => _get('wed');
  String get thu => _get('thu');
  String get fri => _get('fri');
  String get sat => _get('sat');
  String get noTransaction => _get('noTransaction');

  /// Profile
  String get language => _get('language');
  String get darkMode => _get('darkMode');
  String get logout => _get('logout');

  /// Account
  String get balance => _get('balance');
  String get account => _get('account');
  String get editProfile => _get('editProfile');

  /// Dashboard
  String get hello => _get('hello');
  String get totalBalance => _get('totalBalance');
  String get recentTransactions => _get('recentTransactions');
  String get categories => _get('categories');
  String get addMoney => _get('addMoney');
  String get withdrawMoney => _get('withdrawMoney');

  /// Transaction Filter
  String get all => _get('all');
  String get income => _get('income');
  String get expenses => _get('expenses');

  /// Features
  String get financialAdvice => _get('financialAdvice');
  String get topUp => _get('topUp');
  String get send => _get('send');

  /// Add Transaction
  String get amount => _get('amount');
  String get category => _get('category');
  String get notes => _get('notes');
  String get saveTransaction => _get('saveTransaction');
  String get addNote => _get('addNote');

  /// Transaction Details
  String get transactionDetails => _get('transactionDetails');
  String get information => _get('information');
  String get date => _get('date');
  String get type => _get('type');
  String get deleteTransaction => _get('deleteTransaction');
  String get noNotes => _get('noNotes');

  /// Categories
  String get food => _get('food');
  String get shopping => _get('shopping');
  String get transport => _get('transport');
  String get tech => _get('tech');

  /// Warning Dialog
  String get insufficientBalance => _get('insufficientBalance');
  String get yourBalance => _get('yourBalance');
  String get youTriedToSpend => _get('youTriedToSpend');
  String get balanceWarningMessage => _get('balanceWarningMessage');
  String get ok => _get('ok');
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