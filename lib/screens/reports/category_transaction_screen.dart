import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

import '../../constants.dart';
import '../../l10n/app_localizations.dart';

class CategoryTransactionScreen extends StatelessWidget {

  final String category;
  final int month;
  final int year;

  const CategoryTransactionScreen({
    super.key,
    required this.category,
    required this.month,
    required this.year,
  });

  @override
  Widget build(BuildContext context) {

    final lang = AppLocalizations.of(context)!;
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(

      appBar: AppBar(
        title: Text("$category - $month/$year"),
        centerTitle: true,
      ),

      body: StreamBuilder<QuerySnapshot>(

        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(uid)
            .collection("transactions")
            .where("category", isEqualTo: category)
            .where("month", isEqualTo: month)
            .where("year", isEqualTo: year)
            .orderBy("date", descending: true)
            .snapshots(),

        builder: (context, snapshot) {

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return Center(child: Text(lang.noTransaction));
          }

          return ListView.builder(

            padding: const EdgeInsets.all(16),

            itemCount: docs.length,

            itemBuilder: (context, index) {

              final data =
              docs[index].data() as Map<String, dynamic>;

              final amount =
              (data["amount"] as num).toDouble();

              final note = data["note"] ?? "";

              final type = data["type"];

              final timestamp = data["date"] as Timestamp?;

              final date = timestamp != null
                  ? DateFormat("dd/MM/yyyy")
                  .format(timestamp.toDate())
                  : "";

              final color =
              type == "income"
                  ? Colors.green
                  : Colors.red;

              return Container(

                margin: const EdgeInsets.only(bottom: 12),

                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 6,
                      color: Colors.black12,
                    )
                  ],
                ),

                child: ListTile(

                  leading: CircleAvatar(

                    radius: 24,

                    backgroundColor:
                    _getCategoryColor(category)
                        .withOpacity(0.15),

                    child: Icon(
                      _getCategoryIcon(category),
                      color: _getCategoryColor(category),
                    ),
                  ),

                  title: Text(
                    note.isEmpty ? category : note,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold),
                  ),

                  subtitle: Text(date),

                  trailing: Text(

                    NumberFormat("#,###")
                        .format(amount) +
                        " ₫",

                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: color,
                      fontSize: 15,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  IconData _getCategoryIcon(String category) {

    switch (category.toLowerCase()) {

      case "food":
        return Icons.restaurant;

      case "transport":
        return Icons.directions_car;

      case "shopping":
        return Icons.shopping_bag;

      case "entertainment":
        return Icons.movie;

      case "health":
        return Icons.favorite;

      case "bills":
        return Icons.receipt;

      default:
        return Icons.category;
    }
  }

  Color _getCategoryColor(String category) {

    switch (category.toLowerCase()) {

      case "food":
        return Colors.orange;

      case "transport":
        return Colors.blue;

      case "shopping":
        return Colors.purple;

      case "entertainment":
        return Colors.red;

      case "health":
        return Colors.pink;

      case "bills":
        return Colors.teal;

      default:
        return Colors.grey;
    }
  }
}