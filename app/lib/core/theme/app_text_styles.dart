import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  // Headings - Bold (700)
  static TextStyle headingLarge({Color color = AppColors.darkTextPrimary}) =>
      GoogleFonts.poppins(
        fontSize: 26.0,
        fontWeight: FontWeight.w700,
        color: color,
        letterSpacing: -0.5,
      );

  static TextStyle headingMedium({Color color = AppColors.darkTextPrimary}) =>
      GoogleFonts.poppins(
        fontSize: 20.0,
        fontWeight: FontWeight.w700,
        color: color,
        letterSpacing: -0.3,
      );

  static TextStyle headingSmall({Color color = AppColors.darkTextPrimary}) =>
      GoogleFonts.poppins(
        fontSize: 16.0,
        fontWeight: FontWeight.w700,
        color: color,
      );

  // Subheadings & Titles - Semi-bold (600)
  static TextStyle titleMedium({Color color = AppColors.darkTextPrimary}) =>
      GoogleFonts.poppins(
        fontSize: 16.0,
        fontWeight: FontWeight.w600,
        color: color,
      );

  static TextStyle titleSmall({Color color = AppColors.darkTextSecondary}) =>
      GoogleFonts.poppins(
        fontSize: 14.0,
        fontWeight: FontWeight.w600,
        color: color,
      );

  // Buttons - Semi-bold (600)
  static TextStyle button({Color color = AppColors.textOnYellow}) =>
      GoogleFonts.poppins(
        fontSize: 16.0,
        fontWeight: FontWeight.w600,
        color: color,
        letterSpacing: 0.2,
      );

  // Body - Regular (400)
  static TextStyle bodyLarge({Color color = AppColors.darkTextPrimary}) =>
      GoogleFonts.poppins(
        fontSize: 16.0,
        fontWeight: FontWeight.w400,
        color: color,
        height: 1.5,
      );

  static TextStyle bodyMedium({Color color = AppColors.darkTextSecondary}) =>
      GoogleFonts.poppins(
        fontSize: 14.0,
        fontWeight: FontWeight.w400,
        color: color,
        height: 1.4,
      );

  static TextStyle bodySmall({Color color = AppColors.darkTextMuted}) =>
      GoogleFonts.poppins(
        fontSize: 12.0,
        fontWeight: FontWeight.w400,
        color: color,
      );

  // Chip text
  static TextStyle chipSelected({Color color = AppColors.textOnYellow}) =>
      GoogleFonts.poppins(
        fontSize: 13.0,
        fontWeight: FontWeight.w600,
        color: color,
      );

  static TextStyle chipUnselected({Color color = AppColors.darkTextPrimary}) =>
      GoogleFonts.poppins(
        fontSize: 13.0,
        fontWeight: FontWeight.w500,
        color: color,
      );
}
