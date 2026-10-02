import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends GetxController {
  static ThemeController get to => Get.find<ThemeController>();

  static const String _themeKey = 'app_theme_mode';

  final Rx<ThemeMode> _themeMode = ThemeMode.dark.obs;
  ThemeMode get themeMode => _themeMode.value;

  bool get isDarkMode {
    if (_themeMode.value == ThemeMode.system) {
      return WidgetsBinding.instance.platformDispatcher.platformBrightness == Brightness.dark;
    }
    return _themeMode.value == ThemeMode.dark;
  }

  @override
  void onInit() {
    super.onInit();
    _loadThemeFromPrefs();
  }

  Future<void> _loadThemeFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTheme = prefs.getString(_themeKey);

    if (savedTheme != null) {
      switch (savedTheme) {
        case 'light':
          _themeMode.value = ThemeMode.light;
          break;
        case 'dark':
          _themeMode.value = ThemeMode.dark;
          break;
        case 'system':
          _themeMode.value = ThemeMode.system;
          break;
      }
    } else {
      _themeMode.value = ThemeMode.dark; // Default to dark as per brief
    }
    Get.changeThemeMode(_themeMode.value);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode.value = mode;
    Get.changeThemeMode(mode);

    final prefs = await SharedPreferences.getInstance();
    String modeString = 'dark';
    if (mode == ThemeMode.light) {
      modeString = 'light';
    } else if (mode == ThemeMode.system) {
      modeString = 'system';
    }
    await prefs.setString(_themeKey, modeString);
  }
}
