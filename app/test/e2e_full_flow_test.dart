import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/core/theme/app_colors.dart';
import 'package:app/core/theme/app_theme.dart';
import 'package:app/core/theme/theme_controller.dart';
import 'package:app/core/widgets/app_button.dart';
import 'package:app/core/widgets/selectable_chip.dart';
import 'package:app/data/models/models.dart';
import 'package:app/modules/history/controllers/history_controller.dart';
import 'package:app/modules/home/controllers/home_controller.dart';
import 'package:app/modules/home/views/home_view.dart';
import 'package:app/modules/product_detail/controllers/product_detail_controller.dart';
import 'package:app/modules/product_detail/views/product_detail_view.dart';
import 'package:app/modules/product_list/controllers/product_list_controller.dart';
import 'package:app/modules/product_list/views/product_list_view.dart';
import 'package:app/modules/results/controllers/results_controller.dart';
import 'package:app/modules/results/views/results_view.dart';
import 'package:app/modules/saved/controllers/saved_controller.dart';
import 'package:app/modules/settings/controllers/settings_controller.dart';
import 'package:app/modules/settings/views/settings_view.dart';
import 'package:app/modules/splash/controllers/splash_controller.dart';
import 'package:app/modules/splash/views/splash_view.dart';
import 'package:app/routes/app_pages.dart';
import 'package:app/routes/app_routes.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    Get.testMode = true;
  });

  tearDown(() {
    Get.reset();
  });

  testWidgets('E2E Full Journey: Splash -> Home -> Fill Form -> Analyze -> Results -> Product List -> Product Detail -> Save -> Saved Tab -> History Tab -> Settings Theme Switch',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    // 1. Initialize Core Singletons
    final themeCtrl = Get.put(ThemeController());
    final savedCtrl = Get.put(SavedController());
    final historyCtrl = Get.put(HistoryController());

    // 2. Launch App starting at SplashView
    Get.put(SplashController());
    await tester.pumpWidget(
      GetMaterialApp(
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.dark,
        initialRoute: AppRoutes.splash,
        getPages: AppPages.routes,
      ),
    );

    // Verify Splash Screen
    expect(find.byType(SplashView), findsOneWidget);
    expect(find.text('AI Genius'), findsOneWidget);
    expect(find.text('Gifts, chosen by AI'), findsOneWidget);

    // Advance Splash timer (2000ms + margin)
    await tester.pump(const Duration(milliseconds: 2200));
    await tester.pumpAndSettle();

    // Verify Navigation to Home
    expect(find.byType(HomeView), findsOneWidget);
    final homeCtrl = Get.find<HomeController>();

    // 3. Fill Home Form
    // Relationship: Mother
    homeCtrl.setRelationship('Mother');
    // Age Group: 40-49
    homeCtrl.setAgeGroup('40-49');
    // Gender: Female
    homeCtrl.setGender('Female');
    // Occasion: Birthday
    homeCtrl.setOccasion('Birthday');
    // Budget: 5000
    homeCtrl.setBudget(5000);
    // Interest: Skincare
    homeCtrl.toggleInterest('Skincare');
    // Gift Style: Thoughtful
    homeCtrl.toggleGiftStyle('Thoughtful');

    await tester.pump();
    expect(homeCtrl.isValid, isTrue);

    // Verify Sticky Button is enabled
    final analyzeButtonFinder = find.widgetWithText(AppButton, 'Analyze Gifts');
    expect(analyzeButtonFinder, findsOneWidget);

    // 4. Tap Analyze Gifts -> triggers Loading -> Results
    await tester.tap(analyzeButtonFinder);
    await tester.pump();
    // Simulate loading completion and async delay
    await tester.pump(const Duration(milliseconds: 2500));
    await tester.pumpAndSettle();

    // Verify Results Screen reached
    expect(find.byType(ResultsView), findsOneWidget);
    final resultsCtrl = Get.find<ResultsController>();
    expect(resultsCtrl.recommendations.isNotEmpty, isTrue);
    expect(find.text('Your AI Gift Suggestions'), findsOneWidget);

    // Verify summary chip row
    expect(find.textContaining('Mother · Birthday'), findsOneWidget);

    // 5. Pick a Category (tap on first card)
    final firstRec = resultsCtrl.recommendations.first;
    resultsCtrl.openCategory(firstRec);
    await tester.pumpAndSettle();

    // Verify Product List Screen reached
    expect(find.byType(ProductListView), findsOneWidget);
    final productListCtrl = Get.find<ProductListController>();
    expect(productListCtrl.displayedProducts.isNotEmpty, isTrue);
    expect(find.text(firstRec.category.name), findsOneWidget);

    // 6. Open Product Detail
    final firstProduct = productListCtrl.displayedProducts.first;
    productListCtrl.openProductDetail(firstProduct);
    await tester.pumpAndSettle();

    // Verify Product Detail Screen reached
    expect(find.byType(ProductDetailView), findsOneWidget);
    final detailCtrl = Get.find<ProductDetailController>();
    expect(find.text(firstProduct.name), findsOneWidget);
    expect(find.text('View on Store'), findsOneWidget);

    // 7. Save Product (toggle saved heart)
    final initiallySaved = detailCtrl.isSaved.value;
    detailCtrl.toggleSave();
    expect(detailCtrl.isSaved.value, !initiallySaved);
    if (!detailCtrl.isSaved.value) {
      detailCtrl.toggleSave();
    }
    expect(detailCtrl.isSaved.value, isTrue);
    expect(savedCtrl.isProductSaved(firstProduct.id), isTrue);

    // 8. Go back to Home
    Get.until((route) => route.settings.name == AppRoutes.home);
    await tester.pumpAndSettle();
    expect(find.byType(HomeView), findsOneWidget);

    // 9. Switch to Saved Tab (Index 1)
    homeCtrl.changeTab(1);
    await tester.pumpAndSettle();
    expect(homeCtrl.currentTabIndex.value, 1);
    expect(savedCtrl.savedProducts.any((p) => p.id == firstProduct.id), isTrue);

    // 10. Switch to History Tab (Index 2)
    homeCtrl.changeTab(2);
    await tester.pumpAndSettle();
    expect(homeCtrl.currentTabIndex.value, 2);
    expect(historyCtrl.historyList.isNotEmpty, isTrue);
    expect(historyCtrl.historyList.first.request.relationship, 'Mother');

    // 11. Open Settings & Switch Theme
    Get.toNamed(AppRoutes.settings);
    await tester.pumpAndSettle();
    expect(find.byType(SettingsView), findsOneWidget);

    // Switch to Light Theme
    themeCtrl.setThemeMode(ThemeMode.light);
    await tester.pumpAndSettle();
    expect(themeCtrl.themeMode, ThemeMode.light);

    // Switch back to Dark Theme
    themeCtrl.setThemeMode(ThemeMode.dark);
    await tester.pumpAndSettle();
    expect(themeCtrl.themeMode, ThemeMode.dark);

    // Return to Home
    Get.back();
    await tester.pumpAndSettle();
    expect(find.byType(HomeView), findsOneWidget);
  });
}
