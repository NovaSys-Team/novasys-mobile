import 'package:flutter/material.dart';

import '../../../models/parent_payment.dart';
import '../../../theme/parent_home_theme.dart';
import 'payment_widgets.dart';

class PaymentResultView extends StatelessWidget {
  const PaymentResultView({super.key, required this.receipt});
  final DemoReceipt? receipt;
  @override
  Widget build(BuildContext context) {
    final success = receipt != null;
    return PaymentPage(
      title: 'Payments',
      onBack: () => Navigator.pop(context, false),
      footer: Column(
        children: [
          PaymentButton(
            label: success ? 'Done' : 'Try again',
            onPressed: () => Navigator.pop(context, !success),
          ),
          if (!success)
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Back to payments'),
            ),
        ],
      ),
      children: [
        const SizedBox(height: 56),
        Center(
          child: Container(
            width: 92,
            height: 92,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: success
                  ? const Color(0xFFE4F5EC)
                  : const Color(0xFFFDECEE),
            ),
            child: Icon(
              success ? Icons.check : Icons.close,
              size: 48,
              color: success
                  ? ParentHomeTheme.verified
                  : const Color(0xFFD42632),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          success ? 'Payment confirmed' : 'Payment failed',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 16),
        Text(
          success
              ? 'Demo receipt available below. This invoice is marked paid in this session. No email was sent.'
              : 'Demo: your bank declined the payment. No money was taken. Try again or use another method.',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 15,
            height: 1.5,
            color: ParentHomeTheme.muted,
          ),
        ),
        if (success) ...[
          const SizedBox(height: 16),
          ReceiptSummary(receipt: receipt!),
          TextButton(
            onPressed: () => showDemoReceipts(context, [receipt!]),
            child: const Text('View demo digital receipt'),
          ),
        ],
      ],
    );
  }
}
