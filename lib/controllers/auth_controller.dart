import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/app_user.dart';
import '../models/auth_validators.dart';
import '../repositories/auth_repository.dart';

class AuthController extends ChangeNotifier {
  AuthController(this._repository);
  final AuthRepository _repository;
  UserRole role = UserRole.parent;
  AppUser? user;
  String language = 'English';
  String phone = '';
  bool verified = false;
  bool busy = false;
  String? error;
  int resendSeconds = 0;
  Timer? _timer;
  bool _disposed = false;
  String get displayPhone =>
      '+94 ${phone.length == 9 ? '${phone.substring(0, 2)} ${phone.substring(2, 5)} ${phone.substring(5)}' : phone}';
  void selectLanguage(String value) {
    language = value;
    notifyListeners();
  }

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
    resendSeconds = 30;
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
    final validation = AuthValidators.phone(value);
    if (validation != null) throw AuthException(validation);
    final normalized = AuthValidators.normalizePhone(value);
    await _repository.sendCode(normalized);
    phone = normalized;
    verified = false;
    user = null;
    _startCooldown();
  });
  Future<bool> resendCode() async {
    if (resendSeconds > 0) return false;
    return sendCode(phone);
  }

  Future<bool> verify(String code) => _run(() async {
    user = await _repository.verifyCode(phone, code);
    verified = true;
    _timer?.cancel();
    resendSeconds = 0;
    if (user != null) role = user!.role;
  });
  Future<bool> register({
    required String name,
    required String email,
    required bool consent,
    required bool hasPhoto,
  }) => _run(() async {
    if (!verified) {
      throw const AuthException('Verify your mobile number first.');
    }
    final validation = AuthValidators.name(name) ?? AuthValidators.email(email);
    if (validation != null) throw AuthException(validation);
    if (!consent) {
      throw const AuthException(
        'Agree to the Terms and Privacy Policy to continue.',
      );
    }
    user = await _repository.register(
      AppUser(
        name: name.trim(),
        email: email.trim(),
        phone: phone,
        role: role,
        hasPhoto: hasPhoto,
      ),
    );
  });
  Future<bool> googleDemo(UserRole role) => _run(() async {
    user = await _repository.googleDemo(role);
    if (user != null) {
      this.role = user!.role;
      phone = user!.phone;
    }
  });
  Future<bool> shortcut(UserRole? value) async {
    if (!await sendCode(
      value == null
          ? '779876543'
          : value == UserRole.parent
          ? '771234567'
          : '772345678',
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
    user = null;
    role = UserRole.parent;
    phone = '';
    cancelVerification();
  }

  @override
  void dispose() {
    _disposed = true;
    _timer?.cancel();
    super.dispose();
  }
}
