import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Dark Mode Palette
  static const Color darkBgTop = Color(0xFF1A0B2E);
  static const Color darkBgBottom = Color(0xFF34155E);
  static const Color darkBlob = Color(0x406B2FBF); // #6B2FBF at 25% opacity
  static const Color darkCardSurface = Color(0xFF2A1250);
  static const Color darkCardBorder = Color(0xFF4A2A80);
  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFFCFC3E8);
  static const Color darkTextMuted = Color(0xFF9C8BBF);

  // Light Mode Palette
  static const Color lightBgTop = Color(0xFFF7F2FF);
  static const Color lightBgBottom = Color(0xFFE9DDFF);
  static const Color lightCardSurface = Color(0xFFFFFFFF);
  static const Color lightCardBorder = Color(0xFFE0D3F5);
  static const Color lightPrimary = Color(0xFF4B1D8F);
  static const Color lightTextPrimary = Color(0xFF1A0B2E);
  static const Color lightTextSecondary = Color(0xFF5B4A7A);
  static const Color lightTextMuted = Color(0xFF8E7FAA);

  // Shared Accents & Highlights
  static const Color yellowAccent = Color(0xFFFFC93C);
  static const Color yellowPressed = Color(0xFFFFB300);
  static const Color yellowSoftTint = Color(0x26FFC93C); // 15% opacity
  static const Color textOnYellow = Color(0xFF1A0B2E); // Deep purple on yellow

  // Functional Status Colors
  static const Color success = Color(0xFF4ADE80);
  static const Color error = Color(0xFFFF6B6B);

  // Text color for budget, price, and highlighted text (contrast rule)
  static Color highlightText(bool isDark) => isDark ? yellowAccent : lightPrimary;
}
