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
    return Recommendation(
      id: json['id'] as String? ?? '',
      category: GiftCategory.fromJson(json['category'] as Map<String, dynamic>? ?? {}),
      products: (json['products'] as List<dynamic>?)
              ?.map((e) => Product.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      rank: json['rank'] as int? ?? 1,
      matchReason: json['matchReason'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category.toJson(),
      'products': products.map((e) => e.toJson()).toList(),
      'rank': rank,
      'matchReason': matchReason,
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
