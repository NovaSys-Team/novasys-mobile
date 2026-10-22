import '../models/app_user.dart';

class AuthException implements Exception {
  const AuthException(this.message);
  final String message;
}

abstract interface class AuthRepository {
  Future<void> sendCode(String email);
  Future<AppUser?> verifyCode(String email, String code);
  Future<AppUser> register(AppUser user);
  Future<AppUser?> googleDemo(UserRole? role);
  void clearVerification();
}

/// Demo email addresses that already have an account in the simulation.
abstract final class DemoEmails {
  static const parent = 'nadeesha.p@example.com';
  static const driver = 'kasun.s@example.com';
}

/// Session-only simulation. No email is sent, no Google OAuth is performed and
/// no network request is made: the "code" is accepted locally and every account
/// is forgotten when the app restarts.
class DemoAuthRepository implements AuthRepository {
  final Map<String, AppUser> _accounts = {
    DemoEmails.parent: const AppUser(
      name: 'Nadeesha Perera',
      email: DemoEmails.parent,
      phone: '771234567',
      role: UserRole.parent,
    ),
    DemoEmails.driver: const AppUser(
      name: 'Kasun Silva',
      email: DemoEmails.driver,
      phone: '772345678',
      role: UserRole.driver,
    ),
  };
  String? _challengeEmail;
  DateTime? _expires;
  String? _verifiedEmail;
  Future<void> _delay() =>
      Future<void>.delayed(const Duration(milliseconds: 300));

  @override
  Future<void> sendCode(String email) async {
    await _delay();
    _challengeEmail = email;
    _verifiedEmail = null;
    _expires = DateTime.now().add(const Duration(minutes: 10));
  }

  @override
  Future<AppUser?> verifyCode(String email, String code) async {
    await _delay();
    if (_challengeEmail != email ||
        _expires == null ||
        DateTime.now().isAfter(_expires!)) {
      throw const AuthException('Code expired. Please request a new code.');
    }
    if (!RegExp(r'^\d{6}$').hasMatch(code)) {
      throw const AuthException('Enter all 6 digits.');
    }
    _verifiedEmail = email;
    _challengeEmail = null;
    return _accounts[email];
  }

  @override
  Future<AppUser> register(AppUser user) async {
    await _delay();
    if (_verifiedEmail != user.email) {
      throw const AuthException('Verify your email address first.');
    }
    if (_accounts.containsKey(user.email)) {
      throw const AuthException(
        'This email already has an account. Sign in instead.',
      );
    }
    _accounts[user.email] = user;
    _verifiedEmail = null;
    return user;
  }

  @override
  Future<AppUser?> googleDemo(UserRole? role) async {
    await _delay();
    if (role == null) return null;
    return _accounts[role == UserRole.parent
        ? DemoEmails.parent
        : DemoEmails.driver];
  }

  @override
  void clearVerification() {
    _challengeEmail = null;
    _verifiedEmail = null;
    _expires = null;
  }
}
