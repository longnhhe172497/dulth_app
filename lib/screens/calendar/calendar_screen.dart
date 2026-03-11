import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../constants.dart';
import '../../l10n/app_localizations.dart';
import '../../utils/currency_formatter.dart';

class TransactionCalendarScreen extends StatefulWidget {
  const TransactionCalendarScreen({super.key});

  @override
  State<TransactionCalendarScreen> createState() =>
      _TransactionCalendarScreenState();
}

class _TransactionCalendarScreenState
    extends State<TransactionCalendarScreen> {

  final String uid = FirebaseAuth.instance.currentUser!.uid;

  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {

    final loc = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(

      backgroundColor:
      isDark ? AppColors.backgroundDark : AppColors.backgroundLight,

      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          loc.calendarTitle,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Column(
        children: [

          _monthHeader(loc),

          _weekRow(loc),

          _calendarGrid(isDark),

          Expanded(
            child: _transactionList(isDark, loc),
          ),

        ],
      ),
    );
  }

  /// ===============================
  /// MONTH HEADER
  /// ===============================

  Widget _monthHeader(AppLocalizations loc) {

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: [

          Row(
            children: [

              const Icon(
                Icons.calendar_month,
                color: AppColors.primary,
              ),

              const SizedBox(width: 6),

              Text(
                "${loc.month} ${_focusedDay.month}, ${_focusedDay.year}",
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),

            ],
          ),

          Row(
            children: [

              _iconBtn(Icons.chevron_left, () {

                setState(() {

                  _focusedDay = DateTime(
                      _focusedDay.year,
                      _focusedDay.month - 1);

                });

              }),

              const SizedBox(width: 6),

              _iconBtn(Icons.chevron_right, () {

                setState(() {

                  _focusedDay = DateTime(
                      _focusedDay.year,
                      _focusedDay.month + 1);

                });

              }),

            ],
          )
        ],
      ),
    );
  }

  Widget _iconBtn(IconData icon, VoidCallback onTap) {

    return GestureDetector(

      onTap: onTap,

      child: Container(

        padding: const EdgeInsets.all(6),

        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.2),
          shape: BoxShape.circle,
        ),

        child: Icon(icon, size: 20),
      ),
    );
  }

  /// ===============================
  /// WEEK HEADER
  /// ===============================

  Widget _weekRow(AppLocalizations loc) {

    final days = [
      loc.sun,
      loc.mon,
      loc.tue,
      loc.wed,
      loc.thu,
      loc.fri,
      loc.sat
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,

        children: days.map((d) {

          return Text(
            d,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          );

        }).toList(),
      ),
    );
  }

  /// ===============================
  /// CALENDAR GRID
  /// ===============================

  Widget _calendarGrid(bool isDark) {

    int daysInMonth =
    DateUtils.getDaysInMonth(_focusedDay.year, _focusedDay.month);

    DateTime firstDay =
    DateTime(_focusedDay.year, _focusedDay.month, 1);

    int startWeekday = firstDay.weekday % 7;

    return SizedBox(

      height: 220,

      child: StreamBuilder<QuerySnapshot>(

        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(uid)
            .collection("transactions")
            .where("month", isEqualTo: _focusedDay.month)
            .where("year", isEqualTo: _focusedDay.year)
            .snapshots(),

        builder: (context, snapshot) {

          Map<int, double> dailyTotal = {};
          Set<int> txDays = {};

          if (snapshot.hasData) {

            for (var doc in snapshot.data!.docs) {

              final data = doc.data() as Map<String, dynamic>;

              int day = data["day"];
              double amount = (data["amount"] ?? 0).toDouble();

              txDays.add(day);

              dailyTotal[day] =
                  (dailyTotal[day] ?? 0) + amount;
            }
          }

          return GridView.builder(

            physics: const BouncingScrollPhysics(),

            padding: const EdgeInsets.symmetric(horizontal: 12),

            gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(

              crossAxisCount: 7,

              mainAxisSpacing: 4,
              crossAxisSpacing: 4,

              childAspectRatio: 1,
            ),

            itemCount: daysInMonth + startWeekday,

            itemBuilder: (context, index) {

              if (index < startWeekday) {
                return const SizedBox();
              }

              int day = index - startWeekday + 1;

              DateTime date =
              DateTime(_focusedDay.year, _focusedDay.month, day);

              bool selected =
              DateUtils.isSameDay(date, _selectedDay);

              return GestureDetector(

                onTap: () {

                  setState(() {
                    _selectedDay = date;
                  });

                },

                child: AnimatedContainer(

                  duration: const Duration(milliseconds: 200),

                  decoration: BoxDecoration(

                    color: selected
                        ? AppColors.primary
                        : Colors.transparent,

                    borderRadius: BorderRadius.circular(12),

                    border: Border.all(
                      color: Colors.grey.withOpacity(0.2),
                    ),
                  ),

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,

                    children: [

                      /// DAY NUMBER

                      Text(
                        "$day",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: selected
                              ? Colors.black
                              : (isDark
                              ? Colors.white
                              : Colors.black),
                        ),
                      ),

                      /// TOTAL MONEY

                      if (dailyTotal.containsKey(day))
                        Text(
                          formatVND(dailyTotal[day]!),
                          style: const TextStyle(
                            fontSize: 8,
                            color: Colors.red,
                          ),
                        ),

                      /// DOT

                      if (txDays.contains(day))
                        Container(
                          margin: const EdgeInsets.only(top: 2),
                          width: 4,
                          height: 4,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),

                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  /// ===============================
  /// TRANSACTION LIST
  /// ===============================

  Widget _transactionList(bool isDark, AppLocalizations loc) {

    return Container(

      padding: const EdgeInsets.only(top: 16),

      decoration: BoxDecoration(

        color: isDark
            ? AppColors.cardDark
            : Colors.white,

        borderRadius:
        const BorderRadius.vertical(top: Radius.circular(28)),

      ),

      child: StreamBuilder<QuerySnapshot>(

        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(uid)
            .collection("transactions")
            .where("day", isEqualTo: _selectedDay.day)
            .where("month", isEqualTo: _selectedDay.month)
            .where("year", isEqualTo: _selectedDay.year)
            .orderBy("createdAt", descending: true)
            .snapshots(),

        builder: (context, snapshot) {

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return Center(child: Text(loc.noTransaction));
          }

          return ListView.builder(

            padding: const EdgeInsets.symmetric(horizontal: 16),

            itemCount: docs.length,

            itemBuilder: (context, index) {

              final data =
              docs[index].data() as Map<String, dynamic>;

              return _transactionItem(data, isDark);
            },
          );
        },
      ),
    );
  }

  /// ===============================
  /// TRANSACTION ITEM
  /// ===============================

  Widget _transactionItem(Map<String, dynamic> data, bool isDark) {

    double amount = (data["amount"] ?? 0).toDouble();
    String type = data["type"] ?? "";
    String category = data["category"] ?? "";
    String note = data["note"] ?? "";

    return Container(

      margin: const EdgeInsets.only(bottom: 10),

      padding: const EdgeInsets.all(12),

      decoration: BoxDecoration(

        color: isDark
            ? AppColors.backgroundDark
            : Colors.grey[100],

        borderRadius: BorderRadius.circular(14),
      ),

      child: Row(
        children: [

          Container(
            padding: const EdgeInsets.all(8),

            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),

            child: Icon(
              _iconByCategory(category),
              size: 20,
              color: AppColors.primary,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                Text(
                  category,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold),
                ),

                Text(
                  note,
                  style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey),
                ),

              ],
            ),
          ),

          Text(
            formatVND(amount),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color:
              type == "income"
                  ? Colors.green
                  : Colors.red,
            ),
          )
        ],
      ),
    );
  }

  /// ===============================
  /// CATEGORY ICON
  /// ===============================

  IconData _iconByCategory(String c) {

    switch (c) {

      case "food":
        return Icons.restaurant;

      case "shopping":
        return Icons.shopping_bag;

      case "transport":
        return Icons.directions_bus;

      case "tech":
        return Icons.computer;

      case "bills":
        return Icons.receipt;

      default:
        return Icons.account_balance_wallet;
    }
  }
}