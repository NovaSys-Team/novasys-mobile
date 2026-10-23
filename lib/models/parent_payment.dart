enum DemoPaymentMethod {
  card('Debit / credit card', 'Visa, Mastercard, Amex'),
  banking('Online banking', 'All major Sri Lankan banks'),
  wallet('Mobile wallet', 'Pay from your phone balance');

  const DemoPaymentMethod(this.label, this.description);
  final String label;
  final String description;
}

class PaymentLine {
  const PaymentLine(this.child, this.amount);
  final String child;
  final int amount;
}

class ParentInvoice {
  const ParentInvoice({
    required this.id,
    required this.month,
    required this.lines,
  });
  final String id;
  final String month;
  final List<PaymentLine> lines;
  int get total => lines.fold(0, (total, line) => total + line.amount);
}

class DemoReceipt {
  const DemoReceipt({
    required this.id,
    required this.invoiceId,
    required this.month,
    required this.amount,
    required this.paidAt,
    required this.method,
  });
  final String id;
  final String invoiceId;
  final String month;
  final int amount;
  final DateTime paidAt;
  final DemoPaymentMethod method;
}

String paymentMoney(int amount) => amount.toString().replaceAllMapped(
  RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
  (match) => '${match[1]},',
);

String paymentDate(DateTime date) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return '${date.day} ${months[date.month - 1]} ${date.year}';
}
