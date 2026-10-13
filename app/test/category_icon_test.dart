import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app/core/utils/category_icon_helper.dart';

void main() {
  group('CategoryIconHelper Mappings & Fallback Tests', () {
    test('maps newly added category icon strings to closest Material icons', () {
      expect(CategoryIconHelper.getIcon('toys'), equals(Icons.toys_rounded));
      expect(CategoryIconHelper.getIcon('luggage'), equals(Icons.luggage_rounded));
      expect(CategoryIconHelper.getIcon('watch'), equals(Icons.watch_rounded));
      expect(CategoryIconHelper.getIcon('local_florist'), equals(Icons.local_florist_rounded));
      expect(CategoryIconHelper.getIcon('edit'), equals(Icons.edit_rounded));
      expect(CategoryIconHelper.getIcon('sports_soccer'), equals(Icons.sports_soccer_rounded));
      expect(CategoryIconHelper.getIcon('card_giftcard'), equals(Icons.card_giftcard_rounded));
    });

    test('maps all standard backend category icons correctly', () {
      expect(CategoryIconHelper.getIcon('spa'), equals(Icons.spa_rounded));
      expect(CategoryIconHelper.getIcon('bath'), equals(Icons.bathtub_rounded));
      expect(CategoryIconHelper.getIcon('brush'), equals(Icons.brush_rounded));
      expect(CategoryIconHelper.getIcon('devices'), equals(Icons.devices_rounded));
      expect(CategoryIconHelper.getIcon('smartphone'), equals(Icons.smartphone_rounded));
      expect(CategoryIconHelper.getIcon('menu_book'), equals(Icons.menu_book_rounded));
      expect(CategoryIconHelper.getIcon('fitness_center'), equals(Icons.fitness_center_rounded));
      expect(CategoryIconHelper.getIcon('diamond'), equals(Icons.diamond_rounded));
      expect(CategoryIconHelper.getIcon('sports_cricket'), equals(Icons.sports_cricket_rounded));
      expect(CategoryIconHelper.getIcon('sports_esports'), equals(Icons.sports_esports_rounded));
      expect(CategoryIconHelper.getIcon('home'), equals(Icons.home_rounded));
      expect(CategoryIconHelper.getIcon('restaurant'), equals(Icons.restaurant_rounded));
      expect(CategoryIconHelper.getIcon('checkroom'), equals(Icons.checkroom_rounded));
      expect(CategoryIconHelper.getIcon('coffee'), equals(Icons.coffee_rounded));
    });

    test('handles case insensitivity and surrounding whitespace gracefully', () {
      expect(CategoryIconHelper.getIcon('  TOYS  '), equals(Icons.toys_rounded));
      expect(CategoryIconHelper.getIcon('Luggage'), equals(Icons.luggage_rounded));
      expect(CategoryIconHelper.getIcon('SPORTS_SOCCER'), equals(Icons.sports_soccer_rounded));
      expect(CategoryIconHelper.getIcon('Edit'), equals(Icons.edit_rounded));
    });

    test('safely falls back to generic gift icon for unknown or invalid inputs without crashing', () {
      const fallbackIcon = Icons.card_giftcard_rounded;

      expect(CategoryIconHelper.getIcon('unknown_xyz'), equals(fallbackIcon));
      expect(CategoryIconHelper.getIcon('non_existent_category'), equals(fallbackIcon));
      expect(CategoryIconHelper.getIcon(''), equals(fallbackIcon));
      expect(CategoryIconHelper.getIcon('   '), equals(fallbackIcon));
      expect(CategoryIconHelper.getIcon(null), equals(fallbackIcon));
      expect(CategoryIconHelper.getIcon('12345'), equals(fallbackIcon));
    });

    test('convenience top-level getCategoryIcon function matches helper output', () {
      expect(getCategoryIcon('toys'), equals(Icons.toys_rounded));
      expect(getCategoryIcon('luggage'), equals(Icons.luggage_rounded));
      expect(getCategoryIcon('unknown'), equals(Icons.card_giftcard_rounded));
      expect(getCategoryIcon(null), equals(Icons.card_giftcard_rounded));
    });
  });
}
