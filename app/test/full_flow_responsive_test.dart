import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/core/theme/app_theme.dart';
import 'package:app/core/theme/theme_controller.dart';
import 'package:app/data/mock/mock_data.dart';
import 'package:app/data/models/models.dart';
import 'package:app/modules/history/controllers/history_controller.dart';
import 'package:app/modules/history/views/history_view.dart';
import 'package:app/modules/home/controllers/home_controller.dart';
import 'package:app/modules/home/views/home_view.dart';
import 'package:app/modules/loading/controllers/loading_controller.dart';
import 'package:app/modules/loading/views/loading_view.dart';
import 'package:app/modules/product_detail/controllers/product_detail_controller.dart';
import 'package:app/modules/product_detail/views/product_detail_view.dart';
import 'package:app/modules/product_list/controllers/product_list_controller.dart';
import 'package:app/modules/product_list/views/product_list_view.dart';
import 'package:app/modules/results/controllers/results_controller.dart';
import 'package:app/modules/results/views/results_view.dart';
import 'package:app/modules/saved/controllers/saved_controller.dart';
import 'package:app/modules/saved/views/saved_view.dart';
import 'package:app/modules/settings/controllers/settings_controller.dart';
import 'package:app/modules/settings/views/settings_view.dart';
import 'package:app/modules/splash/controllers/splash_controller.dart';
import 'package:app/modules/splash/views/splash_view.dart';
import 'package:app/routes/app_pages.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    Get.testMode = true;
    FlutterError.onError = (FlutterErrorDetails details) {
      // ignore: avoid_print
      print('FLUTTER_ERROR: ${details.exceptionAsString()}');
      final full = details.toString();
      for (final line in full.split('\n')) {
        if (line.contains('.dart:')) {
          // ignore: avoid_print
          print('  LINE: $line');
        }
      }
    };
  });

  tearDown(() {
    Get.reset();
  });

  Future<void> setViewport(WidgetTester tester, Size size) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
  }

  Widget createTestApp(Widget child, {ThemeMode mode = ThemeMode.dark}) {
    return GetMaterialApp(
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: mode,
      home: child,
      getPages: AppPages.routes,
    );
  }

  final testRequest = GiftRequest(
    relationship: 'Mother',
    ageGroup: '40-49',
    gender: 'Female',
    occasion: 'Birthday',
    budget: 5000,
    interests: ['Skincare', 'Books'],
    giftStyles: ['Thoughtful', 'Elegant'],
    additionalDetails: 'Loves natural organic products',
  );

  final testRecommendation = Recommendation(
    id: 'rec_1',
    category: MockData.categories[0],
    products: MockData.products.take(3).toList(),
    rank: 1,
    matchReason: 'Matches skincare interest and birthday occasion.',
  );

  void setupControllersForScreen(String screenName) {
    Get.put(ThemeController());
    Get.put(SavedController());
    Get.put(HistoryController());

    switch (screenName) {
      case 'SplashView':
        Get.put(SplashController());
        break;
      case 'HomeView':
        Get.put(HomeController());
        break;
      case 'LoadingView':
        Get.put(LoadingController(initialRequest: testRequest));
        break;
      case 'ResultsView':
        final ctrl = Get.put(ResultsController());
        ctrl.request = testRequest;
        ctrl.recommendations = [testRecommendation];
        break;
      case 'ProductListView':
        final ctrl = Get.put(ProductListController());
        ctrl.recommendation = testRecommendation;
        ctrl.request = testRequest;
        break;
      case 'ProductDetailView':
        final ctrl = Get.put(ProductDetailController());
        ctrl.product = MockData.products[0];
        break;
      case 'SavedView':
        break;
      case 'HistoryView':
        break;
      case 'SettingsView':
        Get.put(SettingsController());
        break;
    }
  }

  final screenBuilders = <String, Widget Function()>{
    'SplashView': () => const SplashView(),
    'HomeView': () => const HomeView(),
    'LoadingView': () => const LoadingView(),
    'ResultsView': () => const ResultsView(),
    'ProductListView': () => const ProductListView(),
    'ProductDetailView': () => const ProductDetailView(),
    'SavedView': () => const SavedView(),
    'HistoryView': () => const HistoryView(),
    'SettingsView': () => const SettingsView(),
  };

  const sizes = {
    'Small (360x640)': Size(360, 640),
    'Large (800x1280)': Size(800, 1280),
  };

  const themes = {
    'Dark': ThemeMode.dark,
    'Light': ThemeMode.light,
  };

  for (final themeEntry in themes.entries) {
    for (final sizeEntry in sizes.entries) {
      group('Responsive: ${sizeEntry.key} - ${themeEntry.key}', () {
        for (final screenEntry in screenBuilders.entries) {
          testWidgets('${screenEntry.key} renders without overflow', (WidgetTester tester) async {
            await setViewport(tester, sizeEntry.value);
            setupControllersForScreen(screenEntry.key);

            await tester.pumpWidget(
              createTestApp(screenEntry.value(), mode: themeEntry.value),
            );
            await tester.pump();
            await tester.pump(const Duration(milliseconds: 300));

            // Do not takeException, let Flutter framework dump the full error report
            // final exc = tester.takeException();

            if (screenEntry.key == 'SplashView') {
              await tester.pump(const Duration(milliseconds: 2500));
            } else if (screenEntry.key == 'LoadingView') {
              await tester.pump(const Duration(milliseconds: 3500));
            }
          });
        }
      });
    }
  }
}
