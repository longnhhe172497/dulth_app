import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get _uid => _auth.currentUser!.uid;

  // ================= USER =================

  Future<void> createUserProfile({
    required String fullName,
    required String email,
  }) async {
    await _db.collection('users').doc(_uid).set({
      'fullName': fullName,
      'email': email,
      'balance': 0,
      'currency': 'VND',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<DocumentSnapshot> getUserProfile() async {
    return await _db.collection('users').doc(_uid).get();
  }

  Future<void> updateBalance(double newBalance) async {
    await _db.collection('users').doc(_uid).update({
      'balance': newBalance,
    });
  }

  // ================= TRANSACTIONS =================

  Future<void> addTransaction({
    required double amount,
    required String type, // income / expense
    required String category,
    String? note,
  }) async {
    await _db
        .collection('users')
        .doc(_uid)
        .collection('transactions')
        .add({
      'amount': amount,
      'type': type,
      'category': category,
      'note': note ?? '',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<QuerySnapshot> getTransactions() {
    return _db
        .collection('users')
        .doc(_uid)
        .collection('transactions')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Future<void> deleteTransaction(String transactionId) async {
    await _db
        .collection('users')
        .doc(_uid)
        .collection('transactions')
        .doc(transactionId)
        .delete();
  }
}