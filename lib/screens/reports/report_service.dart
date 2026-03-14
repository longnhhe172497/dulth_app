import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReportService {

  final _db = FirebaseFirestore.instance;

  Future<Map<String,double>> getMonthlyCategoryExpense(DateTime month) async {

    final uid = FirebaseAuth.instance.currentUser!.uid;

    final start = DateTime(month.year, month.month, 1);
    final end = DateTime(month.year, month.month + 1, 1);

    final snapshot = await _db
        .collection("transactions")
        .where("userId", isEqualTo: uid)
        .where("type", isEqualTo: "expense")
        .where("date", isGreaterThanOrEqualTo: start)
        .where("date", isLessThan: end)
        .get();

    Map<String,double> result = {};

    for (var doc in snapshot.docs) {

      final data = doc.data();

      final category = data["category"];
      final amount = (data["amount"] as num).toDouble();

      result[category] = (result[category] ?? 0) + amount;
    }

    return result;
  }
}