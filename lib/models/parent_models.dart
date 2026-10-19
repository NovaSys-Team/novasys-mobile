class Child {
  const Child({
    required this.id,
    required this.name,
    required this.school,
    this.grade = '',
    this.hasTransport = false,
  });
  final String id;
  final String name;
  final String school;
  final String grade;
  final bool hasTransport;
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
