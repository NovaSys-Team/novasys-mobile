enum UserRole {
  parent('Parent'),
  driver('Driver');

  const UserRole(this.label);
  final String label;
}

class AppUser {
  const AppUser({
    required this.name,
    required this.email,
    required this.role,
    this.phone = '',
    this.hasPhoto = false,
  });

  /// Email is the sign-in identity; mobile number is optional profile detail.
  final String name;
  final String email;
  final String phone;
  final UserRole role;
  final bool hasPhoto;
}
