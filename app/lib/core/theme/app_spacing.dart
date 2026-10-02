import 'package:flutter/material.dart';

class AppSpacing {
  AppSpacing._();

  // Corner Radii
  static const double radiusCard = 20.0;
  static const double radiusButton = 16.0;
  static const double radiusChip = 14.0;
  static const double radiusSmall = 8.0;
  static const double radiusLarge = 24.0;

  static const BorderRadius borderRadiusCard = BorderRadius.all(Radius.circular(radiusCard));
  static const BorderRadius borderRadiusButton = BorderRadius.all(Radius.circular(radiusButton));
  static const BorderRadius borderRadiusChip = BorderRadius.all(Radius.circular(radiusChip));

  // Spacing & Padding
  static const double screenPadding = 20.0;
  static const double sectionGap = 20.0;
  static const double itemGap = 16.0;
  static const double smallGap = 8.0;
  static const double tinyGap = 4.0;

  // Edge Insets Shortcuts
  static const EdgeInsets edgeInsetsScreen = EdgeInsets.all(screenPadding);
  static const EdgeInsets edgeInsetsCard = EdgeInsets.all(16.0);
  static const EdgeInsets edgeInsetsButton = EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0);
  static const EdgeInsets edgeInsetsChip = EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0);
}
