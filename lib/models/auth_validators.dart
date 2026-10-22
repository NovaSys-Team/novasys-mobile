abstract final class AuthValidators {
  static String? name(String? value) =>
      (value ?? '').trim().length < 2 ? 'Enter your full name.' : null;

  static String normalizeEmail(String? value) =>
      (value ?? '').trim().toLowerCase();

  static final _email = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]{2,}$');

  /// Sign-in identity: an address is required and must be well formed.
  static String? requiredEmail(String? value) {
    final email = normalizeEmail(value);
    if (email.isEmpty) return 'Enter your email address.';
    return _email.hasMatch(email) ? null : 'Enter a valid email address.';
  }

  /// Optional profile field: blank is allowed, anything else must be valid.
  static String? email(String? value) {
    final email = normalizeEmail(value);
    return email.isEmpty || _email.hasMatch(email)
        ? null
        : 'Enter a valid email address.';
  }

  static String normalizePhone(String value) {
    var digits = value.replaceAll(RegExp(r'\D'), '');
    if (digits.startsWith('94')) digits = digits.substring(2);
    if (digits.startsWith('0')) digits = digits.substring(1);
    return digits;
  }

  static String? phone(String? value) =>
      RegExp(r'^7\d{8}$').hasMatch(normalizePhone(value ?? ''))
      ? null
      : 'Enter a valid 9-digit Sri Lankan mobile number.';

  /// Optional profile field during registration.
  static String? optionalPhone(String? value) =>
      (value ?? '').trim().isEmpty ? null : phone(value);
}
