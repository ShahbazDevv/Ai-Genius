class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String currency;
  final String imageUrl;
  final String storeName;
  final String storeUrl;
  final String category;
  final List<String> tags;
  final String availability;
  final String source;
  final String lastUpdated;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.currency = 'PKR',
    required this.imageUrl,
    required this.storeName,
    required this.storeUrl,
    required this.category,
    this.tags = const [],
    this.availability = 'in_stock',
    this.source = 'curated',
    required this.lastUpdated,
  });

  /// Factory creating from JSON matching docs/api_contract.md and local storage formats.
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      currency: json['currency'] as String? ?? 'PKR',
      imageUrl: (json['image_url'] ?? json['imageUrl'] as String?) ?? '',
      storeName: (json['store_name'] ?? json['storeName'] as String?) ?? '',
      storeUrl: (json['store_url'] ?? json['storeUrl'] as String?) ?? '',
      category: (json['category_id'] ?? json['category'] as String?) ?? '',
      tags: (json['tags'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      availability: json['availability'] as String? ?? 'in_stock',
      source: json['source'] as String? ?? 'curated',
      lastUpdated: (json['last_updated'] ?? json['lastUpdated'] as String?) ?? '',
    );
  }

  /// Serializes to JSON matching docs/api_contract.md EXACTLY.
  /// Keys: id, name, description, price (int), currency, image_url, store_name, store_url, category_id, tags, availability, source, last_updated.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price.toInt(),
      'currency': currency,
      'image_url': imageUrl.isEmpty ? null : imageUrl,
      'store_name': storeName,
      'store_url': storeUrl,
      'category_id': category,
      'tags': tags,
      'availability': availability,
      'source': source,
      'last_updated': lastUpdated,
    };
  }

  Product copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? currency,
    String? imageUrl,
    String? storeName,
    String? storeUrl,
    String? category,
    List<String>? tags,
    String? availability,
    String? source,
    String? lastUpdated,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      currency: currency ?? this.currency,
      imageUrl: imageUrl ?? this.imageUrl,
      storeName: storeName ?? this.storeName,
      storeUrl: storeUrl ?? this.storeUrl,
      category: category ?? this.category,
      tags: tags ?? this.tags,
      availability: availability ?? this.availability,
      source: source ?? this.source,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}
