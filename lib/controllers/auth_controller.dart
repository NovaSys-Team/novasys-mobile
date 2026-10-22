import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/app_user.dart';
import '../models/auth_validators.dart';
import '../repositories/auth_repository.dart';
import '../repositories/mock_verification_repository.dart';
import 'driver_verification_controller.dart';

class AuthController extends ChangeNotifier {
  AuthController(this._repository);
  final AuthRepository _repository;
  final driverVerification = DriverVerificationController(
    MockVerificationRepository(),
  );
  bool signedInWithGoogle = false;

  /// Seconds the resend control stays locked after a code is requested.
  static const resendCooldown = 45;

  UserRole role = UserRole.parent;
  AppUser? user;
  String email = '';
  bool verified = false;
  bool busy = false;
  String? error;
  int resendSeconds = 0;
  Timer? _timer;
  bool _disposed = false;

  String get displayEmail => email;

  /// mm:ss for the resend countdown shown on the email code screen.
  String get resendLabel => '0:${resendSeconds.toString().padLeft(2, '0')}';

  void selectRole(UserRole value) {
    role = value;
    clearError();
  }

  void clearError() {
    error = null;
    notifyListeners();
  }

  Future<bool> _run(Future<void> Function() action) async {
    if (busy) return false;
    busy = true;
    error = null;
    notifyListeners();
    try {
      await action();
      return true;
    } on AuthException catch (e) {
      error = e.message;
      return false;
    } catch (_) {
      error = 'Something went wrong. Please try again.';
      return false;
    } finally {
      busy = false;
      if (!_disposed) notifyListeners();
    }
  }

  void _startCooldown() {
    _timer?.cancel();
    resendSeconds = resendCooldown;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_disposed) {
        timer.cancel();
        return;
      }
      resendSeconds--;
      if (resendSeconds == 0) timer.cancel();
      notifyListeners();
    });
  }

  Future<bool> sendCode(String value) => _run(() async {
    final validation = AuthValidators.requiredEmail(value);
    if (validation != null) throw AuthException(validation);
    final normalized = AuthValidators.normalizeEmail(value);
    await _repository.sendCode(normalized);
    signedInWithGoogle = false;
    email = normalized;
    verified = false;
    user = null;
    _startCooldown();
  });

  Future<bool> resendCode() async {
    if (resendSeconds > 0) return false;
    return sendCode(email);
  }

  Future<bool> verify(String code) => _run(() async {
    user = await _repository.verifyCode(email, code);
    verified = true;
    _timer?.cancel();
    resendSeconds = 0;
    if (user != null) role = user!.role;
  });

  Future<bool> register({
    required String name,
    required String phone,
    required bool consent,
    required bool hasPhoto,
  }) => _run(() async {
    if (!verified) {
      throw const AuthException('Verify your email address first.');
    }
    final validation =
        AuthValidators.name(name) ?? AuthValidators.optionalPhone(phone);
    if (validation != null) throw AuthException(validation);
    if (!consent) {
      throw const AuthException(
        'Agree to the Terms and Privacy Policy to continue.',
      );
    }
    user = await _repository.register(
      AppUser(
        name: name.trim(),
        email: email,
        phone: phone.trim().isEmpty ? '' : AuthValidators.normalizePhone(phone),
        role: role,
        hasPhoto: hasPhoto,
      ),
    );
  });

  Future<bool> googleDemo(UserRole role) => _run(() async {
    user = await _repository.googleDemo(role);
    signedInWithGoogle = user != null;
    if (user != null) {
      this.role = user!.role;
      email = user!.email;
    }
  });

  /// Prototype shortcut: requests a code for a sample address and accepts it
  /// locally. Nothing is emailed and no account is contacted.
  Future<bool> shortcut(UserRole? value) async {
    if (!await sendCode(
      value == null
          ? 'new.user@example.com'
          : value == UserRole.parent
          ? DemoEmails.parent
          : DemoEmails.driver,
    )) {
      return false;
    }
    return verify('123456');
  }

  void cancelVerification() {
    _timer?.cancel();
    _repository.clearVerification();
    verified = false;
    resendSeconds = 0;
    clearError();
  }

  void signOut() {
    driverVerification.clearSession();
    signedInWithGoogle = false;
    user = null;
    role = UserRole.parent;
    email = '';
    cancelVerification();
  }

  @override
  void dispose() {
    _disposed = true;
    driverVerification.dispose();
    _timer?.cancel();
    super.dispose();
  }
}
