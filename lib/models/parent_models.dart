class Child {
  const Child({
    required this.id,
    required this.name,
    required this.school,
    this.grade = '',
    this.hasTransport = false,
    this.dateOfBirth,
    this.className = '',
    this.address = '',
    this.allergies = 'None reported',
    this.medicalNotes = 'None reported',
    this.emergencyContact = 'Not provided',
    this.handoverPin = '4279',
    this.pickupPeople = const [],
  });
  final String id;
  final String name;
  final String school;
  final String grade;
  final bool hasTransport;
  final DateTime? dateOfBirth;
  final String className;
  final String address;
  final String allergies;
  final String medicalNotes;
  final String emergencyContact;
  final String handoverPin;
  final List<PickupPerson> pickupPeople;

  Child copyWith({
    String? name,
    String? school,
    String? grade,
    DateTime? dateOfBirth,
    String? className,
    String? address,
    List<PickupPerson>? pickupPeople,
  }) => Child(
    id: id,
    name: name ?? this.name,
    school: school ?? this.school,
    grade: grade ?? this.grade,
    hasTransport: hasTransport,
    dateOfBirth: dateOfBirth ?? this.dateOfBirth,
    className: className ?? this.className,
    address: address ?? this.address,
    allergies: allergies,
    medicalNotes: medicalNotes,
    emergencyContact: emergencyContact,
    handoverPin: handoverPin,
    pickupPeople: pickupPeople ?? this.pickupPeople,
  );
}

class PickupPerson {
  const PickupPerson({
    required this.name,
    required this.relationship,
    this.needsPin = false,
  });
  final String name;
  final String relationship;
  final bool needsPin;
}

class ParentProfile {
  const ParentProfile({
    required this.name,
    required this.phone,
    required this.email,
  });
  final String name;
  final String phone;
  final String email;
}

class TransportInfo {
  const TransportInfo({
    required this.driverName,
    required this.vehicleNumber,
    required this.routeName,
    required this.boardingTime,
    required this.seatNumber,
    this.eta,
    this.status = TransportStatus.scheduled,
  });
  final String driverName;
  final String vehicleNumber;
  final String routeName;
  final String boardingTime;
  final String seatNumber;
  final String? eta;
  final TransportStatus status;
}

enum TransportStatus { scheduled, enRoute, arrived, completed }

class DriverInfo {
  const DriverInfo({
    required this.name,
    required this.vehicleNumber,
    required this.rating,
    required this.totalTrips,
    required this.school,
    this.isVerified = true,
    this.photoUrl,
  });
  final String name;
  final String vehicleNumber;
  final double rating;
  final int totalTrips;
  final String school;
  final bool isVerified;
  final String? photoUrl;
}

class FeeInfo {
  const FeeInfo({
    required this.month,
    required this.amount,
    required this.dueDate,
    this.isPaid = false,
  });
  final String month;
  final double amount;
  final String dueDate;
  final bool isPaid;
}
