import 'package:flutter/foundation.dart';

import '../models/parent_models.dart';

class ParentHomeController extends ChangeNotifier {
  ParentHomeController({this.isNewParent = false});

  final bool isNewParent;

  int selectedChildIndex = 0;
  int bottomNavIndex = 0;

  final List<Child> children = const [
    Child(
      id: '1',
      name: 'Sanulli',
      school: 'Royal International School',
      grade: 'Grade 4',
      hasTransport: true,
    ),
    Child(
      id: '2',
      name: 'Kavini',
      school: 'Royal International School',
      grade: 'Grade 2',
      hasTransport: true,
    ),
  ];

  final Map<String, TransportInfo> transportByChild = const {
    '1': TransportInfo(
      driverName: 'Mr. Kamal Perera',
      vehicleNumber: 'WP KA-5678',
      routeName: 'Colombo 7 → Rajagiriya',
      boardingTime: '6:45 AM',
      seatNumber: 'Seat 4',
      eta: '15 min',
      status: TransportStatus.enRoute,
    ),
    '2': TransportInfo(
      driverName: 'Mr. Kamal Perera',
      vehicleNumber: 'WP KA-5678',
      routeName: 'Colombo 7 → Rajagiriya',
      boardingTime: '6:45 AM',
      seatNumber: 'Seat 5',
      status: TransportStatus.scheduled,
    ),
  };

  final List<DriverInfo> verifiedDrivers = const [
    DriverInfo(
      name: 'Mr. Kamal Perera',
      vehicleNumber: 'WP KA-5678',
      rating: 4.8,
      totalTrips: 1240,
      school: 'Royal International School',
    ),
    DriverInfo(
      name: 'Mr. Nimal Silva',
      vehicleNumber: 'WP CB-1234',
      rating: 4.6,
      totalTrips: 980,
      school: 'Royal International School',
    ),
    DriverInfo(
      name: 'Mr. Sunil Fernando',
      vehicleNumber: 'WP KD-9012',
      rating: 4.9,
      totalTrips: 2100,
      school: 'Gateway College',
    ),
  ];

  final FeeInfo currentFee = const FeeInfo(
    month: 'October',
    amount: 8500,
    dueDate: 'Oct 25',
  );

  Child get selectedChild => children[selectedChildIndex];

  TransportInfo? get selectedTransport => transportByChild[selectedChild.id];

  void selectChild(int index) {
    if (index == selectedChildIndex) return;
    selectedChildIndex = index;
    notifyListeners();
  }

  void selectNavTab(int index) {
    bottomNavIndex = index;
    notifyListeners();
  }
}
