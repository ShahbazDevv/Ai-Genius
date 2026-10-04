import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';
import 'modules/history/controllers/history_controller.dart';
import 'modules/saved/controllers/saved_controller.dart';
import 'routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final themeController = ThemeController();
  await themeController.init();
  Get.put(themeController, permanent: true);
  Get.put(SavedController(), permanent: true);
  Get.put(HistoryController(), permanent: true);
  runApp(const AiGeniusApp());
}

class AiGeniusApp extends StatelessWidget {
  const AiGeniusApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = ThemeController.to;

    return Obx(
      () => GetMaterialApp(
        title: 'AI Genius',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: themeController.themeMode,
        initialRoute: AppPages.initial,
        getPages: AppPages.routes,
      ),
    );
  }
}
