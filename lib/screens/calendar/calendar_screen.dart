import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../constants.dart';
import '../../utils/currency_formatter.dart';
import '../../l10n/app_localizations.dart';

class TransactionCalendarScreen extends StatefulWidget {
  const TransactionCalendarScreen({super.key});

  @override
  State<TransactionCalendarScreen> createState() =>
      _TransactionCalendarScreenState();
}

class _TransactionCalendarScreenState
    extends State<TransactionCalendarScreen> {

  final uid = FirebaseAuth.instance.currentUser!.uid;

  DateTime focusedDay = DateTime.now();
  DateTime selectedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {

    final loc = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(

      backgroundColor:
      isDark ? AppColors.backgroundDark : AppColors.backgroundLight,

      appBar: AppBar(
        title: Text(loc.calendarTitle),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),

      body: Column(
        children: [

          _monthHeader(loc),

          const SizedBox(height: 10),

          _weekRow(loc),

          const SizedBox(height: 6),

          Expanded(
            child: StreamBuilder<QuerySnapshot>(

              stream: _monthStream(),

              builder: (context, snapshot) {

                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final docs = snapshot.data!.docs;

                Map<int,double> incomeTotal = {};
                Map<int,double> expenseTotal = {};
                Map<int,List<Map<String,dynamic>>> dailyTx = {};

                double monthIncome = 0;
                double monthExpense = 0;

                for(var d in docs){

                  final data = d.data() as Map<String,dynamic>;

                  final date =
                  (data["createdAt"] as Timestamp).toDate();

                  int day = date.day;

                  double amount = (data["amount"] ?? 0).toDouble();
                  String type = data["type"];

                  dailyTx.putIfAbsent(day, ()=>[]).add(data);

                  if(type == "income"){

                    monthIncome += amount;
                    incomeTotal[day] =
                        (incomeTotal[day] ?? 0) + amount;

                  }else{

                    monthExpense += amount;
                    expenseTotal[day] =
                        (expenseTotal[day] ?? 0) + amount;

                  }
                }

                return Column(
                  children: [

                    _monthSummary(loc,monthIncome,monthExpense),

                    _miniChart(monthIncome,monthExpense),

                    const SizedBox(height:10),

                    _calendarGrid(
                        incomeTotal,
                        expenseTotal,
                        dailyTx,
                        isDark
                    ),

                    Expanded(
                      child: _transactionList(loc,dailyTx),
                    )
                  ],
                );
              },
            ),
          )
        ],
      ),
    );
  }

  /// ==============================
  /// FIRESTORE QUERY (FAST)
  /// ==============================

  Stream<QuerySnapshot> _monthStream(){

    DateTime firstDay =
    DateTime(focusedDay.year,focusedDay.month,1);

    DateTime nextMonth =
    DateTime(focusedDay.year,focusedDay.month+1,1);

    return FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("transactions")
        .where("createdAt",isGreaterThanOrEqualTo:firstDay)
        .where("createdAt",isLessThan:nextMonth)
        .snapshots();
  }

  /// ==============================
  /// MONTH HEADER
  /// ==============================

  Widget _monthHeader(AppLocalizations loc){

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal:16),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: [

          Text(
            "${loc.month} ${focusedDay.month}, ${focusedDay.year}",
            style: const TextStyle(
                fontSize:20,
                fontWeight:FontWeight.bold),
          ),

          Row(
            children: [

              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: (){
                  setState(() {
                    focusedDay =
                        DateTime(focusedDay.year,focusedDay.month-1);
                  });
                },
              ),

              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: (){
                  setState(() {
                    focusedDay =
                        DateTime(focusedDay.year,focusedDay.month+1);
                  });
                },
              ),
            ],
          )
        ],
      ),
    );
  }

  /// ==============================
  /// WEEK ROW
  /// ==============================

  Widget _weekRow(AppLocalizations loc){

    final days = [
      loc.sun,
      loc.mon,
      loc.tue,
      loc.wed,
      loc.thu,
      loc.fri,
      loc.sat
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: days.map((d)=>Text(
        d,
        style: const TextStyle(
            fontWeight:FontWeight.bold,
            color:Colors.grey),
      )).toList(),
    );
  }

  /// ==============================
  /// MONTH SUMMARY
  /// ==============================

  Widget _monthSummary(
      AppLocalizations loc,
      double income,
      double expense){

    return Padding(
      padding: const EdgeInsets.all(12),

      child: Row(

        mainAxisAlignment: MainAxisAlignment.spaceEvenly,

        children: [

          _summaryCard(
              loc.income,
              income,
              Colors.green
          ),

          _summaryCard(
              loc.expenses,
              expense,
              Colors.red
          ),
        ],
      ),
    );
  }

  Widget _summaryCard(String title,double amount,Color color){

    return Container(

      width:150,

      padding: const EdgeInsets.all(12),

      decoration: BoxDecoration(

        color: color.withOpacity(0.1),

        borderRadius: BorderRadius.circular(14),
      ),

      child: Column(
        children: [

          Text(title,
              style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold)),

          const SizedBox(height:4),

          Text(
            formatVND(amount),
            style: TextStyle(
                fontSize:16,
                color: color,
                fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }

  /// ==============================
  /// MINI CHART
  /// ==============================

  Widget _miniChart(double income,double expense){

    double total = income + expense;

    double incomePercent =
    total==0?0:income/total;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal:20),

      child: LinearProgressIndicator(

        value: incomePercent,

        minHeight: 10,

        backgroundColor: Colors.red.withOpacity(0.3),

        valueColor:
        const AlwaysStoppedAnimation(Colors.green),
      ),
    );
  }

  /// ==============================
  /// CALENDAR GRID
  /// ==============================

  Widget _calendarGrid(
      Map<int,double> income,
      Map<int,double> expense,
      Map<int,List<Map<String,dynamic>>> dailyTx,
      bool isDark
      ){

    int daysInMonth =
    DateUtils.getDaysInMonth(focusedDay.year,focusedDay.month);

    DateTime firstDay =
    DateTime(focusedDay.year,focusedDay.month,1);

    int startWeekday = firstDay.weekday % 7;

    return SizedBox(

      height:240,

      child: GridView.builder(

        padding: const EdgeInsets.all(10),

        gridDelegate:
        const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount:7,
            mainAxisSpacing:6,
            crossAxisSpacing:6
        ),

        itemCount: daysInMonth + startWeekday,

        itemBuilder: (context,index){

          if(index < startWeekday){
            return const SizedBox();
          }

          int day = index - startWeekday + 1;

          DateTime date =
          DateTime(focusedDay.year,focusedDay.month,day);

          bool selected =
          DateUtils.isSameDay(date,selectedDay);

          return GestureDetector(

            onTap: (){
              setState(() {
                selectedDay = date;
              });
            },

            child: Container(

              padding: const EdgeInsets.all(4),

              decoration: BoxDecoration(

                color: selected
                    ? AppColors.primary
                    : (isDark
                    ? Colors.grey[900]
                    : Colors.white),

                borderRadius: BorderRadius.circular(12),

                boxShadow:[
                  BoxShadow(
                      color:Colors.black.withOpacity(0.05),
                      blurRadius:4)
                ],
              ),

              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  Text("$day",
                      style: const TextStyle(
                          fontWeight:FontWeight.bold)),

                  if(income.containsKey(day))
                    Text(
                      "+${formatVND(income[day]!)}",
                      style: const TextStyle(
                          fontSize:8,
                          color:Colors.green),
                    ),

                  if(expense.containsKey(day))
                    Text(
                      "-${formatVND(expense[day]!)}",
                      style: const TextStyle(
                          fontSize:8,
                          color:Colors.red),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// ==============================
  /// TRANSACTION LIST
  /// ==============================

  Widget _transactionList(
      AppLocalizations loc,
      Map<int,List<Map<String,dynamic>>> dailyTx){

    int day = selectedDay.day;

    if(!dailyTx.containsKey(day)){
      return Center(
          child: Text(loc.noTransaction));
    }

    final list = dailyTx[day]!;

    return ListView.builder(

      itemCount: list.length,

      itemBuilder:(context,index){

        final data = list[index];

        return ListTile(

          leading: CircleAvatar(
            backgroundColor:
            _categoryColor(data["category"]),
            child: Icon(
                _categoryIcon(data["category"]),
                color:Colors.white),
          ),

          title: Text(data["category"]),

          subtitle: Text(data["note"] ?? ""),

          trailing: Text(
            formatVND(data["amount"]),
            style: TextStyle(
                color: data["type"]=="income"
                    ? Colors.green
                    : Colors.red,
                fontWeight: FontWeight.bold),
          ),
        );
      },
    );
  }

  /// ==============================
  /// CATEGORY ICON
  /// ==============================

  IconData _categoryIcon(String c){

    switch(c){

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
        return Icons.wallet;
    }
  }

  /// CATEGORY COLOR

  Color _categoryColor(String c){

    switch(c){

      case "food":
        return Colors.orange;

      case "shopping":
        return Colors.purple;

      case "transport":
        return Colors.blue;

      case "tech":
        return Colors.teal;

      case "bills":
        return Colors.red;

      default:
        return Colors.grey;
    }
  }
}