import '../models/gift_category.dart';
import '../models/gift_request.dart';
import '../models/product.dart';
import '../models/recommendation.dart';
import '../repositories/gift_repository.dart';
import 'mock_data.dart';

class MockGiftRepository implements GiftRepository {
  @override
  Future<List<Recommendation>> getRecommendations(GiftRequest request) async {
    // Simulate AI processing delay
    await Future.delayed(const Duration(seconds: 3));

    // 1. Strict budget filter: NO product can exceed request.budget
    final List<Product> affordableProducts = MockData.products
        .where((product) => product.price <= request.budget)
        .toList();

    // If no products fit the budget, return empty result
    if (affordableProducts.isEmpty) {
      return [];
    }

    // 2. Group affordable products by category
    final Map<String, List<Product>> productsByCategory = {};
    for (final product in affordableProducts) {
      productsByCategory.putIfAbsent(product.category, () => []).add(product);
    }

    // 3. Score categories according to request criteria
    final List<MapEntry<GiftCategory, int>> categoryScores = [];

    final normalizedInterests = request.interests.map((e) => e.toLowerCase()).toSet();
    final normalizedStyles = request.giftStyles.map((e) => e.toLowerCase()).toSet();

    for (final category in MockData.categories) {
      final categoryProducts = productsByCategory[category.id];
      // Only consider categories that have at least one affordable product
      if (categoryProducts == null || categoryProducts.isEmpty) {
        continue;
      }

      int score = 0;
      final catNameLower = category.name.toLowerCase();

      // Check interest matches in category name
      for (final interest in normalizedInterests) {
        if (catNameLower.contains(interest)) {
          score += 10;
        }
      }

      // Check interest and style matches in product tags
      final allCategoryTags = categoryProducts
          .expand((p) => p.tags)
          .map((t) => t.toLowerCase())
          .toSet();

      for (final interest in normalizedInterests) {
        if (allCategoryTags.contains(interest)) {
          score += 8;
        }
      }

      for (final style in normalizedStyles) {
        if (allCategoryTags.contains(style)) {
          score += 5;
        }
      }

      // Bonus for having more variety within budget
      score += categoryProducts.length;

      categoryScores.add(MapEntry(category, score));
    }

    if (categoryScores.isEmpty) {
      return [];
    }

    // Sort categories by score descending
    categoryScores.sort((a, b) => b.value.compareTo(a.value));

    // 4. Take top 4 categories
    final topCategories = categoryScores.take(4).toList();

    // 5. Construct recommendations with personalized reason
    final List<Recommendation> recommendations = [];

    for (int i = 0; i < topCategories.length; i++) {
      final cat = topCategories[i].key;
      final prods = productsByCategory[cat.id]!;
      final rank = i + 1;

      // Create a friendly personalized reason
      String reason;
      final matchedInterest = request.interests.firstWhere(
        (interest) =>
            cat.name.toLowerCase().contains(interest.toLowerCase()) ||
            prods.any((p) => p.tags.any((t) => t.toLowerCase() == interest.toLowerCase())),
        orElse: () => '',
      );

      if (matchedInterest.isNotEmpty) {
        reason = 'Matches $matchedInterest interest and ${request.occasion.toLowerCase()} occasion.';
      } else {
        reason = 'Thoughtful match for ${request.relationship.toLowerCase()} on ${request.occasion.toLowerCase()}.';
      }

      final updatedCategory = cat.copyWith(
        productCount: prods.length,
        reason: reason,
      );

      recommendations.add(
        Recommendation(
          id: 'rec_${cat.id}',
          category: updatedCategory,
          products: prods,
          rank: rank,
          matchReason: reason,
        ),
      );
    }

    return recommendations;
  }
}
