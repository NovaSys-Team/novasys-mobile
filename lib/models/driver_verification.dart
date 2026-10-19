enum VerificationStatus { incomplete, pendingReview, approved }

enum DriverDocument {
  licence('Driving licence', 'Front and back photo'),
  nic('National ID (NIC)', 'Front and back photo'),
  police('Police clearance report', 'Issued in the last 6 months'),
  registration('Vehicle registration (CR)', 'Book or e-copy');

  const DriverDocument(this.title, this.subtitle);
  final String title;
  final String subtitle;
}

class DriverVerification {
  DriverVerification({
    required Set<DriverDocument> documents,
    this.status = VerificationStatus.incomplete,
  }) : documents = Set.unmodifiable(documents);

  final Set<DriverDocument> documents;
  final VerificationStatus status;
  bool get canSubmit =>
      documents.length == DriverDocument.values.length &&
      status == VerificationStatus.incomplete;
  bool get canCompleteAccount => status == VerificationStatus.approved;

  // Document approval alone is not account completion or operational access.
  bool get canAccessDriverFeatures => false;
}
