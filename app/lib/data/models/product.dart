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
    this.availability = 'In stock',
    this.source = 'Curated catalog',
    required this.lastUpdated,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      currency: json['currency'] as String? ?? 'PKR',
      imageUrl: json['imageUrl'] as String? ?? '',
      storeName: json['storeName'] as String? ?? '',
      storeUrl: json['storeUrl'] as String? ?? '',
      category: json['category'] as String? ?? '',
      tags: (json['tags'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      availability: json['availability'] as String? ?? 'In stock',
      source: json['source'] as String? ?? 'Curated catalog',
      lastUpdated: json['lastUpdated'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'currency': currency,
      'imageUrl': imageUrl,
      'storeName': storeName,
      'storeUrl': storeUrl,
      'category': category,
      'tags': tags,
      'availability': availability,
      'source': source,
      'lastUpdated': lastUpdated,
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
