import 'package:flutter/material.dart';

/// Drop4Up V0.3/V0.4 design tokens.
class Drop4UpTokens {
  const Drop4UpTokens._();

  static const Color background = Color(0xFFF2F2EE);
  static const Color cardSurface = Color(0xFFFBFBFA);
  static const Color primaryBlue = Color(0xFF628FBE);
  static const Color accentBlue = Color(0xFF8FB1D0);
  static const Color lightBlue = Color(0xFFBFD1E3);
  static const Color textPrimary = Color(0xFF2F3438);
  static const Color textSecondary = Color(0xFF9AA3AD);

  static const Color softWhite = Color(0xFFFFFFFF);
  static const Color warmShadow = Color(0xFFD7D4CC);
  static const Color coolShadow = Color(0xFFC9D0D6);

  static const double cardRadius = 32;
  static const double pillRadius = 999;
  static const double screenPadding = 26;
  static const double iconButtonSize = 52;
  static const double navHeight = 76;
  static const double navRadius = 38;

  static const Duration calmDuration = Duration(milliseconds: 220);
  static const Duration quickDuration = Duration(milliseconds: 120);
  static const Curve calmCurve = Curves.easeOutCubic;

  static TextTheme textTheme() {
    return const TextTheme(
      headlineLarge: TextStyle(
        color: textPrimary,
        fontSize: 34,
        fontWeight: FontWeight.w600,
        height: 1.12,
        letterSpacing: 0,
      ),
      titleLarge: TextStyle(
        color: textPrimary,
        fontSize: 22,
        fontWeight: FontWeight.w600,
        height: 1.22,
        letterSpacing: 0,
      ),
      titleMedium: TextStyle(
        color: textPrimary,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 1.25,
        letterSpacing: 0,
      ),
      bodyLarge: TextStyle(
        color: textPrimary,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.45,
        letterSpacing: 0,
      ),
      bodyMedium: TextStyle(
        color: textPrimary,
        fontSize: 15,
        fontWeight: FontWeight.w400,
        height: 1.42,
        letterSpacing: 0,
      ),
      labelLarge: TextStyle(
        color: textPrimary,
        fontSize: 15,
        fontWeight: FontWeight.w600,
        height: 1.2,
        letterSpacing: 0,
      ),
      labelMedium: TextStyle(
        color: textSecondary,
        fontSize: 13,
        fontWeight: FontWeight.w500,
        height: 1.2,
        letterSpacing: 0,
      ),
    );
  }
}
