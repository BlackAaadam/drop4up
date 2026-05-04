import 'package:flutter/material.dart';

/// Drop4Up V0.3 design tokens.
/// Keep colors centralized. Do not hard-code these values elsewhere.
class Drop4UpTokens {
  const Drop4UpTokens._();

  static const Color background = Color(0xFFF2F2EE);
  static const Color cardSurface = Color(0xFFFBFBFA);
  static const Color primaryBlue = Color(0xFF628FBE);
  static const Color accentBlue = Color(0xFF8FB1D0);
  static const Color lightBlue = Color(0xFFBFD1E3);
  static const Color textPrimary = Color(0xFF2F3438);
  static const Color textSecondary = Color(0xFF9AA3AD);

  // Derived supporting colors. These are allowed because they are part of the
  // centralized rendering system.
  static const Color warmShadow = Color(0xFFD7D4CC);
  static const Color coolShadow = Color(0xFFC9D0D6);
  static const Color deepBlueShadow = Color(0xFF496E91);
  static const Color softWhite = Color(0xFFFFFFFF);

  static const double screenPadding = 26;
  static const double navHeight = 74;
  static const double navRadius = 38;
  static const double cardRadius = 32;
  static const double chipRadius = 22;
  static const double buttonRadius = 999;

  static const Duration fast = Duration(milliseconds: 120);
  static const Duration calm = Duration(milliseconds: 220);
  static const Curve calmCurve = Curves.easeOutCubic;

  static TextTheme textTheme() {
    return const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 34,
        height: 1.08,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.8,
        color: textPrimary,
      ),
      titleLarge: TextStyle(
        fontSize: 22,
        height: 1.18,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
      titleMedium: TextStyle(
        fontSize: 18,
        height: 1.25,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        height: 1.45,
        fontWeight: FontWeight.w400,
        color: textPrimary,
      ),
      bodyMedium: TextStyle(
        fontSize: 15,
        height: 1.42,
        fontWeight: FontWeight.w400,
        color: textPrimary,
      ),
      labelMedium: TextStyle(
        fontSize: 13,
        height: 1.2,
        fontWeight: FontWeight.w500,
        color: textSecondary,
      ),
      labelSmall: TextStyle(
        fontSize: 12,
        height: 1.15,
        fontWeight: FontWeight.w500,
        color: textSecondary,
      ),
    );
  }
}
