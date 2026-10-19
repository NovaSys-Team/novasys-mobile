enum UserRole {
  parent('Parent'),
  driver('Driver');

  const UserRole(this.label);
  final String label;
}

class AppUser {
  const AppUser({
    required this.name,
    required this.phone,
    required this.role,
    this.email = '',
    this.hasPhoto = false,
  });
  final String name;
  final String phone;
  final String email;
  final UserRole role;
  final bool hasPhoto;
}
