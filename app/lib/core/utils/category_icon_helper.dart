import 'package:flutter/material.dart';

/// Helper to convert backend category icon strings to Flutter Material icons.
///
/// Ensures any unknown or malformed icon string safely falls back to a generic
/// gift icon ([Icons.card_giftcard_rounded]) without crashing or throwing errors.
class CategoryIconHelper {
  CategoryIconHelper._();

  /// Generic fallback icon for unmapped or unknown category icons.
  static const IconData defaultIcon = Icons.card_giftcard_rounded;

  /// Converts a category icon string from the API to its corresponding [IconData].
  ///
  /// Falls back to [defaultIcon] if [iconName] is null, empty, or unmapped.
  static IconData getIcon(String? iconName) {
    if (iconName == null) {
      return defaultIcon;
    }

    switch (iconName.trim().toLowerCase()) {
      // API v1 category icons
      case 'spa':
        return Icons.spa_rounded;
      case 'bath':
        return Icons.bathtub_rounded;
      case 'brush':
        return Icons.brush_rounded;
      case 'devices':
        return Icons.devices_rounded;
      case 'smartphone':
        return Icons.smartphone_rounded;
      case 'menu_book':
        return Icons.menu_book_rounded;
      case 'fitness_center':
        return Icons.fitness_center_rounded;
      case 'diamond':
        return Icons.diamond_rounded;
      case 'sports_cricket':
        return Icons.sports_cricket_rounded;
      case 'sports_esports':
        return Icons.sports_esports_rounded;
      case 'home':
        return Icons.home_rounded;
      case 'restaurant':
        return Icons.restaurant_rounded;
      case 'checkroom':
        return Icons.checkroom_rounded;
      case 'coffee':
        return Icons.coffee_rounded;

      // New category icons
      case 'toys':
        return Icons.toys_rounded;
      case 'luggage':
        return Icons.luggage_rounded;
      case 'watch':
        return Icons.watch_rounded;
      case 'local_florist':
        return Icons.local_florist_rounded;
      case 'edit':
        return Icons.edit_rounded;
      case 'sports_soccer':
        return Icons.sports_soccer_rounded;
      case 'card_giftcard':
        return Icons.card_giftcard_rounded;

      // Safe fallback for any unknown string
      default:
        return defaultIcon;
    }
  }
}

/// Convenience top-level function.
IconData getCategoryIcon(String? iconName) => CategoryIconHelper.getIcon(iconName);
