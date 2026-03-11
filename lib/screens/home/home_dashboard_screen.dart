import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../constants.dart';
import '../../l10n/app_localizations.dart';
import 'transaction_details_screen.dart';

class HomeDashboardScreen extends StatelessWidget {
  const HomeDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final loc = AppLocalizations.of(context);
    final user = FirebaseAuth.instance.currentUser!;
    final uid = user.uid;

    final bool isDarkMode =
        Theme.of(context).brightness == Brightness.dark;

    return Scaffold(

      backgroundColor: isDarkMode
          ? AppColors.backgroundDark
          : AppColors.backgroundLight,

      body: Stack(
        children: [

          CustomScrollView(
            slivers: [

              const SliverToBoxAdapter(
                child: SizedBox(height: 110),
              ),

              /// BALANCE
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverToBoxAdapter(
                  child: _buildBalance(context, uid, loc),
                ),
              ),

              const SliverToBoxAdapter(
                child: SizedBox(height: 20),
              ),

              /// INCOME / EXPENSE
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverToBoxAdapter(
                  child: _buildStats(uid, loc, isDarkMode),
                ),
              ),

              const SliverToBoxAdapter(
                child: SizedBox(height: 24),
              ),

              /// TITLE
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverToBoxAdapter(
                  child: Text(
                    loc.recentTransactions,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                ),
              ),

              /// TRANSACTIONS
              _buildTransactions(uid),

              const SliverToBoxAdapter(
                child: SizedBox(height: 120),
              ),
            ],
          ),

          /// TOP BAR
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _buildTopBar(context, uid, loc),
          ),
        ],
      ),
    );
  }

  /// TOP BAR
  Widget _buildTopBar(
      BuildContext context,
      String uid,
      AppLocalizations loc) {

    bool isDarkMode =
        Theme.of(context).brightness == Brightness.dark;

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .snapshots(),
      builder: (context, snapshot) {

        if (!snapshot.hasData) {
          return const SizedBox();
        }

        final data =
        snapshot.data!.data() as Map<String, dynamic>;

        final fullName = data["fullName"] ?? "User";
        final avatar =
            data["avatar"] ?? "https://i.pravatar.cc/150";

        return ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(
                sigmaX: 10,
                sigmaY: 10),
            child: Container(
              padding:
              const EdgeInsets.fromLTRB(16, 48, 16, 12),

              color: (isDarkMode
                  ? AppColors.backgroundDark
                  : AppColors.backgroundLight)
                  .withOpacity(0.9),

              child: Row(
                children: [

                  CircleAvatar(
                    radius: 20,
                    backgroundImage:
                    NetworkImage(avatar),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [

                        Text(
                          loc.hello,
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textMint,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        Text(
                          fullName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Icon(Icons.notifications)
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// BALANCE
  Widget _buildBalance(
      BuildContext context,
      String uid,
      AppLocalizations loc) {

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .snapshots(),

      builder: (context, snapshot) {

        if (!snapshot.hasData) {
          return const SizedBox();
        }

        final data =
        snapshot.data!.data() as Map<String, dynamic>;

        final balance = data["balance"] ?? 0;
        final currency = data["currency"] ?? "VND";

        return Container(

          padding: const EdgeInsets.all(24),

          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: const LinearGradient(
              colors: [
                AppColors.cardDark,
                Color(0xFF112218),
              ],
            ),
          ),

          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,

            children: [

              Text(
                loc.totalBalance,
                style: const TextStyle(
                  color: AppColors.textMint,
                  fontSize: 12,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                "$balance $currency",
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),

              Row(
                children: [

                  /// ADD MONEY
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.add),
                      label: Text(loc.addMoney),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        _showAddMoneyDialog(context, uid);
                      },
                    ),
                  ),

                  const SizedBox(width: 12),

                  /// WITHDRAW
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.remove),
                      label: Text(loc.withdrawMoney),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        _showWithdrawDialog(context, uid);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  /// INCOME / EXPENSE
  Widget _buildStats(
      String uid,
      AppLocalizations loc,
      bool isDarkMode) {

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .collection("transactions")
          .snapshots(),

      builder: (context, snapshot) {

        double income = 0;
        double expense = 0;

        if (snapshot.hasData) {

          for (var doc in snapshot.data!.docs) {

            final data =
            doc.data() as Map<String, dynamic>;

            final amount =
            (data["amount"] ?? 0).toDouble();

            final type =
            (data["type"] ?? "").toString();

            if (type == "income") {
              income += amount;
            } else {
              expense += amount;
            }
          }
        }

        return Row(
          children: [

            Expanded(
              child: _statCard(
                  loc.income,
                  income,
                  Colors.green,
                  isDarkMode),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: _statCard(
                  loc.expenses,
                  expense,
                  Colors.red,
                  isDarkMode),
            ),
          ],
        );
      },
    );
  }

  Widget _statCard(
      String title,
      double amount,
      Color color,
      bool isDarkMode) {

    return Container(

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: isDarkMode
            ? AppColors.cardDark
            : Colors.white,

        borderRadius: BorderRadius.circular(16),
      ),

      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [

          Text(title),

          const SizedBox(height: 6),

          Text(
            "₫${amount.toStringAsFixed(0)}",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color),
          ),
        ],
      ),
    );
  }

  /// TRANSACTIONS
  Widget _buildTransactions(String uid) {

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .collection("transactions")
          .orderBy("date", descending: true)
          .snapshots(),

      builder: (context, snapshot) {

        if (!snapshot.hasData) {
          return const SliverToBoxAdapter(
            child: Center(
                child: CircularProgressIndicator()),
          );
        }

        final docs = snapshot.data!.docs;

        return SliverList(
          delegate: SliverChildBuilderDelegate(
                (context, index) {

              final data =
              docs[index].data()
              as Map<String, dynamic>;

              final amount =
              (data["amount"] ?? 0).toDouble();

              final type =
              (data["type"] ?? "").toString();

              return ListTile(

                leading: CircleAvatar(
                  backgroundColor:
                  Colors.green.withOpacity(0.15),

                  child: Icon(
                    _getCategoryIcon(
                        data["category"]),
                    color: Colors.green,
                  ),
                ),

                title: Text(data["category"] ?? ""),

                subtitle: Text(data["note"] ?? ""),

                trailing: Text(
                  "₫${amount.toStringAsFixed(0)}",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: type == "income"
                          ? Colors.green
                          : Colors.red),
                ),

                onTap: () {

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          TransactionDetailsScreen(
                            transactionId:
                            docs[index].id,
                            data: data,
                          ),
                    ),
                  );
                },
              );
            },

            childCount: docs.length,
          ),
        );
      },
    );
  }

  IconData _getCategoryIcon(String? category) {

    switch (category) {

      case "Food":
      case "Ăn uống":
        return Icons.restaurant;

      case "Shopping":
      case "Mua sắm":
        return Icons.shopping_bag;

      case "Transport":
      case "Di chuyển":
        return Icons.directions_car;

      case "Tech":
      case "Công nghệ":
        return Icons.computer;

      default:
        return Icons.category;
    }
  }

  /// ADD MONEY
  void _showAddMoneyDialog(
      BuildContext context,
      String uid) {

    final controller = TextEditingController();

    showDialog(
      context: context,

      builder: (context) {

        return AlertDialog(

          title: const Text("Nạp tiền"),

          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
                hintText: "Nhập số tiền"),
          ),

          actions: [

            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Hủy"),
            ),

            ElevatedButton(
              onPressed: () async {

                final amount =
                    double.tryParse(
                        controller.text) ??
                        0;

                final doc =
                await FirebaseFirestore
                    .instance
                    .collection("users")
                    .doc(uid)
                    .get();

                final data =
                doc.data()
                as Map<String, dynamic>;

                final currentBalance =
                (data["balance"] ?? 0)
                    .toDouble();

                await FirebaseFirestore
                    .instance
                    .collection("users")
                    .doc(uid)
                    .update({
                  "balance":
                  currentBalance + amount
                });

                Navigator.pop(context);
              },
              child: const Text("Xác nhận"),
            )
          ],
        );
      },
    );
  }

  /// WITHDRAW
  void _showWithdrawDialog(
      BuildContext context,
      String uid) {

    final controller = TextEditingController();

    showDialog(
      context: context,

      builder: (context) {

        return AlertDialog(

          title: const Text("Rút tiền"),

          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
                hintText: "Nhập số tiền"),
          ),

          actions: [

            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Hủy"),
            ),

            ElevatedButton(
              onPressed: () async {

                final amount =
                    double.tryParse(
                        controller.text) ??
                        0;

                final doc =
                await FirebaseFirestore
                    .instance
                    .collection("users")
                    .doc(uid)
                    .get();

                final data =
                doc.data()
                as Map<String, dynamic>;

                final currentBalance =
                (data["balance"] ?? 0)
                    .toDouble();

                await FirebaseFirestore
                    .instance
                    .collection("users")
                    .doc(uid)
                    .update({
                  "balance":
                  currentBalance - amount
                });

                Navigator.pop(context);
              },
              child: const Text("Xác nhận"),
            )
          ],
        );
      },
    );
  }
}