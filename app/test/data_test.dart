import 'package:flutter_test/flutter_test.dart';
import 'package:app/data/models/models.dart';
import 'package:app/data/mock/mock_gift_repository.dart';

void main() {
  group('Data Models & JSON Serialization Tests', () {
    test('GiftRequest fromJson / toJson', () {
      final req = GiftRequest(
        relationship: 'Mother',
        ageGroup: '40-49',
        gender: 'Female',
        occasion: 'Birthday',
        budget: 5000.0,
        interests: ['Skincare', 'Books'],
        giftStyles: ['Self-Care', 'Elegant'],
        additionalDetails: 'Loves lavender scents',
      );

      final json = req.toJson();
      final fromJsonReq = GiftRequest.fromJson(json);

      expect(fromJsonReq.relationship, 'Mother');
      expect(fromJsonReq.budget, 5000.0);
      expect(fromJsonReq.interests, contains('Skincare'));
    });

    test('GiftCategory fromJson / toJson', () {
      final cat = GiftCategory(
        id: 'cat_test',
        name: 'Test Category',
        reason: 'Test reason',
        productCount: 3,
        icon: 'spa',
      );

      final json = cat.toJson();
      final fromJsonCat = GiftCategory.fromJson(json);

      expect(fromJsonCat.id, 'cat_test');
      expect(fromJsonCat.productCount, 3);
    });

    test('Product fromJson / toJson', () {
      final prod = Product(
        id: 'prod_test',
        name: 'Test Product',
        description: 'Description',
        price: 1500.0,
        currency: 'PKR',
        imageUrl: 'https://example.com/img.jpg',
        storeName: 'Daraz',
        storeUrl: 'https://daraz.pk',
        category: 'cat_skincare',
        tags: ['Beauty'],
        availability: 'In stock',
        source: 'Curated catalog',
        lastUpdated: '2026-10-02',
      );

      final json = prod.toJson();
      final fromJsonProd = Product.fromJson(json);

      expect(fromJsonProd.id, 'prod_test');
      expect(fromJsonProd.price, 1500.0);
      expect(fromJsonProd.tags, contains('Beauty'));
    });

    test('Recommendation fromJson / toJson', () {
      final rec = Recommendation(
        id: 'rec_01',
        category: GiftCategory(
          id: 'cat_1',
          name: 'Category 1',
          reason: 'Matches interest',
          productCount: 1,
          icon: 'spa',
        ),
        products: [
          Product(
            id: 'prod_1',
            name: 'P1',
            description: 'D1',
            price: 1200.0,
            imageUrl: 'img',
            storeName: 'Daraz',
            storeUrl: 'url',
            category: 'cat_1',
            lastUpdated: '2026-10-02',
          ),
        ],
        rank: 1,
        matchReason: 'Matches interest',
      );

      final json = rec.toJson();
      final fromJsonRec = Recommendation.fromJson(json);

      expect(fromJsonRec.id, 'rec_01');
      expect(fromJsonRec.products.length, 1);
      expect(fromJsonRec.category.name, 'Category 1');
    });
  });

  group('MockGiftRepository Recommendation Logic', () {
    final repo = MockGiftRepository();

    test('Strict budget filter: NO product exceeds request budget', () async {
      const budget = 3500.0;
      final req = GiftRequest(
        relationship: 'Mother',
        ageGroup: '40-49',
        occasion: 'Birthday',
        budget: budget,
        interests: ['Skincare', 'Books'],
      );

      final recommendations = await repo.getRecommendations(req);

      expect(recommendations, isNotEmpty);
      expect(recommendations.length, lessThanOrEqualTo(4));

      for (final rec in recommendations) {
        expect(rec.products, isNotEmpty);
        for (final product in rec.products) {
          expect(product.price, lessThanOrEqualTo(budget),
              reason: 'Product ${product.name} priced at ${product.price} exceeds budget $budget');
        }
      }
    });

    test('Empty result when budget is too low (never invent products)', () async {
      final req = GiftRequest(
        relationship: 'Friend',
        ageGroup: '20-24',
        occasion: 'Birthday',
        budget: 100.0, // lowest product in catalog is 950 PKR
        interests: ['Technology'],
      );

      final recommendations = await repo.getRecommendations(req);
      expect(recommendations, isEmpty);
    });
  });
}
