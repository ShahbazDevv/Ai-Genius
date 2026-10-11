import 'gift_category.dart';
import 'product.dart';

class Recommendation {
  final String id;
  final GiftCategory category;
  final List<Product> products;
  final int rank;
  final String? matchReason;

  Recommendation({
    required this.id,
    required this.category,
    required this.products,
    required this.rank,
    this.matchReason,
  });

  factory Recommendation.fromJson(Map<String, dynamic> json) {
    GiftCategory category;
    if (json.containsKey('category') && json['category'] is Map) {
      category = GiftCategory.fromJson(json['category'] as Map<String, dynamic>);
    } else {
      category = GiftCategory.fromJson(json);
    }

    final productsList = (json['products'] as List<dynamic>?)
            ?.map((e) => Product.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];

    final resolvedReason = (json['match_reason'] ?? json['matchReason'] ?? json['reason']) as String?;

    return Recommendation(
      id: json['id'] as String? ?? 'rec_${category.id}',
      category: category,
      products: productsList,
      rank: (json['rank'] as num?)?.toInt() ?? 1,
      matchReason: resolvedReason ?? category.reason,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category.toJson(),
      'products': products.map((e) => e.toJson()).toList(),
      'rank': rank,
      'match_reason': matchReason,
    };
  }

  Recommendation copyWith({
    String? id,
    GiftCategory? category,
    List<Product>? products,
    int? rank,
    String? matchReason,
  }) {
    return Recommendation(
      id: id ?? this.id,
      category: category ?? this.category,
      products: products ?? this.products,
      rank: rank ?? this.rank,
      matchReason: matchReason ?? this.matchReason,
    );
  }
}
