import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';
import 'data/local/app_database.dart';
import 'data/repositories/history_repository.dart';
import 'data/repositories/saved_repository.dart';
import 'modules/history/controllers/history_controller.dart';
import 'modules/saved/controllers/saved_controller.dart';
import 'routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final themeController = ThemeController();
  await themeController.init();
  Get.put(themeController, permanent: true);

  final database = AppDatabase();
  Get.put<AppDatabase>(database, permanent: true);

  final savedRepository = SqliteSavedRepository(database);
  Get.put<SavedRepository>(savedRepository, permanent: true);

  final historyRepository = SqliteHistoryRepository(database);
  Get.put<HistoryRepository>(historyRepository, permanent: true);

  final savedController = SavedController(repository: savedRepository);
  await savedController.init();
  Get.put(savedController, permanent: true);

  final historyController = HistoryController(repository: historyRepository);
  await historyController.init();
  Get.put(historyController, permanent: true);

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
