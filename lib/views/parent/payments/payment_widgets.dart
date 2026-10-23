import 'package:flutter/material.dart';

import '../../../models/parent_payment.dart';
import '../../../theme/parent_home_theme.dart';

class PaymentTheme extends StatelessWidget {
  const PaymentTheme({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) => Theme(
    data: Theme.of(context).copyWith(
      textTheme: Theme.of(context).textTheme.apply(
        bodyColor: ParentHomeTheme.ink,
        displayColor: ParentHomeTheme.ink,
      ),
    ),
    child: child,
  );
}

class PaymentCard extends StatelessWidget {
  const PaymentCard({super.key, required this.child, this.border});
  final Widget child;
  final Color? border;
  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(22),
      border: border == null ? null : Border.all(color: border!),
    ),
    child: child,
  );
}

class PaymentButton extends StatelessWidget {
  const PaymentButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.orange = false,
  });
  final String label;
  final VoidCallback? onPressed;
  final bool orange;
  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    child: FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: orange ? ParentHomeTheme.orange : ParentHomeTheme.teal,
        foregroundColor: orange ? ParentHomeTheme.ink : Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
      ),
    ),
  );
}

class PaymentHeader extends StatelessWidget {
  const PaymentHeader({super.key, required this.title, required this.onBack});
  final String title;
  final VoidCallback onBack;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
    child: Row(
      children: [
        IconButton.filledTonal(
          onPressed: onBack,
          tooltip: 'Back',
          style: IconButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: ParentHomeTheme.ink,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          icon: const Icon(Icons.chevron_left),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF4DE),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(
            'DEMO MODE',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: Color(0xFF885800),
            ),
          ),
        ),
      ],
    ),
  );
}

/// Scrollable at small heights and with the Android keyboard visible.
class PaymentPage extends StatelessWidget {
  const PaymentPage({
    super.key,
    required this.title,
    required this.onBack,
    required this.children,
    required this.footer,
  });
  final String title;
  final VoidCallback onBack;
  final List<Widget> children;
  final Widget footer;
  @override
  Widget build(BuildContext context) => PaymentTheme(
    child: Scaffold(
      backgroundColor: ParentHomeTheme.soft,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Column(
              children: [
                PaymentHeader(title: title, onBack: onBack),
                Expanded(
                  child: CustomScrollView(
                    slivers: [
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        sliver: SliverToBoxAdapter(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: children,
                          ),
                        ),
                      ),
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [footer],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

class ReceiptSummary extends StatelessWidget {
  const ReceiptSummary({super.key, required this.receipt});
  final DemoReceipt receipt;
  @override
  Widget build(BuildContext context) => PaymentCard(
    child: Column(
      children: [
        _row('Receipt no.', receipt.id),
        _row('Invoice', receipt.invoiceId),
        _row('Paid', paymentDate(receipt.paidAt)),
        _row('Method', receipt.method.label),
        _row('Amount', 'LKR ${paymentMoney(receipt.amount)}.00'),
        const Text(
          'SIMULATED • No money charged',
          style: TextStyle(color: ParentHomeTheme.teal, fontSize: 12),
        ),
      ],
    ),
  );
  Widget _row(String label, String value) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(color: ParentHomeTheme.muted),
          ),
        ),
        const SizedBox(width: 10),
        Flexible(
          flex: 2,
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    ),
  );
}

void showDemoReceipts(BuildContext context, List<DemoReceipt> receipts) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: ParentHomeTheme.soft,
    builder: (context) => FractionallySizedBox(
      heightFactor: .85,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Demo digital receipts',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                ),
                IconButton(
                  tooltip: 'Close',
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                for (final receipt in receipts)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: ReceiptSummary(receipt: receipt),
                  ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
