import '../models/parent_payment.dart';

/// Session-only fixtures. No network, credentials, or persistent storage.
class DemoPaymentRepository {
  final invoice = const ParentInvoice(
    id: 'INV-2026-10-0418',
    month: 'October 2026',
    lines: [PaymentLine('Sanuli', 8500), PaymentLine('Kavin', 8500)],
  );
  final List<DemoReceipt> _history = [
    for (final month in [9, 8, 7])
      DemoReceipt(
        id: 'DEMO-RCP-2026-$month',
        invoiceId: 'DEMO-INV-2026-$month',
        month: '${{9: 'September', 8: 'August', 7: 'July'}[month]} 2026',
        amount: month == 7 ? 8500 : 17000,
        paidAt: DateTime(
          2026,
          month,
          month == 9
              ? 18
              : month == 8
              ? 21
              : 19,
        ),
        method: month == 8 ? DemoPaymentMethod.banking : DemoPaymentMethod.card,
      ),
  ];

  List<DemoReceipt> get history => List.unmodifiable(_history);
  DemoReceipt? get currentReceipt {
    for (final receipt in _history) {
      if (receipt.invoiceId == invoice.id) return receipt;
    }
    return null;
  }

  DemoReceipt? simulate({
    required bool succeed,
    required DemoPaymentMethod method,
  }) {
    if (!succeed) return null;
    // Repeated submissions cannot create duplicate payments.
    if (currentReceipt != null) return currentReceipt;
    final receipt = DemoReceipt(
      id: 'DEMO-RCP-88213',
      invoiceId: invoice.id,
      month: invoice.month,
      amount: invoice.total,
      paidAt: DateTime(2026, 10, 23, 10, 42),
      method: method,
    );
    _history.insert(0, receipt);
    return receipt;
  }

  void reset() =>
      _history.removeWhere((receipt) => receipt.invoiceId == invoice.id);
}
