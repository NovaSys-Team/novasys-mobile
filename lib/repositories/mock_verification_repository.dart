import '../models/driver_verification.dart';

/// In-memory demo only. No document contents or approval service are stored.
class MockVerificationRepository {
  MockVerificationRepository({this.demoMode = true});
  final bool demoMode;
  DriverVerification? _verification;

  DriverVerification get verification => _verification ??= DriverVerification(
    documents: demoMode ? {DriverDocument.licence, DriverDocument.nic} : {},
  );

  bool add(DriverDocument document) {
    final current = verification;
    if (current.status != VerificationStatus.incomplete ||
        current.documents.contains(document)) {
      return false;
    }
    _verification = DriverVerification(
      documents: {...current.documents, document},
    );
    return true;
  }

  bool submit() {
    if (!verification.canSubmit) return false;
    _verification = DriverVerification(
      documents: verification.documents,
      status: VerificationStatus.pendingReview,
    );
    return true;
  }

  /// Presentation-only transition, never a real approval or authorization.
  bool demoApprove() {
    if (!demoMode || verification.status != VerificationStatus.pendingReview) {
      return false;
    }
    _verification = DriverVerification(
      documents: verification.documents,
      status: VerificationStatus.approved,
    );
    return true;
  }

  bool get isDemo => demoMode;

  void clear() => _verification = null;
}
