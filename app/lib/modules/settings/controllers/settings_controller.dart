import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/theme_controller.dart';

class SettingsController extends GetxController {
  static SettingsController get to => Get.find<SettingsController>();

  final ThemeController _themeController = ThemeController.to;

  ThemeMode get currentThemeMode => _themeController.themeMode;

  final String appName = 'AI Genius';
  final String appTagline = 'Gifts, chosen by AI';
  final String appVersion = '1.0.0';
  final String buildNumber = '1';
  final String appDescription =
      'AI Genius helps you find thoughtful, personalized gifts in seconds. '
      'Tell us who you are shopping for, your budget, and their interests, '
      'and our smart recommendation engine will pick the best options tailored to your needs.';

  final List<Map<String, dynamic>> highlights = [
    {
      'icon': Icons.psychology_rounded,
      'title': 'Smart AI Matching',
      'description': 'Tailored gifts matched to recipient relationship, age, and interests.',
    },
    {
      'icon': Icons.account_balance_wallet_rounded,
      'title': 'Strict Budget Guardrails',
      'description': 'Gifts are guaranteed to stay within your specified PKR budget.',
    },
    {
      'icon': Icons.shopping_bag_rounded,
      'title': 'Curated Online Stores',
      'description': 'Direct store links to verified products and merchant outlets.',
    },
    {
      'icon': Icons.offline_pin_rounded,
      'title': 'Offline Access',
      'description': 'Saved gift items and past recommendations remain available offline.',
    },
  ];

  Future<void> setThemeMode(ThemeMode mode) async {
    await _themeController.setThemeMode(mode);
  }
}
