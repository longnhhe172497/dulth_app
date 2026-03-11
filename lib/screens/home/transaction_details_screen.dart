import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../constants.dart';
import '../../l10n/app_localizations.dart';

class TransactionDetailsScreen extends StatelessWidget {
  final String transactionId;
  final Map<String, dynamic> data;

  const TransactionDetailsScreen({
    super.key,
    required this.transactionId,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final amount = (data["amount"] ?? 0).toDouble();
    final category = data["category"] ?? "";
    final note = data["note"] ?? "";
    final type = data["type"] ?? "expense";
    final date = (data["date"] as Timestamp?)?.toDate();

    return Scaffold(
      backgroundColor: isDarkMode
          ? AppColors.backgroundDark
          : AppColors.backgroundLight,
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                const SizedBox(height: 100),

                /// Amount header
                _buildAmountHeader(amount, category, type),

                /// Info
                _buildSectionLabel(loc.information, isDarkMode),
                _buildInfoCard(loc, isDarkMode, date, type),

                /// Notes
                _buildSectionLabel(loc.notes, isDarkMode),
                _buildNotesCard(note, loc, isDarkMode),

                const SizedBox(height: 30),

                /// Delete
                _buildDeleteButton(context, loc),

                const SizedBox(height: 120),
              ],
            ),
          ),

          /// TopBar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _buildTopBar(context, isDarkMode, loc),
          )
        ],
      ),
    );
  }

  /// TOP BAR
  Widget _buildTopBar(
      BuildContext context,
      bool isDarkMode,
      AppLocalizations loc,
      ) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 48, 16, 12),
          color: (isDarkMode
              ? AppColors.backgroundDark
              : AppColors.backgroundLight)
              .withOpacity(0.9),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios, size: 20),
                onPressed: () => Navigator.pop(context),
              ),
              Text(
                loc.transactionDetails,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 40)
            ],
          ),
        ),
      ),
    );
  }

  /// HEADER
  Widget _buildAmountHeader(
      double amount,
      String category,
      String type,
      ) {
    final icon = _getCategoryIcon(category);

    return Column(
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: AppColors.primary,
            size: 36,
          ),
        ),

        const SizedBox(height: 16),

        Text(
          "${type == "expense" ? "-" : "+"} ₫${amount.toStringAsFixed(0)}",
          style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 6),

        Text(
          category,
          style: const TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
              fontSize: 14),
        ),

        const SizedBox(height: 32),
      ],
    );
  }

  /// SECTION LABEL
  Widget _buildSectionLabel(String label, bool isDarkMode) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(4, 16, 4, 8),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          color: isDarkMode
              ? AppColors.textMint
              : Colors.grey,
          fontSize: 11,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  /// INFO CARD
  Widget _buildInfoCard(
      AppLocalizations loc,
      bool isDarkMode,
      DateTime? date,
      String type,
      ) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode
            ? AppColors.cardDark
            : Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _buildInfoRow(
              loc.date,
              date != null
                  ? "${date.day}/${date.month}/${date.year}"
                  : "",
              isDarkMode
          ),
          _buildInfoRow(
              loc.type,
              type == "expense"
                  ? loc.expenses
                  : loc.income,
              isDarkMode,
              isLast: true
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
      String label,
      String value,
      bool isDarkMode,
      {bool isLast = false}) {

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(
          bottom: BorderSide(
            color: isDarkMode
                ? Colors.white10
                : Colors.black12,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment:
        MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(
                  color: Colors.grey)),
          Text(
            value,
            style: const TextStyle(
                fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }

  /// NOTES
  Widget _buildNotesCard(
      String note,
      AppLocalizations loc,
      bool isDarkMode
      ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode
            ? AppColors.cardDark
            : Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        note.isEmpty ? loc.noNotes : note,
        style: const TextStyle(fontSize: 14),
      ),
    );
  }

  /// DELETE
  Widget _buildDeleteButton(
      BuildContext context,
      AppLocalizations loc
      ) {
    return SizedBox(
      width: double.infinity,
      child: TextButton.icon(
        icon: const Icon(Icons.delete, color: Colors.red),
        label: Text(
          loc.deleteTransaction,
          style: const TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold),
        ),
        style: TextButton.styleFrom(
          backgroundColor: Colors.red.withOpacity(0.1),
          padding: const EdgeInsets.symmetric(
              vertical: 16),
        ),
        onPressed: () async {

          final uid =
              FirebaseAuth.instance.currentUser!.uid;

          await FirebaseFirestore.instance
              .collection("users")
              .doc(uid)
              .collection("transactions")
              .doc(transactionId)
              .delete();

          Navigator.pop(context);
        },
      ),
    );
  }

  /// CATEGORY ICON
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
}