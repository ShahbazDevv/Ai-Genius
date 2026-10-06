import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as p;
import 'package:drift/native.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:app/core/theme/theme_controller.dart';
import 'package:app/data/local/app_database.dart';
import 'package:app/data/models/models.dart';
import 'package:app/data/repositories/history_repository.dart';
import 'package:app/data/repositories/saved_repository.dart';
import 'package:app/modules/history/controllers/history_controller.dart';
import 'package:app/modules/home/controllers/home_controller.dart';
import 'package:app/modules/product_detail/views/product_detail_view.dart';
import 'package:app/modules/results/views/results_view.dart';
import 'package:app/modules/saved/controllers/saved_controller.dart';
import 'package:app/modules/saved/views/saved_view.dart';
import 'package:app/routes/app_pages.dart';
import 'package:app/routes/app_routes.dart';

void main() {
  late Directory tempDir;
  late File dbFile;

  setUpAll(() {
    tempDir = Directory.systemTemp.createTempSync('drift_test_db_');
    dbFile = File(p.join(tempDir.path, 'ai_genius_test.sqlite'));
  });

  tearDownAll(() {
    if (tempDir.existsSync()) {
      tempDir.deleteSync(recursive: true);
    }
  });

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    Get.testMode = true;
  });

  tearDown(() {
    Get.reset();
  });

  final sampleProduct = Product(
    id: 'drift_prod_offline_001',
    name: 'Wireless Noise Canceling Headphones',
    description: 'Studio grade audio with 40-hour battery life and Bluetooth 5.3.',
    price: 18500.0,
    currency: 'PKR',
    imageUrl: 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e',
    storeName: 'Daraz Flagship',
    storeUrl: 'https://daraz.pk/product/headphones',
    category: 'cat_tech',
    tags: const ['Audio', 'Wireless', 'Noise Canceling'],
    availability: 'In stock',
    source: 'Curated catalog',
    lastUpdated: '2026-10-01',
  );

  final sampleOldProduct = Product(
    id: 'drift_prod_old_002',
    name: 'Vintage Mechanical Typewriter',
    description: 'Rare collectible 1970s working typewriter with ribbon.',
    price: 12000.0,
    currency: 'PKR',
    imageUrl: 'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5',
    storeName: 'Antique Corner',
    storeUrl: 'https://antiquecorner.pk/typewriter',
    category: 'cat_vintage',
    tags: const ['Vintage', 'Collectible'],
    availability: 'In stock',
    source: 'Curated catalog',
    lastUpdated: '2026-05-10', // Old link (> 45 days)
  );

  final sampleCategory = GiftCategory(
    id: 'drift_cat_001',
    name: 'Smart Gadgets & Audio',
    reason: 'Matches passion for audio technology.',
    productCount: 4,
    icon: 'headphones',
  );

  final sampleRequest = GiftRequest(
    relationship: 'Brother',
    ageGroup: '20-24',
    gender: 'Male',
    occasion: 'Graduation',
    budget: 20000.0,
    interests: const ['Technology', 'Music'],
    giftStyles: const ['Premium', 'Practical'],
    additionalDetails: 'Starting university next semester.',
  );

  final sampleRecommendation = Recommendation(
    id: 'drift_rec_001',
    category: sampleCategory,
    products: [sampleProduct],
    rank: 1,
    matchReason: 'Perfect graduation gift for brother interested in music & tech.',
  );

  group('Drift SQLite Schema & Direct Repository Operations', () {
    late AppDatabase db;
    late SqliteSavedRepository savedRepo;
    late SqliteHistoryRepository historyRepo;

    setUp(() {
      db = AppDatabase.inMemory();
      savedRepo = SqliteSavedRepository(db);
      historyRepo = SqliteHistoryRepository(db);
    });

    tearDown(() async {
      await db.close();
    });

    test('saved_items table stores full product info offline with status field', () async {
      // 1. Insert product with 'valid' status
      await savedRepo.saveProduct(sampleProduct, status: 'valid');

      final savedProducts = await savedRepo.getSavedProducts();
      expect(savedProducts.length, 1);
      final p1 = savedProducts.first;

      // Verify all product fields preserved for offline use
      expect(p1.id, sampleProduct.id);
      expect(p1.name, sampleProduct.name);
      expect(p1.description, sampleProduct.description);
      expect(p1.price, 18500.0);
      expect(p1.currency, 'PKR');
      expect(p1.storeName, sampleProduct.storeName);
      expect(p1.storeUrl, sampleProduct.storeUrl);
      expect(p1.tags, contains('Noise Canceling'));
      expect(p1.availability, 'In stock');

      // Verify status field
      final status1 = await savedRepo.getProductStatus(p1.id);
      expect(status1, 'valid');

      // 2. Insert older product with status 'link_may_be_invalid'
      await savedRepo.saveProduct(sampleOldProduct, status: 'link_may_be_invalid');
      final status2 = await savedRepo.getProductStatus(sampleOldProduct.id);
      expect(status2, 'link_may_be_invalid');

      // 3. Insert category into saved_items
      await savedRepo.saveCategory(sampleCategory);
      final savedCategories = await savedRepo.getSavedCategories();
      expect(savedCategories.length, 1);
      expect(savedCategories.first.name, 'Smart Gadgets & Audio');
      expect(savedCategories.first.reason, 'Matches passion for audio technology.');
    });

    test('history table stores title, subtitle, full request data, recommendations JSON, and date', () async {
      final historyItem = SearchHistoryItem.create(
        request: sampleRequest,
        recommendations: [sampleRecommendation],
        customId: 'drift_hist_001',
      );

      await historyRepo.addHistoryItem(historyItem);

      final items = await historyRepo.getAllHistory();
      expect(items.length, 1);

      final retrieved = items.first;
      expect(retrieved.id, 'drift_hist_001');
      expect(retrieved.title, 'Graduation Gift Search');
      expect(retrieved.subtitle, contains('Brother · Technology · PKR 20,000'));
      expect(retrieved.request.relationship, 'Brother');
      expect(retrieved.request.interests, contains('Music'));
      expect(retrieved.recommendations.length, 1);
      expect(retrieved.recommendations.first.category.name, 'Smart Gadgets & Audio');
      expect(retrieved.recommendations.first.products.first.name, sampleProduct.name);
    });

    test('History supports: open item, delete one item, clear all', () async {
      final item1 = SearchHistoryItem.create(
        request: sampleRequest,
        recommendations: [sampleRecommendation],
        customId: 'hist_item_1',
      );
      final item2 = SearchHistoryItem.create(
        request: GiftRequest(
          relationship: 'Friend',
          ageGroup: '25-29',
          occasion: 'Birthday',
          budget: 3500.0,
          interests: const ['Books'],
        ),
        recommendations: [],
        customId: 'hist_item_2',
      );

      await historyRepo.addHistoryItem(item1);
      await historyRepo.addHistoryItem(item2);
      expect((await historyRepo.getAllHistory()).length, 2);

      // 1. Open an item (fetch by ID)
      final opened = await historyRepo.getHistoryById('hist_item_1');
      expect(opened, isNotNull);
      expect(opened!.title, 'Graduation Gift Search');

      // 2. Delete one item
      await historyRepo.deleteHistoryItem('hist_item_1');
      final remaining = await historyRepo.getAllHistory();
      expect(remaining.length, 1);
      expect(remaining.first.id, 'hist_item_2');

      // 3. Clear all
      await historyRepo.clearHistory();
      final afterClear = await historyRepo.getAllHistory();
      expect(afterClear.isEmpty, isTrue);
    });
  });

  group('Closing and Reopening the App (Persistent Database)', () {
    test('Items saved to Drift SQLite persist after closing and reopening the app', () async {
      // PHASE 1: App session 1 (Open app, save items)
      final db1 = AppDatabase(NativeDatabase(dbFile));
      final savedRepo1 = SqliteSavedRepository(db1);
      final historyRepo1 = SqliteHistoryRepository(db1);

      final savedCtrl1 = SavedController(repository: savedRepo1);
      await savedCtrl1.init();
      final historyCtrl1 = HistoryController(repository: historyRepo1);
      await historyCtrl1.init();

      // Clear default seeds to start fresh
      await savedCtrl1.clearAll();
      await historyCtrl1.clearAll();
      expect(savedCtrl1.savedProducts.isEmpty, isTrue);
      expect(historyCtrl1.historyList.isEmpty, isTrue);

      // Save a product and a category in Session 1
      await savedCtrl1.toggleSaveProduct(sampleProduct);
      await savedCtrl1.toggleSaveProduct(sampleOldProduct, status: 'link_may_be_invalid');
      await savedCtrl1.toggleSaveCategory(sampleCategory);

      // Add a history item in Session 1
      await historyCtrl1.addSearch(
        request: sampleRequest,
        recommendations: [sampleRecommendation],
      );

      expect(savedCtrl1.savedProducts.length, 2);
      expect(savedCtrl1.savedCategories.length, 1);
      expect(historyCtrl1.historyList.length, 1);

      // CLOSE APP: close database connection and reset GetX
      await db1.close();
      Get.reset();

      // PHASE 2: App session 2 (Reopen app from the same SQLite file)
      final db2 = AppDatabase(NativeDatabase(dbFile));
      final savedRepo2 = SqliteSavedRepository(db2);
      final historyRepo2 = SqliteHistoryRepository(db2);

      final savedCtrl2 = SavedController(repository: savedRepo2);
      await savedCtrl2.init();
      final historyCtrl2 = HistoryController(repository: historyRepo2);
      await historyCtrl2.init();

      // Verify all items were persisted to SQLite and restored on reopen!
      expect(savedCtrl2.savedProducts.length, 2);
      expect(savedCtrl2.savedProducts.any((p) => p.name == sampleProduct.name), isTrue);
      expect(savedCtrl2.savedProducts.any((p) => p.name == sampleOldProduct.name), isTrue);

      // Verify status field persisted
      final reloadedStatus = await savedRepo2.getProductStatus(sampleOldProduct.id);
      expect(reloadedStatus, 'link_may_be_invalid');

      expect(savedCtrl2.savedCategories.length, 1);
      expect(savedCtrl2.savedCategories.first.name, 'Smart Gadgets & Audio');

      expect(historyCtrl2.historyList.length, 1);
      expect(historyCtrl2.historyList.first.title, 'Graduation Gift Search');
      expect(historyCtrl2.historyList.first.request.relationship, 'Brother');

      await db2.close();
    });
  });

  group('Airplane Mode / Offline Visibility & Navigation', () {
    late AppDatabase db;
    late SqliteSavedRepository savedRepo;
    late SqliteHistoryRepository historyRepo;
    late SavedController savedController;
    late HistoryController historyController;

    setUp(() async {
      db = AppDatabase.inMemory();
      savedRepo = SqliteSavedRepository(db);
      historyRepo = SqliteHistoryRepository(db);

      savedController = SavedController(repository: savedRepo);
      historyController = HistoryController(repository: historyRepo);

      Get.put<AppDatabase>(db, permanent: true);
      Get.put<SavedRepository>(savedRepo, permanent: true);
      Get.put<HistoryRepository>(historyRepo, permanent: true);
      Get.put<SavedController>(savedController, permanent: true);
      Get.put<HistoryController>(historyController, permanent: true);
      Get.put<ThemeController>(ThemeController(), permanent: true);
      Get.put<HomeController>(HomeController(), permanent: true);

      await savedController.init();
      await historyController.init();

      await savedController.clearAll();
      await historyController.clearAll();

      // Preload saved items into SQLite
      await savedController.toggleSaveProduct(sampleProduct, status: 'valid');
      await savedController.toggleSaveProduct(sampleOldProduct, status: 'link_may_be_invalid');
      await savedController.toggleSaveCategory(sampleCategory);

      // Preload history item into SQLite
      await historyController.addSearch(
        request: sampleRequest,
        recommendations: [sampleRecommendation],
      );
    });

    tearDown(() async {
      await db.close();
    });

    testWidgets('Saved gifts are visible and fully readable offline (Airplane mode simulated)', (tester) async {
      // Render SavedView without any network connection
      await tester.pumpWidget(
        const GetMaterialApp(
          home: SavedView(),
        ),
      );
      await tester.pumpAndSettle();

      // 1. Verify "Available offline" badge is displayed in header
      expect(find.text('Available offline'), findsOneWidget);

      // 2. Verify all offline product cards and details are rendered
      expect(find.text('Wireless Noise Canceling Headphones'), findsOneWidget);
      expect(find.text('PKR 18,500'), findsOneWidget);
      expect(find.text('Daraz Flagship'), findsOneWidget);

      expect(find.text('Vintage Mechanical Typewriter'), findsOneWidget);
      expect(find.text('PKR 12,000'), findsOneWidget);

      // 3. Verify status field: "Link may no longer be valid" badge is displayed for old/invalid link
      expect(find.text('Link may no longer be valid'), findsOneWidget);

      // 4. Verify "Offline" badge on product cards
      expect(find.text('Offline'), findsNWidgets(2));

      // 5. Switch to Categories tab offline
      await tester.tap(find.text('Categories (1)'));
      await tester.pumpAndSettle();

      expect(find.text('Smart Gadgets & Audio'), findsOneWidget);
      expect(find.text('Matches passion for audio technology.'), findsOneWidget);
    });

    testWidgets('Tapping a saved product opens product detail offline with full product info', (tester) async {
      tester.view.physicalSize = const Size(400, 1000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        GetMaterialApp(
          initialRoute: AppRoutes.saved,
          getPages: AppPages.routes,
        ),
      );
      await tester.pumpAndSettle();

      // Tap the first saved product card
      await tester.tap(find.text('Wireless Noise Canceling Headphones'));
      await tester.pumpAndSettle();

      // Verify Product Detail screen is open offline with full information
      expect(find.byType(ProductDetailView), findsOneWidget);
      expect(find.text('Wireless Noise Canceling Headphones'), findsOneWidget);
      expect(find.text('Studio grade audio with 40-hour battery life and Bluetooth 5.3.'), findsOneWidget);
      expect(find.text('Daraz Flagship'), findsOneWidget);
      expect(find.text('PKR 18,500'), findsOneWidget);
      await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -300));
      await tester.pumpAndSettle();
      expect(find.text('#Audio'), findsOneWidget);
      expect(find.text('#Wireless'), findsOneWidget);
    });

    testWidgets('History screen supports: open item, delete one item, clear all offline', (tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          initialRoute: AppRoutes.history,
          getPages: AppPages.routes,
        ),
      );
      await tester.pumpAndSettle();

      // Verify item in history
      expect(find.text('Graduation Gift Search'), findsOneWidget);
      expect(find.textContaining('Brother · Technology · PKR 20,000'), findsOneWidget);

      // 1. OPEN AN ITEM: tap history card
      await tester.tap(find.text('Graduation Gift Search'));
      await tester.pumpAndSettle();

      // Results view is opened offline with full recommendation data!
      expect(find.byType(ResultsView), findsOneWidget);
      expect(find.text('Smart Gadgets & Audio'), findsOneWidget);

      // Return to history
      Get.back();
      await tester.pumpAndSettle();

      // 2. DELETE ONE ITEM: delete single item from history
      final itemId = historyController.historyList.first.id;
      await historyController.deleteSearch(itemId);
      await tester.pumpAndSettle();

      // History is now empty
      expect(historyController.historyList.isEmpty, isTrue);
      expect(find.text('No Search History'), findsOneWidget);

      // 3. CLEAR ALL: re-add items and test clear all dialog
      await historyController.addSearch(
        request: sampleRequest,
        recommendations: [sampleRecommendation],
      );
      await tester.pumpAndSettle();
      expect(find.text('Graduation Gift Search'), findsOneWidget);

      // Tap Clear all
      await tester.tap(find.text('Clear all'));
      await tester.pumpAndSettle();

      expect(find.text('Clear All History?'), findsOneWidget);
      await tester.tap(find.widgetWithText(ElevatedButton, 'Clear All'));
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 4));
      await tester.pumpAndSettle();

      expect(historyController.historyList.isEmpty, isTrue);
      expect(find.text('No Search History'), findsOneWidget);
    });
  });
}
