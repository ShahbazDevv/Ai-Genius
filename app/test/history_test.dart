import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/core/theme/theme_controller.dart';
import 'package:app/core/widgets/empty_state.dart';
import 'package:app/data/models/models.dart';
import 'package:app/modules/history/controllers/history_controller.dart';
import 'package:app/modules/home/controllers/home_controller.dart';
import 'package:app/modules/loading/controllers/loading_controller.dart';
import 'package:app/routes/app_pages.dart';
import 'package:app/routes/app_routes.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    Get.testMode = true;
    Get.put(ThemeController());
    Get.put(HomeController());
    Get.put(HistoryController());
  });

  tearDown(() {
    Get.reset();
  });

  final testRequest = GiftRequest(
    relationship: 'Mother',
    ageGroup: '40-49',
    gender: 'Female',
    occasion: 'Birthday',
    budget: 3500.0,
    interests: ['Beauty'],
  );

  final testRecommendation = Recommendation(
    id: 'test_rec_1',
    category: GiftCategory(
      id: 'cat_beauty',
      name: 'Beauty & Skincare',
      reason: 'Perfect for Mother on Birthday',
      productCount: 3,
      icon: 'spa',
    ),
    products: [
      Product(
        id: 'p_1',
        name: 'Organic Face Cream',
        description: 'Moisturizing cream',
        price: 2200.0,
        currency: 'PKR',
        imageUrl: '',
        storeName: 'Daraz',
        storeUrl: 'https://daraz.pk',
        category: 'cat_beauty',
        tags: ['Beauty'],
        availability: 'In stock',
        source: 'Curated catalog',
        lastUpdated: '2026-10-01',
      ),
    ],
    rank: 1,
    matchReason: 'Matches beauty interest and birthday occasion.',
  );

  group('SearchHistoryItem Model Tests', () {
    test('Builds title and subtitle matching design brief Section 8 exactly', () {
      final item = SearchHistoryItem.create(
        request: testRequest,
        recommendations: [testRecommendation],
      );

      expect(item.title, 'Birthday Gift Search');
      expect(item.subtitle, 'Mother · Beauty · PKR 3,500');
      expect(item.recommendations.length, 1);
    });

    test('formattedDate displays readable relative or short date', () {
      final now = DateTime.now();
      final itemToday = SearchHistoryItem.create(
        request: testRequest,
        recommendations: [],
        createdAt: now.subtract(const Duration(minutes: 5)),
      );
      expect(itemToday.formattedDate.contains('Today') || itemToday.formattedDate == 'Just now', isTrue);

      final itemYesterday = SearchHistoryItem.create(
        request: testRequest,
        recommendations: [],
        createdAt: now.subtract(const Duration(days: 1)),
      );
      expect(itemYesterday.formattedDate.contains('Yesterday'), isTrue);

      final itemOld = SearchHistoryItem.create(
        request: testRequest,
        recommendations: [],
        createdAt: DateTime(2026, 6, 15, 10, 30),
      );
      expect(itemOld.formattedDate, 'Jun 15, 2026');
    });

    test('JSON serialization and deserialization', () {
      final original = SearchHistoryItem.create(
        request: testRequest,
        recommendations: [testRecommendation],
        customId: 'item_test_json',
      );

      final json = original.toJson();
      final deserialized = SearchHistoryItem.fromJson(json);

      expect(deserialized.id, original.id);
      expect(deserialized.title, original.title);
      expect(deserialized.subtitle, original.subtitle);
      expect(deserialized.request.relationship, 'Mother');
      expect(deserialized.recommendations.length, 1);
    });
  });

  group('HistoryController Tests', () {
    test('Initial state contains seeded items', () {
      final controller = HistoryController.to;
      expect(controller.historyList.isNotEmpty, isTrue);
      expect(controller.historyList.first.title, contains('Gift Search'));
    });

    test('addSearch adds item to the beginning of the list', () {
      final controller = HistoryController.to;
      final initialCount = controller.historyList.length;

      final newReq = GiftRequest(
        relationship: 'Sister',
        ageGroup: '20-24',
        occasion: 'Graduation',
        budget: 5000.0,
        interests: ['Books'],
      );

      controller.addSearch(
        request: newReq,
        recommendations: [testRecommendation],
      );

      expect(controller.historyList.length, initialCount + 1);
      expect(controller.historyList.first.title, 'Graduation Gift Search');
      expect(controller.historyList.first.subtitle, 'Sister · Books · PKR 5,000');
    });

    test('deleteSearch removes item from history list', () {
      final controller = HistoryController.to;
      controller.clearAll();

      controller.addSearch(
        request: testRequest,
        recommendations: [testRecommendation],
      );

      expect(controller.historyList.length, 1);
      final id = controller.historyList.first.id;

      controller.deleteSearch(id);
      expect(controller.historyList.isEmpty, isTrue);
    });

    test('clearAll removes all items', () {
      final controller = HistoryController.to;
      expect(controller.historyList.isNotEmpty, isTrue);

      controller.clearAll();
      expect(controller.historyList.isEmpty, isTrue);
    });
  });

  group('LoadingController Integration Test', () {
    test('Completed analysis adds item to HistoryController', () async {
      final historyController = HistoryController.to;
      historyController.clearAll();
      expect(historyController.historyList.isEmpty, isTrue);

      // Create loading controller with test request - onInit initiates loadRecommendations
      final loadingController = LoadingController(initialRequest: testRequest);
      Get.put(loadingController);

      // Wait for mock analysis delay (MockGiftRepository has 3s delay)
      await Future.delayed(const Duration(milliseconds: 3500));

      // Verify that analysis was saved to history
      expect(historyController.historyList.length, 1);
      expect(historyController.historyList.first.request.occasion, 'Birthday');
      expect(historyController.historyList.first.request.relationship, 'Mother');
    });
  });

  group('HistoryView Widget Tests', () {
    testWidgets('Renders history items when list is not empty', (tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          initialRoute: AppRoutes.history,
          getPages: AppPages.routes,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Search History'), findsWidgets);
      expect(find.text('Birthday Gift Search'), findsOneWidget);
      expect(find.text('Mother · Beauty · PKR 3,500'), findsOneWidget);
      expect(find.text('Clear all'), findsOneWidget);
    });

    testWidgets('Shows empty state when history is cleared', (tester) async {
      final controller = HistoryController.to;
      controller.clearAll();

      await tester.pumpWidget(
        GetMaterialApp(
          initialRoute: AppRoutes.history,
          getPages: AppPages.routes,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(EmptyState), findsOneWidget);
      expect(find.text('No Search History'), findsOneWidget);
      expect(find.text('Start a Search'), findsOneWidget);
    });

    testWidgets('Clear all button opens confirmation dialog', (tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          initialRoute: AppRoutes.history,
          getPages: AppPages.routes,
        ),
      );
      await tester.pumpAndSettle();

      // Tap clear all
      final clearAllBtn = find.text('Clear all');
      expect(clearAllBtn, findsOneWidget);
      await tester.tap(clearAllBtn);
      await tester.pumpAndSettle();

      // Verify confirmation dialog appeared
      expect(find.text('Clear All History?'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Clear All'), findsOneWidget);

      // Tap Clear All in dialog
      await tester.tap(find.widgetWithText(ElevatedButton, 'Clear All'));
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 4));
      await tester.pumpAndSettle();

      // Should now be in empty state
      expect(find.byType(EmptyState), findsOneWidget);
      expect(HistoryController.to.historyList.isEmpty, isTrue);
    });
  });
}
