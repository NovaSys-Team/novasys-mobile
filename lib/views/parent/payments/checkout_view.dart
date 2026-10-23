import 'package:flutter/material.dart';

import '../../../controllers/parent_payments_controller.dart';
import '../../../models/parent_payment.dart';
import '../../../theme/parent_home_theme.dart';
import 'payment_result_view.dart';
import 'payment_widgets.dart';

class CheckoutView extends StatefulWidget {
  const CheckoutView({super.key, required this.controller});
  final ParentPaymentsController controller;
  @override
  State<CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<CheckoutView> {
  final _form = GlobalKey<FormState>();
  DemoPaymentMethod _method = DemoPaymentMethod.card;
  bool _submitted = false;

  Future<void> _pay(bool succeed) async {
    if (_submitted || !_form.currentState!.validate()) return;
    setState(() => _submitted = true);
    final receipt = widget.controller.checkout(
      succeed: succeed,
      method: _method,
    );
    final retry = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => PaymentResultView(receipt: receipt)),
    );
    if (!mounted) return;
    if (retry == true && receipt == null) {
      setState(() => _submitted = false);
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) => Form(
    key: _form,
    child: PaymentPage(
      title: 'Checkout',
      onBack: () => Navigator.pop(context),
      footer: Column(
        children: [
          PaymentButton(
            label: 'Simulate successful payment',
            onPressed: _submitted ? null : () => _pay(true),
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: _submitted ? null : () => _pay(false),
            child: const Text('Demo: simulate failed payment'),
          ),
        ],
      ),
      children: [
        PaymentCard(
          child: Row(
            children: [
              const Expanded(
                child: Text(
                  'Paying to NovaSys',
                  style: TextStyle(color: ParentHomeTheme.muted),
                ),
              ),
              Flexible(
                child: Text(
                  'LKR ${paymentMoney(widget.controller.invoice.total)}.00',
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Text(
          '${widget.controller.invoice.month} · Sanuli & Kavin',
          style: const TextStyle(fontSize: 12, color: ParentHomeTheme.muted),
        ),
        const SizedBox(height: 18),
        const Text(
          'Payment method',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        for (final method in DemoPaymentMethod.values)
          Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Semantics(
              selected: _method == method,
              button: true,
              child: InkWell(
                onTap: _submitted
                    ? null
                    : () => setState(() => _method = method),
                borderRadius: BorderRadius.circular(18),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: _method == method
                        ? ParentHomeTheme.mint
                        : Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: _method == method
                          ? ParentHomeTheme.teal
                          : ParentHomeTheme.line,
                      width: _method == method ? 1.5 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.credit_card, color: ParentHomeTheme.ink),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              method.label,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              method.description,
                              style: const TextStyle(
                                fontSize: 12,
                                color: ParentHomeTheme.muted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        _method == method
                            ? Icons.radio_button_checked
                            : Icons.radio_button_off,
                        color: ParentHomeTheme.teal,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: ParentHomeTheme.mint,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.lock_outline, color: ParentHomeTheme.teal, size: 20),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Simulation only. No card details, bank login or wallet credentials are requested. No money will be charged.',
                  style: TextStyle(
                    color: ParentHomeTheme.teal,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        FormField<bool>(
          initialValue: false,
          validator: (value) =>
              value == true ? null : 'Confirm demo mode to continue.',
          builder: (field) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CheckboxListTile(
                key: const ValueKey('demo-consent'),
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
                value: field.value,
                onChanged: _submitted ? null : field.didChange,
                title: const Text(
                  'I understand this is a demo payment.',
                  style: TextStyle(fontSize: 13),
                ),
              ),
              if (field.hasError)
                Text(
                  field.errorText!,
                  style: const TextStyle(color: Color(0xFFB3261E)),
                ),
            ],
          ),
        ),
      ],
    ),
  );
}
