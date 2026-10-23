import 'package:flutter/foundation.dart';

import '../models/parent_models.dart';
import 'parent_payments_controller.dart';

class ParentHomeController extends ChangeNotifier {
  ParentHomeController({this.isNewParent = false, ParentProfile? profile})
    : profile =
          profile ??
          const ParentProfile(
            name: 'Nadeesha Perera',
            phone: '+94 77 123 4567',
            email: 'nadeesha.perera@example.com',
          ) {
    payments.addListener(notifyListeners);
  }

  final payments = ParentPaymentsController();

  @override
  void dispose() {
    payments.removeListener(notifyListeners);
    payments.dispose();
    super.dispose();
  }

  ParentProfile profile;
  bool darkMode = false;
  bool pushNotifications = true;
  bool emailNotifications = true;
  int _nextChildId = 3;

  void updateProfile(ParentProfile value) {
    profile = value;
    notifyListeners();
  }

  void setDarkMode(bool value) {
    darkMode = value;
    notifyListeners();
  }

  void setNotifications({bool? push, bool? email}) {
    pushNotifications = push ?? pushNotifications;
    emailNotifications = email ?? emailNotifications;
    notifyListeners();
  }

  Child childById(String id) => children.firstWhere((child) => child.id == id);

  void saveChild(Child child, {bool isNew = false}) {
    if (isNew) {
      children.add(
        Child(
          id: 'local-${_nextChildId++}',
          name: child.name,
          school: child.school,
          grade: child.grade,
          className: child.className,
          dateOfBirth: child.dateOfBirth,
          address: child.address,
        ),
      );
    } else {
      final index = children.indexWhere((value) => value.id == child.id);
      if (index == -1) return;
      children[index] = child;
    }
    notifyListeners();
  }

  void addPickupPerson(String childId, PickupPerson person) {
    final child = childById(childId);
    saveChild(child.copyWith(pickupPeople: [...child.pickupPeople, person]));
  }

  bool isNewParent;

  void setHomeVariant(bool value) {
    isNewParent = value;
    notifyListeners();
  }

  int selectedChildIndex = 0;
  int bottomNavIndex = 0;

  final List<Child> children = [
    Child(
      id: '1',
      name: 'Sanuli Perera',
      school: 'Visakha Vidyalaya',
      grade: 'Grade 5',
      className: 'B',
      dateOfBirth: DateTime(2016, 3, 14),
      address: '42 Lake Drive, Rajagiriya',
      allergies: 'Peanuts (severe)',
      medicalNotes: 'Mild asthma \u00b7 inhaler in bag',
      emergencyContact: 'Sunil Perera \u00b7 +94 71 987 6543',
      pickupPeople: const [
        PickupPerson(
          name: 'Nadeesha Perera',
          relationship: 'Mother \u00b7 you',
        ),
        PickupPerson(name: 'Sunil Perera', relationship: 'Father'),
        PickupPerson(
          name: 'Kamala Dissanayake',
          relationship: 'Grandmother',
          needsPin: true,
        ),
      ],
      hasTransport: true,
    ),
    Child(
      id: '2',
      name: 'Kavin Perera',
      className: 'A',
      dateOfBirth: DateTime(2019, 7, 8),
      address: '42 Lake Drive, Rajagiriya',
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

  FeeInfo get currentFee => FeeInfo(
    month: 'October',
    amount: 8500,
    dueDate: 'Oct 25',
    isPaid: payments.isPaid,
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
