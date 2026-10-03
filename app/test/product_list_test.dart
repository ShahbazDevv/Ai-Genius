import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/core/theme/theme_controller.dart';
import 'package:app/data/models/models.dart';
import 'package:app/modules/product_list/controllers/product_list_controller.dart';
import 'package:app/modules/product_list/views/product_list_view.dart';
import 'package:app/core/widgets/product_card.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    Get.testMode = true;
    Get.put(ThemeController());
  });

  tearDown(() {
    Get.reset();
  });

  final testProducts = [
    Product(
      id: 'p1',
      name: 'Budget Gift',
      description: 'Affordable item',
      price: 1500,
      imageUrl: '',
      storeName: 'Daraz',
      storeUrl: 'https://daraz.pk',
      category: 'cat1',
      tags: ['Budget', 'Gift'],
      availability: 'In stock',
      lastUpdated: '2026-10-02',
    ),
    Product(
      id: 'p2',
      name: 'Mid Gift Out of Stock',
      description: 'Mid item',
      price: 3000,
      imageUrl: 'https://example.com/item.jpg',
      storeName: 'Bagallery',
      storeUrl: 'https://bagallery.com',
      category: 'cat1',
      tags: ['Mid'],
      availability: 'Out of stock',
      lastUpdated: '2026-10-02',
    ),
    Product(
      id: 'p3',
      name: 'Expensive Gift Within Budget',
      description: 'Higher item',
      price: 4500,
      imageUrl: '',
      storeName: 'Daraz',
      storeUrl: 'https://daraz.pk',
      category: 'cat1',
      tags: ['Luxury'],
      availability: 'In stock',
      lastUpdated: '2026-10-02',
    ),
    Product(
      id: 'p4_overbudget',
      name: 'Over Budget Gift',
      description: 'Too expensive item',
      price: 8000, // Above budget 5000
      imageUrl: '',
      storeName: 'Daraz',
      storeUrl: 'https://daraz.pk',
      category: 'cat1',
      tags: ['OverBudget'],
      availability: 'In stock',
      lastUpdated: '2026-10-02',
    ),
  ];

  final testRecommendation = Recommendation(
    id: 'rec_test',
    category: GiftCategory(
      id: 'cat1',
      name: 'Tech & Gadgets',
      reason: 'Perfect for tech lovers',
      productCount: 4,
      icon: 'devices',
    ),
    products: testProducts,
    rank: 1,
    matchReason: 'Matches tech interest',
  );

  final testRequest = GiftRequest(
    relationship: 'Friend',
    ageGroup: '25-29',
    occasion: 'Birthday',
    budget: 5000.0,
    interests: ['Technology'],
  );

  group('ProductListController Tests', () {
    test('Strict budget invariant: products above budget are never included', () {
      final controller = ProductListController();
      controller.recommendation = testRecommendation;
      controller.request = testRequest;

      final products = controller.displayedProducts;
      // p4 has price 8000 > 5000, so it must not be included
      expect(products.any((p) => p.price > 5000), isFalse);
      expect(products.map((p) => p.id), containsAll(['p1', 'p2', 'p3']));
      expect(products.map((p) => p.id), isNot(contains('p4_overbudget')));
    });

    test('Availability filter excludes out of stock items', () {
      final controller = ProductListController();
      controller.recommendation = testRecommendation;
      controller.request = testRequest;

      expect(controller.displayedProducts.length, 3);

      controller.toggleInStockFilter();
      expect(controller.onlyInStock.value, isTrue);

      final inStockOnly = controller.displayedProducts;
      expect(inStockOnly.length, 2);
      expect(inStockOnly.every((p) => p.availability.toLowerCase().contains('in stock')), isTrue);
      expect(inStockOnly.any((p) => p.id == 'p2'), isFalse);
    });

    test('Sorting by Price Low to High and High to Low', () {
      final controller = ProductListController();
      controller.recommendation = testRecommendation;
      controller.request = testRequest;

      // Price Low to High
      controller.setSort(ProductSortOption.priceLowToHigh);
      var sorted = controller.displayedProducts;
      expect(sorted[0].price, 1500);
      expect(sorted[1].price, 3000);
      expect(sorted[2].price, 4500);

      // Price High to Low
      controller.setSort(ProductSortOption.priceHighToLow);
      sorted = controller.displayedProducts;
      expect(sorted[0].price, 4500);
      expect(sorted[1].price, 3000);
      expect(sorted[2].price, 1500);

      // Relevance resets to default order
      controller.setSort(ProductSortOption.relevance);
      sorted = controller.displayedProducts;
      expect(sorted[0].id, 'p1');
      expect(sorted[1].id, 'p2');
      expect(sorted[2].id, 'p3');
    });

    test('Toggle save product updates savedProductIds', () {
      final controller = ProductListController();
      controller.recommendation = testRecommendation;
      controller.request = testRequest;

      expect(controller.isProductSaved('p1'), isFalse);
      controller.toggleSaveProduct('p1');
      expect(controller.isProductSaved('p1'), isTrue);
      controller.toggleSaveProduct('p1');
      expect(controller.isProductSaved('p1'), isFalse);
    });

    test('resetFilters restores default sort and in-stock toggle', () {
      final controller = ProductListController();
      controller.recommendation = testRecommendation;
      controller.request = testRequest;

      controller.setSort(ProductSortOption.priceHighToLow);
      controller.toggleInStockFilter();
      expect(controller.selectedSort.value, ProductSortOption.priceHighToLow);
      expect(controller.onlyInStock.value, isTrue);

      controller.resetFilters();
      expect(controller.selectedSort.value, ProductSortOption.relevance);
      expect(controller.onlyInStock.value, isFalse);
    });
  });

  group('ProductListView Widget Tests', () {
    testWidgets('Renders header, budget chip, chips, and product cards', (WidgetTester tester) async {
      final controller = Get.put(ProductListController());
      controller.recommendation = testRecommendation;
      controller.request = testRequest;

      await tester.pumpWidget(
        const GetMaterialApp(
          home: ProductListView(),
        ),
      );

      // Verify category name and budget chip
      expect(find.text('Tech & Gadgets'), findsOneWidget);
      expect(find.text('Up to PKR 5,000'), findsOneWidget);

      // Verify sort chips
      expect(find.text('Relevance'), findsOneWidget);
      expect(find.text('Price: Low → High'), findsOneWidget);
      expect(find.text('Price: High → Low'), findsOneWidget);
      expect(find.text('In Stock Only'), findsOneWidget);

      // Verify products within budget are shown (p1, p2, p3)
      expect(find.text('Budget Gift'), findsOneWidget);
      expect(find.text('Mid Gift Out of Stock'), findsOneWidget);
      // Over budget product must NOT be found
      expect(find.text('Over Budget Gift'), findsNothing);

      // Verify formatted prices
      expect(find.text('PKR 1,500'), findsOneWidget);
      expect(find.text('PKR 3,000'), findsOneWidget);
    });

    testWidgets('Tapping In Stock Only filters out unavailable products', (WidgetTester tester) async {
      final controller = Get.put(ProductListController());
      controller.recommendation = testRecommendation;
      controller.request = testRequest;

      await tester.pumpWidget(
        const GetMaterialApp(
          home: ProductListView(),
        ),
      );

      expect(find.text('Mid Gift Out of Stock'), findsOneWidget);

      // Scroll and tap "In Stock Only" chip
      await tester.ensureVisible(find.text('In Stock Only'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('In Stock Only'));
      await tester.pumpAndSettle();

      // "Mid Gift Out of Stock" should no longer be visible
      expect(find.text('Mid Gift Out of Stock'), findsNothing);
      expect(find.text('Budget Gift'), findsOneWidget);
    });

    testWidgets('Empty state displays when no products match budget', (WidgetTester tester) async {
      final emptyRec = Recommendation(
        id: 'rec_empty',
        category: GiftCategory(
          id: 'cat_empty',
          name: 'Luxury Items',
          reason: 'Premium gifts',
          productCount: 0,
          icon: 'diamond',
        ),
        products: [
          Product(
            id: 'p_lux',
            name: 'Expensive Watch',
            description: 'Luxury watch',
            price: 50000,
            imageUrl: '',
            storeName: 'Store',
            storeUrl: 'https://store.pk',
            category: 'cat_empty',
            tags: ['Watch'],
            availability: 'In stock',
            lastUpdated: '2026-10-02',
          ),
        ],
        rank: 1,
      );

      final controller = Get.put(ProductListController());
      controller.recommendation = emptyRec;
      controller.request = testRequest; // Budget is 5000, watch is 50000

      await tester.pumpWidget(
        const GetMaterialApp(
          home: ProductListView(),
        ),
      );

      expect(find.text('No products found'), findsOneWidget);
      expect(find.text('Expensive Watch'), findsNothing);
    });

    testWidgets('ProductCard placeholder renders when image is missing or invalid', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProductCard(
              product: testProducts[0], // imageUrl is ''
              isSaved: false,
            ),
          ),
        ),
      );

      // Icon placeholder is shown
      expect(find.byIcon(Icons.card_giftcard_rounded), findsOneWidget);
      expect(find.text('Budget Gift'), findsOneWidget);
      expect(find.text('Daraz'), findsOneWidget);
      expect(find.text('PKR 1,500'), findsOneWidget);
    });
  });
}
