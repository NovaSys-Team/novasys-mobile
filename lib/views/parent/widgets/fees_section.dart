import 'package:flutter/material.dart';

import '../../../models/parent_models.dart';
import '../../../theme/parent_home_theme.dart';

class FeesSection extends StatelessWidget {
  const FeesSection({super.key, required this.fee, required this.onPay});
  final FeeInfo fee;
  final VoidCallback onPay;

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.symmetric(horizontal: 20),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: ParentHomeTheme.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: ParentHomeTheme.line),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: ParentHomeTheme.mint,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.receipt_long_outlined,
                size: 18,
                color: ParentHomeTheme.teal,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${fee.month} fees',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: ParentHomeTheme.ink,
                    ),
                  ),
                  Text(
                    'Due ${fee.dueDate}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: ParentHomeTheme.muted,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Rs. ${fee.amount.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: ParentHomeTheme.ink,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: fee.isPaid
                        ? const Color(0xFFE6F9EE)
                        : const Color(0xFFFFF4EF),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    fee.isPaid ? 'Paid' : 'Pending',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: fee.isPaid
                          ? ParentHomeTheme.verified
                          : ParentHomeTheme.orange,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 14),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: onPay,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              side: const BorderSide(color: ParentHomeTheme.line),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              fee.isPaid ? 'View payments' : 'Pay now',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: ParentHomeTheme.teal,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
