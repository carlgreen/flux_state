import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Typography system from DESIGN.md.
/// Space Grotesk: display, headlines, technical labels (monospaced feel).
/// Inter: body text, descriptions.
class AppTypography {
  AppTypography._();

  static TextStyle get displayLarge => GoogleFonts.spaceGrotesk(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.64,
    color: AppColors.onSurface,
  );

  static TextStyle get displayMedium => GoogleFonts.spaceGrotesk(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.48,
    color: AppColors.onSurface,
  );

  static TextStyle get titleLarge => GoogleFonts.spaceGrotesk(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.4,
    color: AppColors.onSurface,
  );

  static TextStyle get titleMedium => GoogleFonts.spaceGrotesk(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.32,
    color: AppColors.onSurface,
  );

  static TextStyle get labelLarge => GoogleFonts.spaceGrotesk(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.05,
    color: AppColors.onSurface,
  );

  static TextStyle get labelMedium => GoogleFonts.spaceGrotesk(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.05,
    color: AppColors.onSurface,
  );

  static TextStyle get labelSmall => GoogleFonts.spaceGrotesk(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.08,
    color: AppColors.onSurfaceVariant,
  );

  static TextStyle get bodyLarge => GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.onSurface,
  );

  static TextStyle get bodyMedium => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.onSurface,
  );

  static TextStyle get bodySmall => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.onSurfaceVariant,
  );

  /// Large stock count display.
  static TextStyle get stockNumber => GoogleFonts.spaceGrotesk(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    color: AppColors.onSurface,
  );
}
