import 'package:flutter/material.dart';

/// Application color palette
/// A modern, vibrant color scheme with indigo primary and emerald accents
abstract class AppColors {
  static const Color primary = Color(0xFF6366F1);
  static const Color primaryLight = Color(0xFF818CF8);
  static const Color primaryDark = Color(0xFF4F46E5);
  static const Color primaryContainer = Color(0xFFE0E7FF);
  static const Color onPrimaryContainer = Color(0xFF1E1B4B);

  static const Color secondary = Color(0xFF10B981);
  static const Color secondaryLight = Color(0xFF34D399);
  static const Color secondaryDark = Color(0xFF059669);
  static const Color secondaryContainer = Color(0xFFD1FAE5);
  static const Color onSecondaryContainer = Color(0xFF064E3B);

  static const Color tertiary = Color(0xFFF59E0B);
  static const Color tertiaryLight = Color(0xFFFBBF24);
  static const Color tertiaryDark = Color(0xFFD97706);
  static const Color tertiaryContainer = Color(0xFFFEF3C7);
  static const Color onTertiaryContainer = Color(0xFF78350F);

  static const Color background = Color(0xFFFAFAFA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF3F4F6);
  static const Color onBackground = Color(0xFF1F2937);
  static const Color onSurface = Color(0xFF111827);
  static const Color onSurfaceVariant = Color(0xFF6B7280);

  static const Color backgroundDark = Color(0xFF0F172A);
  static const Color surfaceDark = Color(0xFF1E293B);
  static const Color surfaceVariantDark = Color(0xFF334155);
  static const Color onBackgroundDark = Color(0xFFF1F5F9);
  static const Color onSurfaceDark = Color(0xFFF8FAFC);
  static const Color onSurfaceVariantDark = Color(0xFF94A3B8);

  static const Color success = Color(0xFF22C55E);
  static const Color successLight = Color(0xFFDCFCE7);
  static const Color onSuccess = Color(0xFFFFFFFF);

  static const Color warning = Color(0xFFEAB308);
  static const Color warningLight = Color(0xFFFEF9C3);
  static const Color onWarning = Color(0xFF422006);

  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFFFEE2E2);
  static const Color onError = Color(0xFFFFFFFF);

  static const Color info = Color(0xFF3B82F6);
  static const Color infoLight = Color(0xFFDBEAFE);
  static const Color onInfo = Color(0xFFFFFFFF);

  static const Color textPrimary = Color(0xFF1F2937);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textTertiary = Color(0xFF9CA3AF);
  static const Color textDisabled = Color(0xFFD1D5DB);

  static const Color textPrimaryDark = Color(0xFFF9FAFB);
  static const Color textSecondaryDark = Color(0xFFD1D5DB);
  static const Color textTertiaryDark = Color(0xFF9CA3AF);
  static const Color textDisabledDark = Color(0xFF6B7280);

  static const Color border = Color(0xFFE5E7EB);
  static const Color borderDark = Color(0xFF374151);

  static const Color divider = Color(0xFFE5E7EB);
  static const Color dividerDark = Color(0xFF374151);

  static const Color shadow = Color(0x1A000000);
  static const Color shadowDark = Color(0x40000000);

  static const Color overlay = Color(0x80000000);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [secondary, secondaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [primary, secondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static ColorScheme get lightColorScheme => const ColorScheme(
        brightness: Brightness.light,
        primary: primary,
        onPrimary: Colors.white,
        primaryContainer: primaryContainer,
        onPrimaryContainer: onPrimaryContainer,
        secondary: secondary,
        onSecondary: Colors.white,
        secondaryContainer: secondaryContainer,
        onSecondaryContainer: onSecondaryContainer,
        tertiary: tertiary,
        onTertiary: Colors.white,
        tertiaryContainer: tertiaryContainer,
        onTertiaryContainer: onTertiaryContainer,
        error: error,
        onError: onError,
        errorContainer: errorLight,
        onErrorContainer: Color(0xFF410002),
        surface: surface,
        onSurface: onSurface,
        surfaceContainerHighest: surfaceVariant,
        onSurfaceVariant: onSurfaceVariant,
        outline: border,
        shadow: shadow,
      );

  static ColorScheme get darkColorScheme => const ColorScheme(
        brightness: Brightness.dark,
        primary: primaryLight,
        onPrimary: Color(0xFF1E1B4B),
        primaryContainer: primaryDark,
        onPrimaryContainer: Color(0xFFE0E7FF),
        secondary: secondaryLight,
        onSecondary: Color(0xFF064E3B),
        secondaryContainer: secondaryDark,
        onSecondaryContainer: Color(0xFFD1FAE5),
        tertiary: tertiaryLight,
        onTertiary: Color(0xFF78350F),
        tertiaryContainer: tertiaryDark,
        onTertiaryContainer: Color(0xFFFEF3C7),
        error: Color(0xFFFCA5A5),
        onError: Color(0xFF7F1D1D),
        errorContainer: Color(0xFF93000A),
        onErrorContainer: Color(0xFFFFDAD6),
        surface: surfaceDark,
        onSurface: onSurfaceDark,
        surfaceContainerHighest: surfaceVariantDark,
        onSurfaceVariant: onSurfaceVariantDark,
        outline: borderDark,
        shadow: shadowDark,
      );
}
