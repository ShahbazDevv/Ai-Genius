import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/core/theme/theme_controller.dart';
import 'package:app/modules/settings/controllers/settings_controller.dart';
import 'package:app/routes/app_pages.dart';
import 'package:app/routes/app_routes.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    Get.testMode = true;
    final themeController = ThemeController();
    Get.put<ThemeController>(themeController, permanent: true);
    Get.put<SettingsController>(SettingsController());
  });

  tearDown(() {
    Get.reset();
  });

  group('SettingsController Tests', () {
    test('Initial properties and values', () {
      final controller = SettingsController.to;
      expect(controller.appName, 'AI Genius');
      expect(controller.appVersion, '1.0.0');
      expect(controller.buildNumber, '1');
      expect(controller.appTagline, 'Gifts, chosen by AI');
      expect(controller.highlights.length, 4);
    });

    test('Theme switching updates ThemeController and persists in SharedPreferences', () async {
      final controller = SettingsController.to;
      final themeCtrl = ThemeController.to;

      // Switch to Light
      await controller.setThemeMode(ThemeMode.light);
      expect(themeCtrl.themeMode, ThemeMode.light);
      expect(controller.currentThemeMode, ThemeMode.light);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('app_theme_mode'), 'light');

      // Switch to System
      await controller.setThemeMode(ThemeMode.system);
      expect(themeCtrl.themeMode, ThemeMode.system);
      expect(prefs.getString('app_theme_mode'), 'system');

      // Switch to Dark
      await controller.setThemeMode(ThemeMode.dark);
      expect(themeCtrl.themeMode, ThemeMode.dark);
      expect(prefs.getString('app_theme_mode'), 'dark');
    });

    test('Theme persistence across app restarts', () async {
      SharedPreferences.setMockInitialValues({'app_theme_mode': 'light'});

      // Simulate cold restart with light theme saved
      final coldStartThemeController = ThemeController();
      await coldStartThemeController.init();

      expect(coldStartThemeController.themeMode, ThemeMode.light);
    });
  });

  group('SettingsView Widget Tests', () {
    testWidgets('Renders all sections: theme cards, about card, and app details', (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          initialRoute: AppRoutes.settings,
          getPages: AppPages.routes,
        ),
      );
      await tester.pumpAndSettle();

      // Top bar
      expect(find.text('Settings'), findsOneWidget);
      expect(find.text('v1.0.0'), findsWidgets);

      // Theme section
      expect(find.text('Theme'), findsOneWidget);
      expect(find.text('Dark'), findsOneWidget);
      expect(find.text('Light'), findsOneWidget);
      expect(find.text('System'), findsOneWidget);

      // About section
      expect(find.text('About'), findsOneWidget);
      expect(find.text('AI Genius'), findsWidgets);
      expect(find.text('Gifts, chosen by AI'), findsWidgets);
      expect(find.text('Smart AI Matching'), findsOneWidget);
      expect(find.text('Strict Budget Guardrails'), findsOneWidget);
      expect(find.text('Curated Online Stores'), findsOneWidget);
      expect(find.text('Offline Access'), findsOneWidget);

      // App details
      expect(find.text('App Details'), findsOneWidget);
      expect(find.text('App Version'), findsOneWidget);
      expect(find.text('1.0.0+1'), findsOneWidget);
      expect(find.text('Open Source Licenses'), findsOneWidget);
    });

    testWidgets('Tapping theme cards changes selected theme mode', (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          initialRoute: AppRoutes.settings,
          getPages: AppPages.routes,
        ),
      );
      await tester.pumpAndSettle();

      final themeCtrl = ThemeController.to;

      // Tap Light
      await tester.tap(find.text('Light'));
      await tester.pumpAndSettle();
      expect(themeCtrl.themeMode, ThemeMode.light);

      // Tap Dark
      await tester.tap(find.text('Dark'));
      await tester.pumpAndSettle();
      expect(themeCtrl.themeMode, ThemeMode.dark);

      // Tap System
      await tester.tap(find.text('System'));
      await tester.pumpAndSettle();
      expect(themeCtrl.themeMode, ThemeMode.system);
    });

    testWidgets('Back button navigates back', (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          initialRoute: AppRoutes.home,
          getPages: AppPages.routes,
        ),
      );
      await tester.pumpAndSettle();

      // Find settings icon in Home header and tap it
      final settingsIcon = find.byIcon(Icons.settings_outlined);
      expect(settingsIcon, findsOneWidget);
      await tester.tap(settingsIcon);
      await tester.pumpAndSettle();

      // Should be on Settings screen
      expect(find.text('Settings'), findsOneWidget);

      // Tap Back button
      final backButton = find.byIcon(Icons.arrow_back_rounded);
      expect(backButton, findsOneWidget);
      await tester.tap(backButton);
      await tester.pumpAndSettle();

      // Should be back on Home
      expect(find.text('Find the Perfect Gift'), findsOneWidget);
    });
  });
}
