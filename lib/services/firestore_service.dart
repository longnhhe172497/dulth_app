import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  String get uid => FirebaseAuth.instance.currentUser!.uid;

  // ===============================
  // CREATE USER PROFILE
  // ===============================

  Future<void> createUserProfile({
    required String fullName,
    required String email,
  }) async {

    await _db.collection("users").doc(uid).set({

      "fullName": fullName,
      "email": email,
      "balance": 0.0,
      "language": "en",
      "darkMode": false,
      "createdAt": FieldValue.serverTimestamp(),

    });
  }

  // ===============================
  // USER PROFILE STREAM
  // ===============================

  Stream<DocumentSnapshot> getUserProfile() {

    return _db
        .collection("users")
        .doc(uid)
        .snapshots();
  }

  // ===============================
  // ADD TRANSACTION
  // ===============================

  Future<void> addTransaction({
    required double amount,
    required String category,
    required String type,
    String? note,
    DateTime? date,
  }) async {

    final selectedDate = date ?? DateTime.now();

    final ref = _db
        .collection("users")
        .doc(uid)
        .collection("transactions")
        .doc();

    await ref.set({

      "amount": amount,

      "category": category,

      "type": type,

      "note": note ?? "",

      "date": Timestamp.fromDate(selectedDate),

      "day": selectedDate.day,
      "month": selectedDate.month,
      "year": selectedDate.year,

      "createdAt": FieldValue.serverTimestamp(),

    });

    await _updateBalance(amount, type);
  }

  // ===============================
  // UPDATE BALANCE
  // ===============================

  Future<void> _updateBalance(
      double amount,
      String type,
      ) async {

    final userRef = _db.collection("users").doc(uid);

    await _db.runTransaction((transaction) async {

      final snapshot = await transaction.get(userRef);

      double balance =
      (snapshot.data()?["balance"] ?? 0).toDouble();

      if (type == "income") {
        balance += amount;
      } else {
        balance -= amount;
      }

      transaction.update(userRef, {
        "balance": balance
      });

    });
  }

  // ===============================
  // STREAM ALL TRANSACTIONS
  // ===============================

  Stream<QuerySnapshot> getTransactions() {

    return _db
        .collection("users")
        .doc(uid)
        .collection("transactions")
        .orderBy("date", descending: true)
        .snapshots();
  }

  // ===============================
  // TRANSACTION BY DATE
  // ===============================

  Stream<QuerySnapshot> getTransactionsByDate(DateTime date) {

    return _db
        .collection("users")
        .doc(uid)
        .collection("transactions")
        .where("day", isEqualTo: date.day)
        .where("month", isEqualTo: date.month)
        .where("year", isEqualTo: date.year)
        .orderBy("createdAt", descending: true)
        .snapshots();
  }

  // ===============================
  // TRANSACTION BY MONTH (CALENDAR)
  // ===============================

  Stream<QuerySnapshot> getTransactionsByMonth({
    required int month,
    required int year,
  }) {

    return _db
        .collection("users")
        .doc(uid)
        .collection("transactions")
        .where("month", isEqualTo: month)
        .where("year", isEqualTo: year)
        .snapshots();
  }

  // ===============================
  // DELETE TRANSACTION
  // ===============================

  Future<void> deleteTransaction({
    required String id,
    required double amount,
    required String type,
  }) async {

    final ref = _db
        .collection("users")
        .doc(uid)
        .collection("transactions")
        .doc(id);

    await ref.delete();

    // revert balance
    if (type == "income") {
      await _updateBalance(amount, "expense");
    } else {
      await _updateBalance(amount, "income");
    }
  }

}