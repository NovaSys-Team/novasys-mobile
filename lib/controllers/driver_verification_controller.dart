import 'package:flutter/foundation.dart';

import '../models/driver_verification.dart';
import '../repositories/mock_verification_repository.dart';

class DriverVerificationController extends ChangeNotifier {
  DriverVerificationController(this._repository);
  final MockVerificationRepository _repository;
  DriverVerification get verification => _repository.verification;
  bool get isDemo => _repository.isDemo;

  bool demoApprove() {
    if (!_repository.demoApprove()) return false;
    notifyListeners();
    return true;
  }

  void addDocument(DriverDocument document) {
    if (_repository.add(document)) notifyListeners();
  }

  bool submit() {
    if (!_repository.submit()) return false;
    notifyListeners();
    return true;
  }

  void clearSession() {
    _repository.clear();
    notifyListeners();
  }
}
