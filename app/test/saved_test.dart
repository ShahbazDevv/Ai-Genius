import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/core/theme/theme_controller.dart';
import 'package:app/data/models/models.dart';
import 'package:app/modules/home/controllers/home_controller.dart';
import 'package:app/modules/saved/controllers/saved_controller.dart';
import 'package:app/modules/saved/views/saved_view.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    Get.testMode = true;
    Get.put(ThemeController());
    Get.put(HomeController());
    Get.put(SavedController());
  });

  tearDown(() {
    Get.reset();
  });

  final testProduct = Product(
    id: 'test_p_1',
    name: 'Handmade Scented Candle',
    description: 'Natural soy wax candle',
    price: 1500,
    currency: 'PKR',
    imageUrl: '',
    storeName: 'Daraz',
    storeUrl: 'https://daraz.pk',
    category: 'cat_home',
    tags: ['Home', 'Candle'],
    availability: 'In stock',
    source: 'Curated catalog',
    lastUpdated: '2026-10-02',
  );

  final testOldProduct = Product(
    id: 'test_old_p',
    name: 'Vintage Pocket Watch',
    description: 'Classic brass timepiece',
    price: 4500,
    currency: 'PKR',
    imageUrl: '',
    storeName: 'Bagallery',
    storeUrl: 'https://bagallery.com',
    category: 'cat_vintage',
    tags: ['Vintage'],
    availability: 'In stock',
    source: 'Curated catalog',
    lastUpdated: '2026-06-01', // Older than 45 days
  );

  final testCategory = GiftCategory(
    id: 'test_cat_1',
    name: 'Aromatherapy Sets',
    reason: 'Relaxing fragrances',
    productCount: 3,
    icon: 'spa',
  );

  group('SavedController Tests', () {
    test('Initial state contains seeded items', () {
      final controller = SavedController.to;
      expect(controller.savedProducts.isNotEmpty, isTrue);
      expect(controller.savedCategories.isNotEmpty, isTrue);
    });

    test('isProductSaved and toggleSaveProduct work accurately', () {
      final controller = SavedController.to;
      controller.clearAll();

      expect(controller.isProductSaved(testProduct.id), isFalse);
      controller.toggleSaveProduct(testProduct);
      expect(controller.isProductSaved(testProduct.id), isTrue);

      controller.toggleSaveProduct(testProduct);
      expect(controller.isProductSaved(testProduct.id), isFalse);
    });

    test('removeProduct removes item from list', () {
      final controller = SavedController.to;
      controller.clearAll();
      controller.toggleSaveProduct(testProduct);
      expect(controller.savedProducts.length, 1);

      controller.removeProduct(testProduct.id);
      expect(controller.savedProducts.isEmpty, isTrue);
    });

    test('isCategorySaved, toggleSaveCategory, and removeCategory work accurately', () {
      final controller = SavedController.to;
      controller.clearAll();

      expect(controller.isCategorySaved(testCategory.id), isFalse);
      controller.toggleSaveCategory(testCategory);
      expect(controller.isCategorySaved(testCategory.id), isTrue);

      controller.removeCategory(testCategory.id);
      expect(controller.isCategorySaved(testCategory.id), isFalse);
    });

    test('isOldItem identifies products older than 45 days', () {
      final controller = SavedController.to;
      expect(controller.isOldItem(testProduct), isFalse);
      expect(controller.isOldItem(testOldProduct), isTrue);
    });

    test('setTab switches tab index', () {
      final controller = SavedController.to;
      controller.setTab(1);
      expect(controller.selectedTab.value, 1);
      controller.setTab(0);
      expect(controller.selectedTab.value, 0);
    });
  });

  group('SavedView Widget Tests', () {
    testWidgets('Renders header, offline badge, tabs, and product cards', (WidgetTester tester) async {
      final controller = SavedController.to;
      controller.clearAll();
      controller.savedProducts.addAll([testProduct, testOldProduct]);
      controller.savedCategories.add(testCategory);

      await tester.pumpWidget(
        const GetMaterialApp(
          home: SavedView(),
        ),
      );

      // Verify Header
      expect(find.text('Saved Gifts'), findsOneWidget);
      expect(find.text('Available offline'), findsOneWidget);

      // Verify Tabs
      expect(find.text('Products (2)'), findsOneWidget);
      expect(find.text('Categories (1)'), findsOneWidget);

      // Verify Product Card details
      expect(find.text('Handmade Scented Candle'), findsOneWidget);
      expect(find.text('PKR 1,500'), findsOneWidget);
      expect(find.text('Vintage Pocket Watch'), findsOneWidget);
      expect(find.text('PKR 4,500'), findsOneWidget);

      // Verify "Link may no longer be valid" warning on old item
      expect(find.text('Link may no longer be valid'), findsOneWidget);
    });

    testWidgets('Switching to Categories tab displays saved categories', (WidgetTester tester) async {
      final controller = SavedController.to;
      controller.clearAll();
      controller.savedCategories.add(testCategory);

      await tester.pumpWidget(
        const GetMaterialApp(
          home: SavedView(),
        ),
      );

      // Tap Categories tab
      await tester.tap(find.text('Categories (1)'));
      await tester.pumpAndSettle();

      expect(find.text('Aromatherapy Sets'), findsOneWidget);
      expect(find.text('Relaxing fragrances'), findsOneWidget);
    });

    testWidgets('Empty state displays when no items are saved', (WidgetTester tester) async {
      final controller = SavedController.to;
      controller.clearAll();

      await tester.pumpWidget(
        const GetMaterialApp(
          home: SavedView(isEmbedded: true),
        ),
      );

      expect(find.text('No Saved Products'), findsOneWidget);
      expect(find.text('Find Gifts'), findsOneWidget);

      // Tap "Find Gifts" and verify it switches to Tab 0 (Home)
      final homeController = Get.find<HomeController>();
      homeController.changeTab(1);
      expect(homeController.currentTabIndex.value, 1);

      await tester.tap(find.text('Find Gifts'));
      await tester.pumpAndSettle();

      expect(homeController.currentTabIndex.value, 0);
    });
  });
}
