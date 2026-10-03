import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/core/theme/theme_controller.dart';
import 'package:app/data/models/models.dart';
import 'package:app/modules/product_detail/controllers/product_detail_controller.dart';
import 'package:app/modules/product_detail/views/product_detail_view.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    Get.testMode = true;
    Get.put(ThemeController());
  });

  tearDown(() {
    Get.reset();
  });

  final sampleAvailableProduct = Product(
    id: 'prod_test_01',
    name: 'Luxury Rose Quartz Face Roller',
    description: 'Natural authentic rose quartz healing stone roller for facial rejuvenation.',
    price: 3450,
    currency: 'PKR',
    imageUrl: '',
    storeName: 'Daraz',
    storeUrl: 'https://daraz.pk/product-123',
    category: 'cat_skincare',
    tags: ['Skincare', 'Beauty', 'Self-Care'],
    availability: 'In stock',
    source: 'Curated catalog',
    lastUpdated: '2026-10-02',
  );

  final sampleOutOfStockProduct = Product(
    id: 'prod_test_02',
    name: 'Wireless Bluetooth Earbuds Pro',
    description: 'High fidelity audio with active noise cancellation.',
    price: 4999,
    currency: 'PKR',
    imageUrl: 'https://example.com/earbuds.png',
    storeName: 'Telemart',
    storeUrl: 'https://telemart.pk/earbuds',
    category: 'cat_tech',
    tags: ['Tech', 'Audio'],
    availability: 'Out of stock',
    source: 'Verified partner',
    lastUpdated: '2026-10-02',
  );

  group('ProductDetailController Tests', () {
    test('Availability rule: strictly true only when availability says In stock', () {
      final controller = ProductDetailController();
      controller.product = sampleAvailableProduct;
      expect(controller.isAvailable, isTrue);

      controller.product = sampleOutOfStockProduct;
      expect(controller.isAvailable, isFalse);

      controller.product = Product(
        id: 'p3',
        name: 'Special Item',
        description: 'Desc',
        price: 1000,
        imageUrl: '',
        storeName: 'Store',
        storeUrl: '',
        category: 'cat',
        availability: 'Pre-order',
        lastUpdated: '2026-10-02',
      );
      expect(controller.isAvailable, isFalse);
    });

    test('Heart toggle saves and unsaves in memory', () {
      final controller = ProductDetailController();
      controller.product = sampleAvailableProduct;

      expect(controller.isSaved.value, isFalse);
      controller.toggleSave();
      expect(controller.isSaved.value, isTrue);
      controller.toggleSave();
      expect(controller.isSaved.value, isFalse);
    });

    test('openStoreUrl returns false and shows snackbar on empty storeUrl', () async {
      final controller = ProductDetailController();
      controller.product = Product(
        id: 'p_no_url',
        name: 'Item without link',
        description: 'Desc',
        price: 1000,
        imageUrl: '',
        storeName: 'Local Store',
        storeUrl: '',
        category: 'cat',
        availability: 'In stock',
        lastUpdated: '2026-10-02',
      );

      final result = await controller.openStoreUrl();
      expect(result, isFalse);
    });

    test('openStoreUrl handles launcher failure and exception gracefully', () async {
      final controller = ProductDetailController();
      controller.product = sampleAvailableProduct;

      // When launcher returns false
      final failResult = await controller.openStoreUrl(launcher: (_) async => false);
      expect(failResult, isFalse);

      // When launcher throws exception
      final errorResult = await controller.openStoreUrl(launcher: (_) async => throw Exception('Intent blocked'));
      expect(errorResult, isFalse);

      // When launcher succeeds
      final successResult = await controller.openStoreUrl(launcher: (_) async => true);
      expect(successResult, isTrue);
    });
  });

  group('ProductDetailView Widget Tests', () {
    testWidgets('Renders all product details, tags, store, and availability', (WidgetTester tester) async {
      final controller = Get.put(ProductDetailController());
      controller.product = sampleAvailableProduct;

      await tester.pumpWidget(
        const GetMaterialApp(
          home: ProductDetailView(),
        ),
      );

      // Check product name and formatted price
      expect(find.text('Luxury Rose Quartz Face Roller'), findsOneWidget);
      expect(find.text('PKR 3,450'), findsOneWidget);

      // Check store and availability badge
      expect(find.text('Daraz'), findsOneWidget);
      expect(find.text('In Stock'), findsOneWidget);

      // Check description
      expect(find.text(sampleAvailableProduct.description), findsOneWidget);

      // Check tags
      expect(find.text('#Skincare'), findsOneWidget);
      expect(find.text('#Beauty'), findsOneWidget);
      expect(find.text('#Self-Care'), findsOneWidget);

      // Check View on Store button and note
      expect(find.text('View on Store'), findsOneWidget);
      expect(find.text('Price and availability may change on the store.'), findsOneWidget);

      // Check image placeholder when imageUrl is empty
      expect(find.text('AI Genius Curated Gift'), findsOneWidget);
    });

    testWidgets('Does not claim available if availability is Out of stock', (WidgetTester tester) async {
      final controller = Get.put(ProductDetailController());
      controller.product = sampleOutOfStockProduct;

      await tester.pumpWidget(
        const GetMaterialApp(
          home: ProductDetailView(),
        ),
      );

      // Should show 'Out of stock' and NOT 'In Stock'
      expect(find.text('Out of stock'), findsOneWidget);
      expect(find.text('In Stock'), findsNothing);
    });

    testWidgets('Tapping heart button toggles saved state', (WidgetTester tester) async {
      final controller = Get.put(ProductDetailController());
      controller.product = sampleAvailableProduct;

      await tester.pumpWidget(
        const GetMaterialApp(
          home: ProductDetailView(),
        ),
      );

      expect(controller.isSaved.value, isFalse);

      // Heart outline icon initially
      expect(find.byIcon(Icons.favorite_border_rounded), findsOneWidget);

      // Tap heart button
      await tester.tap(find.byIcon(Icons.favorite_border_rounded));
      await tester.pumpAndSettle();

      expect(controller.isSaved.value, isTrue);
      expect(find.byIcon(Icons.favorite_rounded), findsOneWidget);
    });
  });
}
