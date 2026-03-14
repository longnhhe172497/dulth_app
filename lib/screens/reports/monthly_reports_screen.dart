import 'package:dulth_app/screens/reports/category_transaction_screen.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

import '../../l10n/app_localizations.dart';

class MonthlyReportsScreen extends StatefulWidget {
  const MonthlyReportsScreen({super.key});

  @override
  State<MonthlyReportsScreen> createState() =>
      _MonthlyReportsScreenState();
}

class _MonthlyReportsScreenState extends State<MonthlyReportsScreen>
    with SingleTickerProviderStateMixin {

  Map<String,double> categoryData = {};

  double income = 0;
  double expense = 0;

  DateTime selectedMonth = DateTime.now();

  @override
  void initState() {
    super.initState();
    loadReport();
  }

  Future<void> loadReport() async {

    final uid = FirebaseAuth.instance.currentUser!.uid;

    final snapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("transactions")
        .where("month", isEqualTo: selectedMonth.month)
        .where("year", isEqualTo: selectedMonth.year)
        .get();

    double newIncome = 0;
    double newExpense = 0;

    Map<String,double> result = {};

    for (var doc in snapshot.docs) {

      final data = doc.data();

      final amount = (data["amount"] as num).toDouble();
      final type = data["type"];
      final category = data["category"] ?? "other";

      if(type == "income"){
        newIncome += amount;
      }else{

        newExpense += amount;

        result[category] =
            (result[category] ?? 0) + amount;

      }

    }

    setState(() {
      income = newIncome;
      expense = newExpense;
      categoryData = result;
    });

  }

  double get balance => income - expense;

  double get totalExpense =>
      categoryData.values.fold(0,(a,b)=>a+b);

  String formatMoney(double value){
    final f = NumberFormat("#,###");
    return "${f.format(value)} ₫";
  }

  String get topCategory {

    if(categoryData.isEmpty) return "-";

    final sorted = categoryData.entries.toList()
      ..sort((a,b)=>b.value.compareTo(a.value));

    return sorted.first.key;

  }

  IconData getCategoryIcon(String category){

    switch(category.toLowerCase()){

      case "food":
        return Icons.restaurant;

      case "transport":
        return Icons.directions_car;

      case "shopping":
        return Icons.shopping_bag;

      case "bills":
        return Icons.receipt;

      case "entertainment":
        return Icons.movie;

      case "tech":
        return Icons.devices;

      default:
        return Icons.category;

    }

  }

  String getCategoryName(String key){

    final lang = AppLocalizations.of(context)!;

    switch(key){

      case "food":
        return lang.food;

      case "shopping":
        return lang.shopping;

      case "transport":
        return lang.transport;

      case "tech":
        return lang.tech;

      default:
        return key;

    }

  }

  @override
  Widget build(BuildContext context) {

    final lang = AppLocalizations.of(context)!;

    return Scaffold(

      appBar: AppBar(
        title: Text(lang.monthlyReport),
        centerTitle: true,
      ),

      body: SingleChildScrollView(

        padding: const EdgeInsets.all(16),

        child: Column(

          children: [

            _buildMonthSelector(),

            const SizedBox(height:20),

            _buildSummaryCards(),

            const SizedBox(height:25),

            _buildPieChart(),

            const SizedBox(height:20),

            _buildTopCategory(),

            const SizedBox(height:20),

            _buildCategoryList(),

          ],

        ),

      ),

    );

  }

  Widget _buildMonthSelector(){

    return Row(

      mainAxisAlignment: MainAxisAlignment.center,

      children: [

        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: (){
            selectedMonth =
                DateTime(selectedMonth.year,
                    selectedMonth.month - 1);
            loadReport();
          },
        ),

        Text(
          "${selectedMonth.month}/${selectedMonth.year}",
          style: const TextStyle(
              fontSize:16,
              fontWeight: FontWeight.bold),
        ),

        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: (){
            selectedMonth =
                DateTime(selectedMonth.year,
                    selectedMonth.month + 1);
            loadReport();
          },
        )

      ],

    );

  }

  Widget _buildSummaryCards(){

    final lang = AppLocalizations.of(context)!;

    return Row(

      children: [

        Expanded(
            child: _buildCard(lang.income, income, Colors.green)),

        const SizedBox(width:10),

        Expanded(
            child: _buildCard(lang.expense, expense, Colors.red)),

        const SizedBox(width:10),

        Expanded(
            child: _buildCard(lang.balance, balance, Colors.blue)),

      ],

    );

  }

  Widget _buildCard(String title,double value,Color color){

    return Container(

      padding: const EdgeInsets.all(14),

      decoration: BoxDecoration(

        color: color.withOpacity(0.15),

        borderRadius: BorderRadius.circular(16),

      ),

      child: Column(

        children: [

          Text(
            title,
            style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold),
          ),

          const SizedBox(height:6),

          Text(
            formatMoney(value),
            style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold),
          )

        ],

      ),

    );

  }

  Widget _buildPieChart(){

    final lang = AppLocalizations.of(context)!;

    if(categoryData.isEmpty){
      return Text(lang.noExpense);
    }

    int i = 0;

    return SizedBox(

      height:250,

      child: PieChart(

        PieChartData(

          centerSpaceRadius:50,

          sections: categoryData.entries.map((e){

            final color =
            Colors.primaries[i %
                Colors.primaries.length];

            final value = e.value;

            i++;

            return PieChartSectionData(

              color: color,

              value: value,

              title:
              "${((value/totalExpense)*100).toStringAsFixed(0)}%",

              radius: 40,

              titleStyle: const TextStyle(
                  fontSize:12,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),

            );

          }).toList(),

        ),

      ),

    );

  }

  Widget _buildTopCategory(){

    final lang = AppLocalizations.of(context)!;

    return Container(

      padding: const EdgeInsets.all(14),

      decoration: BoxDecoration(

        color: Colors.orange.withOpacity(0.2),

        borderRadius: BorderRadius.circular(14),

      ),

      child: Row(

        children: [

          const Icon(Icons.local_fire_department,
              color: Colors.orange),

          const SizedBox(width:10),

          Text(
            "${lang.topCategory}: ${getCategoryName(topCategory)}",
            style: const TextStyle(
                fontWeight: FontWeight.bold),
          ),

        ],

      ),

    );

  }

  Widget _buildCategoryList(){

    final sorted = categoryData.entries.toList()
      ..sort((a,b)=>b.value.compareTo(a.value));

    int i = 0;

    return Column(

      children: sorted.map((e){

        final percent =
        (e.value/totalExpense);

        final color =
        Colors.primaries[i % Colors.primaries.length];

        i++;

        return TweenAnimationBuilder<double>(

          duration: const Duration(milliseconds: 600),

          tween: Tween(begin: 0,end: percent),

          builder: (context,value,child){

            return InkWell(

              onTap: (){

                Navigator.push(

                  context,

                  MaterialPageRoute(

                    builder: (_) =>
                        CategoryTransactionScreen(

                          category: e.key,
                          month: selectedMonth.month,
                          year: selectedMonth.year,

                        ),

                  ),

                );

              },

              child: Container(

                margin: const EdgeInsets.only(bottom:14),

                padding: const EdgeInsets.all(16),

                decoration: BoxDecoration(

                  color: Theme.of(context).cardColor,

                  borderRadius: BorderRadius.circular(18),

                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 6,
                      color: Colors.black12,
                    )
                  ],

                ),

                child: Column(

                  children: [

                    Row(

                      children: [

                        CircleAvatar(

                          backgroundColor:
                          color.withOpacity(0.15),

                          child: Icon(
                            getCategoryIcon(e.key),
                            color: color,
                          ),

                        ),

                        const SizedBox(width:12),

                        Expanded(

                          child: Column(

                            crossAxisAlignment:
                            CrossAxisAlignment.start,

                            children: [

                              Text(
                                getCategoryName(e.key),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize:15),
                              ),

                              const SizedBox(height:3),

                              Text(
                                "${(percent*100).toStringAsFixed(0)}%",
                                style: TextStyle(
                                    fontSize:12,
                                    color: Colors.grey[600]),
                              )

                            ],

                          ),

                        ),

                        Text(
                          formatMoney(e.value),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize:15),
                        )

                      ],

                    ),

                    const SizedBox(height:12),

                    ClipRRect(

                      borderRadius: BorderRadius.circular(10),

                      child: LinearProgressIndicator(

                        value: value,

                        minHeight: 8,

                        backgroundColor: Colors.grey[200],

                        valueColor:
                        AlwaysStoppedAnimation(color),

                      ),

                    )

                  ],

                ),

              ),

            );

          },

        );

      }).toList(),

    );

  }

}