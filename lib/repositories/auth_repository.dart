import '../models/app_user.dart';

class AuthException implements Exception {
  const AuthException(this.message);
  final String message;
}

abstract interface class AuthRepository {
  Future<void> sendCode(String phone);
  Future<AppUser?> verifyCode(String phone, String code);
  Future<AppUser> register(AppUser user);
  Future<AppUser?> googleDemo(UserRole? role);
  void clearVerification();
}

/// Session-only simulation: no SMS, Google OAuth, or network requests.
class DemoAuthRepository implements AuthRepository {
  final Map<String, AppUser> _accounts = {
    '771234567': const AppUser(
      name: 'Nadeesha Perera',
      phone: '771234567',
      role: UserRole.parent,
    ),
    '772345678': const AppUser(
      name: 'Kasun Silva',
      phone: '772345678',
      role: UserRole.driver,
    ),
  };
  String? _challengePhone;
  DateTime? _expires;
  String? _verifiedPhone;
  Future<void> _delay() =>
      Future<void>.delayed(const Duration(milliseconds: 300));
  @override
  Future<void> sendCode(String phone) async {
    await _delay();
    _challengePhone = phone;
    _verifiedPhone = null;
    _expires = DateTime.now().add(const Duration(minutes: 5));
  }

  @override
  Future<AppUser?> verifyCode(String phone, String code) async {
    await _delay();
    if (_challengePhone != phone ||
        _expires == null ||
        DateTime.now().isAfter(_expires!)) {
      throw const AuthException('Code expired. Please request a new code.');
    }
    if (!RegExp(r'^\d{6}$').hasMatch(code)) {
      throw const AuthException('Enter all 6 digits.');
    }
    _verifiedPhone = phone;
    _challengePhone = null;
    return _accounts[phone];
  }

  @override
  Future<AppUser> register(AppUser user) async {
    await _delay();
    if (_verifiedPhone != user.phone) {
      throw const AuthException('Verify your mobile number first.');
    }
    if (_accounts.containsKey(user.phone)) {
      throw const AuthException(
        'This number already has an account. Sign in instead.',
      );
    }
    _accounts[user.phone] = user;
    _verifiedPhone = null;
    return user;
  }

  @override
  Future<AppUser?> googleDemo(UserRole? role) async {
    await _delay();
    if (role == null) return null;
    return _accounts[role == UserRole.parent ? '771234567' : '772345678'];
  }

  @override
  void clearVerification() {
    _challengePhone = null;
    _verifiedPhone = null;
    _expires = null;
  }
}
