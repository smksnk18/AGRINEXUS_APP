import 'package:flutter/material.dart';

/// Centralized color palette for the AgriNexus app.
/// Inspired by the AgriNexus brand (deep greens, earth tones, cream/gold accents).
class AppColors {
  AppColors._();

  // Primary green palette
  static const Color primary = Color(0xFF012D1D); // Deep forest green
  static const Color primaryContainer = Color(0xFF1B4332); // Rich green
  static const Color primaryLight = Color(0xFF3F6653); // Medium green
  static const Color primaryFixedDim = Color(0xFFA5D0B9); // Soft mint

  // Secondary - earthy gold/amber (wheat accent)
  static const Color secondary = Color(0xFF934B00);
  static const Color secondaryContainer = Color(0xFFFD8603);
  static const Color gold = Color(0xFFE0A800);

  // Tertiary - olive/leaf green
  static const Color tertiary = Color(0xFF1E2B00);
  static const Color tertiaryContainer = Color(0xFF8FB339);

  // Surfaces / background
  static const Color background = Color(0xFFF8F9FA);
  static const Color surface = Color(0xFFF8F9FA);
  static const Color surfaceContainerLow = Color(0xFFF3F4F5);
  static const Color surfaceContainer = Color(0xFFEDEEEF);
  static const Color surfaceContainerHigh = Color(0xFFE7E8E9);
  static const Color cream = Color(0xFFFBF8F1);

  // Text colors
  static const Color onSurface = Color(0xFF191C1D);
  static const Color onSurfaceVariant = Color(0xFF414844);
  static const Color outline = Color(0xFF717973);
  static const Color outlineVariant = Color(0xFFC1C8C2);

  // Status colors
  static const Color error = Color(0xFFBA1A1A);
  static const Color success = Color(0xFF2E7D32);

  // Gradients
  static const LinearGradient splashGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF012D1D), Color(0xFF1B4332), Color(0xFF3F6653)],
  );

  static const LinearGradient welcomeGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF012D1D), Color(0xFF1B4332), Color(0xFF3F6653)],
  );

  static const LinearGradient goldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFD8603), Color(0xFFE0A800)],
  );

  static const LinearGradient greenButtonGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF3F6653), Color(0xFF1B4332)],
  );

  static const LinearGradient darkBackgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF0F172A),
      Color(0xFF111827),
      Color(0xFF1E293B),
    ],
  );

  // Glassmorphism helper colors
  static Color glassFill = Colors.white.withOpacity(0.12);
  static Color glassBorder = Colors.white.withOpacity(0.25);
  // ==========================
// DARK THEME
// ==========================

// Backgrounds
  static const Color darkBackground = Color(0xFF0F172A);
  static const Color darkSurface = Color(0xFF111827);
  static const Color darkCard = Color(0xFF1E293B);

// Text
  static const Color darkOnSurface = Color(0xFFF8FAFC);
  static const Color darkOnSurfaceVariant = Color(0xFFCBD5E1);

// Borders
  static const Color darkOutline = Color(0xFF334155);
  static const Color darkOutlineVariant = Color(0xFF475569);

// Brand
  static const Color darkPrimary = Color(0xFF2ECC71);
  static const Color darkPrimaryContainer = Color(0xFF1B4332);

// Status
  static const Color darkSuccess = Color(0xFF57CC99);
  static const Color darkWarning = Color(0xFFFFD166);
  static const Color darkError = Color(0xFFFF6B6B);
}
