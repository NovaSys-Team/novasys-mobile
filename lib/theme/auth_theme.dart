import 'package:flutter/material.dart';

import 'app_theme.dart';

/// Latest exported auth tokens, scoped so dashboard styling is unchanged.
abstract final class AuthTheme {
  static const teal = Color(0xFF0A7C70);
  static const deep = Color(0xFF0B3B3A);
  static const mint = Color(0xFFE6F5F3);
  static const slate = Color(0xFF4A5D5B);
  static const ink = Color(0xFF0F2A29);
  static const muted = Color(0xFF5E6F6D);
  static const line = Color(0xFFDCE5E3);
  static const soft = Color(0xFFF4F8F7);
  static const verified = Color(0xFF157A40);
  static final light = AppTheme.light.copyWith(
    colorScheme: AppTheme.light.colorScheme.copyWith(
      primary: teal,
      onSurface: ink,
    ),
    textTheme: AppTheme.light.textTheme
        .apply(bodyColor: muted, displayColor: ink)
        .copyWith(
          bodyLarge: AppTheme.light.textTheme.bodyLarge!.copyWith(
            color: ink,
            fontWeight: FontWeight.w600,
          ),
          // Reference headings measure ~30px with no negative tracking,
          // where the global theme uses 28px at -0.6.
          headlineMedium: AppTheme.light.textTheme.headlineMedium!.copyWith(
            color: ink,
            fontSize: 30,
            letterSpacing: 0,
          ),
          titleLarge: AppTheme.light.textTheme.titleLarge!.copyWith(color: ink),
        ),
    filledButtonTheme: FilledButtonThemeData(
      style: AppTheme.light.filledButtonTheme.style!.copyWith(
        textStyle: const WidgetStatePropertyAll(
          TextStyle(
            fontFamily: 'Roboto',
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.disabled)
              ? const Color(0xFFE7EDEC)
              : teal,
        ),
        foregroundColor: WidgetStateProperty.resolveWith(
          (states) =>
              states.contains(WidgetState.disabled) ? muted : Colors.white,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: AppTheme.light.outlinedButtonTheme.style!.copyWith(
        minimumSize: const WidgetStatePropertyAll(Size(double.infinity, 56)),
        foregroundColor: const WidgetStatePropertyAll(ink),
        side: const WidgetStatePropertyAll(BorderSide(color: line)),
      ),
    ),
    inputDecorationTheme: AppTheme.light.inputDecorationTheme.copyWith(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: line),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: teal, width: 1.6),
      ),
    ),
  );
}
