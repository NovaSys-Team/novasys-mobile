import 'package:flutter/material.dart';

import '../../../controllers/parent_payments_controller.dart';
import '../../../models/parent_payment.dart';
import '../../../theme/parent_home_theme.dart';
import 'checkout_view.dart';
import 'payment_widgets.dart';

class PaymentsView extends StatelessWidget {
  const PaymentsView({
    super.key,
    required this.controller,
    required this.onBack,
  });
  final ParentPaymentsController controller;
  final VoidCallback onBack;
  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: controller,
    builder: (context, _) {
      final invoice = controller.invoice;
      return PaymentTheme(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: ListView(
              children: [
                PaymentHeader(title: 'Payments', onBack: onBack),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      PaymentCard(
                        border: ParentHomeTheme.orange.withAlpha(80),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Wrap(
                              spacing: 6,
                              runSpacing: 8,
                              children: [
                                Text(
                                  'Invoice ${invoice.id}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: ParentHomeTheme.muted,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  controller.isPaid
                                      ? 'Paid • DEMO'
                                      : 'Due 25 Oct',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: controller.isPaid
                                        ? ParentHomeTheme.verified
                                        : const Color(0xFFB63A20),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Text(
                              '${invoice.month} total',
                              style: const TextStyle(
                                color: ParentHomeTheme.muted,
                              ),
                            ),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'LKR ${paymentMoney(invoice.total)}.00',
                                style: const TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            const Divider(
                              height: 30,
                              color: ParentHomeTheme.line,
                            ),
                            for (final line in invoice.lines)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        '${line.child} · Kamal P. · both trips',
                                        style: const TextStyle(fontSize: 13),
                                      ),
                                    ),
                                    Text(
                                      '${paymentMoney(line.amount)}.00',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            PaymentButton(
                              label: controller.isPaid
                                  ? 'View demo receipt'
                                  : 'Pay LKR ${paymentMoney(invoice.total)}',
                              orange: !controller.isPaid,
                              onPressed: () {
                                if (controller.isPaid) {
                                  showDemoReceipts(context, [
                                    controller.receipt!,
                                  ]);
                                  return;
                                }
                                Navigator.of(context).push(
                                  MaterialPageRoute<void>(
                                    builder: (_) =>
                                        CheckoutView(controller: controller),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                      PaymentCard(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.notifications_none,
                              color: ParentHomeTheme.teal,
                              size: 20,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                controller.isPaid
                                    ? 'Demo payment complete. No reminders due.'
                                    : 'Reminders 7, 3 and 1 day before the due date. They stop once you pay. (Demo only)',
                                style: const TextStyle(
                                  color: ParentHomeTheme.muted,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'Payment history',
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                          ),
                          TextButton(
                            onPressed: () =>
                                showDemoReceipts(context, controller.history),
                            child: const Text('View all receipts'),
                          ),
                        ],
                      ),
                      PaymentCard(
                        child: Column(
                          children: [
                            for (final receipt in controller.history) ...[
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(9),
                                    decoration: BoxDecoration(
                                      color: ParentHomeTheme.mint,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Icon(
                                      Icons.check,
                                      size: 20,
                                      color: ParentHomeTheme.verified,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          receipt.month,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        Text(
                                          'Paid ${paymentDate(receipt.paidAt)} · DEMO',
                                          style: const TextStyle(
                                            fontSize: 11,
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
                                        '${paymentMoney(receipt.amount)}.00',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () => showDemoReceipts(context, [
                                          receipt,
                                        ]),
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(
                                            vertical: 8,
                                          ),
                                          child: Text(
                                            'Receipt',
                                            style: TextStyle(
                                              color: ParentHomeTheme.teal,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              if (receipt != controller.history.last)
                                const Divider(color: ParentHomeTheme.line),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'SIMULATED records • Stored only for this session',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 11,
                          color: ParentHomeTheme.muted,
                        ),
                      ),
                      TextButton(
                        onPressed: controller.resetDemo,
                        child: const Text('Reset demo payment'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
