import 'package:flutter/foundation.dart';

import '../models/parent_payment.dart';
import '../repositories/demo_payment_repository.dart';

class ParentPaymentsController extends ChangeNotifier {
  ParentPaymentsController({DemoPaymentRepository? repository})
    : _repository = repository ?? DemoPaymentRepository();
  final DemoPaymentRepository _repository;
  ParentInvoice get invoice => _repository.invoice;
  List<DemoReceipt> get history => _repository.history;
  DemoReceipt? get receipt => _repository.currentReceipt;
  bool get isPaid => receipt != null;

  DemoReceipt? checkout({
    required bool succeed,
    required DemoPaymentMethod method,
  }) {
    final result = _repository.simulate(succeed: succeed, method: method);
    notifyListeners();
    return result;
  }

  void resetDemo() {
    _repository.reset();
    notifyListeners();
  }
}
