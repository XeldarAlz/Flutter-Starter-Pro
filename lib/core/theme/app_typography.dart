import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Application typography using Poppins font
abstract class AppTypography {
  static const String _fontFamily = 'Poppins';

  // Fallback to Google Fonts if local font is not available
  static TextStyle _baseTextStyle({
    required double fontSize,
    required FontWeight fontWeight,
    double? height,
    double? letterSpacing,
    Color? color,
  }) {
    try {
      return TextStyle(
        fontFamily: _fontFamily,
        fontSize: fontSize,
        fontWeight: fontWeight,
        height: height,
        letterSpacing: letterSpacing,
        color: color,
      );
    } catch (_) {
      return GoogleFonts.poppins(
        fontSize: fontSize,
        fontWeight: fontWeight,
        height: height,
        letterSpacing: letterSpacing,
        color: color,
      );
    }
  }

  // Display Styles
  static TextStyle get displayLarge => _baseTextStyle(
        fontSize: 57,
        fontWeight: FontWeight.w400,
        height: 1.12,
        letterSpacing: -0.25,
      );

  static TextStyle get displayMedium => _baseTextStyle(
        fontSize: 45,
        fontWeight: FontWeight.w400,
        height: 1.16,
      );

  static TextStyle get displaySmall => _baseTextStyle(
        fontSize: 36,
        fontWeight: FontWeight.w400,
        height: 1.22,
      );

  // Headline Styles
  static TextStyle get headlineLarge => _baseTextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        height: 1.25,
      );

  static TextStyle get headlineMedium => _baseTextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        height: 1.29,
      );

  static TextStyle get headlineSmall => _baseTextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        height: 1.33,
      );

  // Title Styles
  static TextStyle get titleLarge => _baseTextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        height: 1.27,
      );

  static TextStyle get titleMedium => _baseTextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.50,
        letterSpacing: 0.15,
      );

  static TextStyle get titleSmall => _baseTextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.43,
        letterSpacing: 0.1,
      );

  // Body Styles
  static TextStyle get bodyLarge => _baseTextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.50,
        letterSpacing: 0.5,
      );

  static TextStyle get bodyMedium => _baseTextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.43,
        letterSpacing: 0.25,
      );

  static TextStyle get bodySmall => _baseTextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.33,
        letterSpacing: 0.4,
      );

  // Label Styles
  static TextStyle get labelLarge => _baseTextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 1.43,
        letterSpacing: 0.1,
      );

  static TextStyle get labelMedium => _baseTextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 1.33,
        letterSpacing: 0.5,
      );

  static TextStyle get labelSmall => _baseTextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        height: 1.45,
        letterSpacing: 0.5,
      );

  // Text Theme
  static TextTheme get textTheme => TextTheme(
        displayLarge: displayLarge,
        displayMedium: displayMedium,
        displaySmall: displaySmall,
        headlineLarge: headlineLarge,
        headlineMedium: headlineMedium,
        headlineSmall: headlineSmall,
        titleLarge: titleLarge,
        titleMedium: titleMedium,
        titleSmall: titleSmall,
        bodyLarge: bodyLarge,
        bodyMedium: bodyMedium,
        bodySmall: bodySmall,
        labelLarge: labelLarge,
        labelMedium: labelMedium,
        labelSmall: labelSmall,
      );
}

