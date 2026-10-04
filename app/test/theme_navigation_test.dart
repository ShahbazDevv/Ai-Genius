import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/core/theme/theme_controller.dart';
import 'package:app/main.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    Get.testMode = true;
    Get.put(ThemeController());
  });

  tearDown(() {
    Get.reset();
  });

  testWidgets('Theme change does not reset route stack', (WidgetTester tester) async {
    await tester.pumpWidget(const AiGeniusApp());
    await tester.pump(const Duration(milliseconds: 2500));
    await tester.pumpAndSettle();

    // Verify on Home
    expect(find.text('Find the Perfect Gift'), findsOneWidget);

    // Change theme mode
    ThemeController.to.setThemeMode(ThemeMode.light);
    await tester.pumpAndSettle();

    // Verify still on Home, not reset to Splash!
    expect(find.text('Find the Perfect Gift'), findsOneWidget);
  });
}
