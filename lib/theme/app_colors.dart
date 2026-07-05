import 'package:flutter/material.dart';

/// Color tokens from "The Kinetic Schematic" design system (DESIGN.md).
/// No pure black — surface (#131313) is the deepest background.
class AppColors {
  AppColors._();

  static const Color surface = Color(0xFF131313);
  static const Color surfaceContainerLow = Color(0xFF1C1B1B);
  static const Color surfaceContainer = Color(0xFF211F1F);
  static const Color surfaceContainerHigh = Color(0xFF2A2A2A);
  static const Color surfaceContainerHighest = Color(0xFF353534);

  static const Color primary = Color(0xFFB0C6FF);
  static const Color primaryContainer = Color(0xFF558DFF);
  static const Color onPrimary = Color(0xFF0A1547);
  static const Color onPrimaryContainer = Color(0xFFE0EAFF);

  static const Color tertiary = Color(0xFFFFBA38);
  static const Color tertiaryContainer = Color(0xFF3D2E00);
  static const Color onTertiary = Color(0xFF1A0F00);
  static const Color onTertiaryContainer = Color(0xFFFFBA38);

  static const Color error = Color(0xFFCF6679);
  static const Color errorContainer = Color(0xFF4E1826);
  static const Color onError = Color(0xFF1A0009);
  static const Color onErrorContainer = Color(0xFFFFB3BE);

  static const Color onSurface = Color(0xFFE8EAF0);
  static const Color onSurfaceVariant = Color(0xFF6B7280);

  static const Color outlineVariant = Color(0xFF424655);
  static const Color surfaceTint = Color(0xFFB0C6FF);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryContainer],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardHeroGradient = LinearGradient(
    colors: [surfaceContainerLow, surfaceContainerHigh],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const Color accentResistor = Color(0xFFFFB547);
  static const Color accentDiode = Color(0xFF34D399);
}
