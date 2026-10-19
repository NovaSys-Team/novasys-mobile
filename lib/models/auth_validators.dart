abstract final class AuthValidators {
  static String? name(String? value) =>
      (value ?? '').trim().length < 2 ? 'Enter your full name.' : null;
  static String? email(String? value) {
    final email = (value ?? '').trim();
    return email.isEmpty ||
            RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email)
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
}
