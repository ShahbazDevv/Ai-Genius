class GiftCategory {
  final String id;
  final String name;
  final String reason;
  final int productCount;
  final String icon;

  GiftCategory({
    required this.id,
    required this.name,
    required this.reason,
    required this.productCount,
    required this.icon,
  });

  factory GiftCategory.fromJson(Map<String, dynamic> json) {
    return GiftCategory(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      reason: json['reason'] as String? ?? '',
      productCount: (json['product_count'] ?? json['productCount'] as num?)?.toInt() ?? 0,
      icon: json['icon'] as String? ?? 'card_giftcard',
    );
  }

  /// Serializes to JSON matching docs/api_contract.md EXACTLY.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'reason': reason,
      'product_count': productCount,
      'icon': icon,
    };
  }

  GiftCategory copyWith({
    String? id,
    String? name,
    String? reason,
    int? productCount,
    String? icon,
  }) {
    return GiftCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      reason: reason ?? this.reason,
      productCount: productCount ?? this.productCount,
      icon: icon ?? this.icon,
    );
  }
}
