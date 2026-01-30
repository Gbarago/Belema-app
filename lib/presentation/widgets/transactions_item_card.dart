import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_colors.dart';
import '../../domain/entities/transaction.dart';

class TransactionsItemCard extends StatelessWidget {
  final Transaction transaction;

  const TransactionsItemCard({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    // Determine credit/debit mainly for color
    final isCredit = transaction.type.toString().toLowerCase() == 'credit';
    final formatter = NumberFormat.currency(
      symbol: '',
    ); // Remove default symbol

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: AppColors.lightGrey,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.send_outlined,
              color: Colors.black54,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.description,
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: AppColors.textDark,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Transfer', // Static subtitle per design or transaction.type
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    color: AppColors.textGrey,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: isCredit ? '+' : '-',
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: isCredit ? Colors.blue : AppColors.textDark,
                      ),
                    ),
                    TextSpan(
                      text: '₦', // Safe system font
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: isCredit ? Colors.blue : AppColors.textDark,
                      ),
                    ),
                    TextSpan(
                      text: formatter.format(transaction.amount),
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: isCredit ? Colors.blue : AppColors.textDark,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '20 Mins ago', // Mock time or use transaction.date relative time
                style: GoogleFonts.outfit(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
