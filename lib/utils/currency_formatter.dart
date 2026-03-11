import 'package:intl/intl.dart';

String formatVND(double amount) {
  final format = NumberFormat.currency(
    locale: 'vi_VN',
    symbol: '₫',
    decimalDigits: 0,
  );

  return format.format(amount);
}