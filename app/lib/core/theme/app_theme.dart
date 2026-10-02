import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';
import 'app_spacing.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get darkTheme {
    final textTheme = GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme).copyWith(
      displayLarge: TextStyle(color: AppColors.darkTextPrimary, fontWeight: FontWeight.w700),
      displayMedium: TextStyle(color: AppColors.darkTextPrimary, fontWeight: FontWeight.w700),
      headlineMedium: TextStyle(color: AppColors.darkTextPrimary, fontWeight: FontWeight.w700),
      titleLarge: TextStyle(color: AppColors.darkTextPrimary, fontWeight: FontWeight.w600),
      titleMedium: TextStyle(color: AppColors.darkTextPrimary, fontWeight: FontWeight.w600),
      titleSmall: TextStyle(color: AppColors.darkTextSecondary, fontWeight: FontWeight.w600),
      bodyLarge: TextStyle(color: AppColors.darkTextPrimary, fontWeight: FontWeight.w400),
      bodyMedium: TextStyle(color: AppColors.darkTextSecondary, fontWeight: FontWeight.w400),
      bodySmall: TextStyle(color: AppColors.darkTextMuted, fontWeight: FontWeight.w400),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.darkBgTop,
      cardColor: AppColors.darkCardSurface,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.yellowAccent,
        onPrimary: AppColors.textOnYellow,
        secondary: AppColors.yellowAccent,
        surface: AppColors.darkCardSurface,
        onSurface: AppColors.darkTextPrimary,
        error: AppColors.error,
        onError: Colors.white,
      ),
      textTheme: textTheme,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: AppColors.darkTextPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
        iconTheme: IconThemeData(color: AppColors.darkTextPrimary),
      ),
      cardTheme: const CardThemeData(
        color: AppColors.darkCardSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.borderRadiusCard,
          side: BorderSide(color: AppColors.darkCardBorder, width: 1),
        ),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: AppColors.yellowAccent,
        inactiveTrackColor: AppColors.darkCardBorder,
        thumbColor: AppColors.yellowAccent,
        overlayColor: AppColors.yellowSoftTint,
        trackHeight: 6.0,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10.0, elevation: 4.0),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.darkCardSurface,
        selectedItemColor: AppColors.yellowAccent,
        unselectedItemColor: AppColors.darkTextMuted,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
    );
  }

  static ThemeData get lightTheme {
    final textTheme = GoogleFonts.poppinsTextTheme(ThemeData.light().textTheme).copyWith(
      displayLarge: TextStyle(color: AppColors.lightTextPrimary, fontWeight: FontWeight.w700),
      displayMedium: TextStyle(color: AppColors.lightTextPrimary, fontWeight: FontWeight.w700),
      headlineMedium: TextStyle(color: AppColors.lightTextPrimary, fontWeight: FontWeight.w700),
      titleLarge: TextStyle(color: AppColors.lightTextPrimary, fontWeight: FontWeight.w600),
      titleMedium: TextStyle(color: AppColors.lightTextPrimary, fontWeight: FontWeight.w600),
      titleSmall: TextStyle(color: AppColors.lightTextSecondary, fontWeight: FontWeight.w600),
      bodyLarge: TextStyle(color: AppColors.lightTextPrimary, fontWeight: FontWeight.w400),
      bodyMedium: TextStyle(color: AppColors.lightTextSecondary, fontWeight: FontWeight.w400),
      bodySmall: TextStyle(color: AppColors.lightTextMuted, fontWeight: FontWeight.w400),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.lightBgTop,
      cardColor: AppColors.lightCardSurface,
      colorScheme: const ColorScheme.light(
        primary: AppColors.lightPrimary,
        onPrimary: Colors.white,
        secondary: AppColors.yellowAccent,
        onSecondary: AppColors.textOnYellow,
        surface: AppColors.lightCardSurface,
        onSurface: AppColors.lightTextPrimary,
        error: AppColors.error,
        onError: Colors.white,
      ),
      textTheme: textTheme,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: AppColors.lightTextPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
        iconTheme: IconThemeData(color: AppColors.lightTextPrimary),
      ),
      cardTheme: CardThemeData(
        color: AppColors.lightCardSurface,
        elevation: 2,
        shadowColor: AppColors.lightCardBorder.withValues(alpha: 0.4),
        shape: const RoundedRectangleBorder(
          borderRadius: AppSpacing.borderRadiusCard,
          side: BorderSide(color: AppColors.lightCardBorder, width: 1),
        ),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: AppColors.yellowAccent,
        inactiveTrackColor: AppColors.lightCardBorder,
        thumbColor: AppColors.yellowAccent,
        overlayColor: AppColors.yellowSoftTint,
        trackHeight: 6.0,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10.0, elevation: 4.0),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.lightCardSurface,
        selectedItemColor: AppColors.lightPrimary,
        unselectedItemColor: AppColors.lightTextMuted,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
    );
  }
}
