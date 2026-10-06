import 'dart:convert';
import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import '../models/models.dart';

part 'app_database.g.dart';

/// Table for saved items: products and categories.
/// Stores full product info so it works offline,
/// plus a status field for "link may be invalid".
class SavedItems extends Table {
  TextColumn get id => text()();
  TextColumn get itemType => text()(); // 'product' or 'category'
  TextColumn get name => text()();
  TextColumn get description => text().withDefault(const Constant(''))();
  RealColumn get price => real().withDefault(const Constant(0.0))();
  TextColumn get currency => text().withDefault(const Constant('PKR'))();
  TextColumn get imageUrl => text().withDefault(const Constant(''))();
  TextColumn get storeName => text().withDefault(const Constant(''))();
  TextColumn get storeUrl => text().withDefault(const Constant(''))();
  TextColumn get category => text().withDefault(const Constant(''))();
  TextColumn get tagsJson => text().withDefault(const Constant('[]'))();
  TextColumn get availability => text().withDefault(const Constant('In stock'))();
  TextColumn get source => text().withDefault(const Constant('Curated catalog'))();
  TextColumn get lastUpdated => text().withDefault(const Constant(''))();
  TextColumn get reason => text().nullable()();
  IntColumn get productCount => integer().withDefault(const Constant(0))();
  TextColumn get icon => text().nullable()();
  TextColumn get status => text().withDefault(const Constant('valid'))(); // 'valid' or 'link_may_be_invalid'
  TextColumn get productJson => text().nullable()(); // Full product JSON for 100% offline fidelity
  DateTimeColumn get savedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id, itemType};
}

/// Table for search history.
/// Stores: title, subtitle, full request data, full recommendation result as JSON, created date.
class History extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get subtitle => text()();
  TextColumn get requestData => text()(); // Full GiftRequest JSON
  TextColumn get recommendationsJson => text()(); // Full recommendations list JSON
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [SavedItems, History])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? e]) : super(e ?? _openConnection()) {
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  }

  AppDatabase.inMemory() : super(NativeDatabase.memory()) {
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  }

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return LazyDatabase(() async {
      try {
        final dbFolder = await getApplicationDocumentsDirectory();
        final file = File(p.join(dbFolder.path, 'ai_genius.sqlite'));
        return NativeDatabase.createInBackground(file);
      } catch (_) {
        // Fallback for headless/unit test environments without path_provider
        return NativeDatabase.memory();
      }
    });
  }

  // --- Helpers for SavedItems ---

  Future<List<Product>> getSavedProducts() async {
    final query = select(savedItems)
      ..where((tbl) => tbl.itemType.equals('product'))
      ..orderBy([(tbl) => OrderingTerm.desc(tbl.savedAt)]);
    final rows = await query.get();
    return rows.map((row) => _rowToProduct(row)).toList();
  }

  Future<List<GiftCategory>> getSavedCategories() async {
    final query = select(savedItems)
      ..where((tbl) => tbl.itemType.equals('category'))
      ..orderBy([(tbl) => OrderingTerm.desc(tbl.savedAt)]);
    final rows = await query.get();
    return rows.map((row) => _rowToCategory(row)).toList();
  }

  Future<bool> isProductSaved(String id) async {
    final query = select(savedItems)
      ..where((tbl) => tbl.id.equals(id) & tbl.itemType.equals('product'));
    final result = await query.getSingleOrNull();
    return result != null;
  }

  Future<bool> isCategorySaved(String id) async {
    final query = select(savedItems)
      ..where((tbl) => tbl.id.equals(id) & tbl.itemType.equals('category'));
    final result = await query.getSingleOrNull();
    return result != null;
  }

  Future<void> insertOrUpdateProduct(Product product, {String? status}) async {
    // Determine status if not explicitly passed
    final resolvedStatus = status ?? (_isLinkOlderThan45Days(product.lastUpdated) ? 'link_may_be_invalid' : 'valid');
    final tagsString = jsonEncode(product.tags);
    final jsonProduct = jsonEncode(product.toJson());

    await into(savedItems).insertOnConflictUpdate(
      SavedItemsCompanion.insert(
        id: product.id,
        itemType: 'product',
        name: product.name,
        description: Value(product.description),
        price: Value(product.price),
        currency: Value(product.currency),
        imageUrl: Value(product.imageUrl),
        storeName: Value(product.storeName),
        storeUrl: Value(product.storeUrl),
        category: Value(product.category),
        tagsJson: Value(tagsString),
        availability: Value(product.availability),
        source: Value(product.source),
        lastUpdated: Value(product.lastUpdated),
        status: Value(resolvedStatus),
        productJson: Value(jsonProduct),
        savedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> insertOrUpdateCategory(GiftCategory cat) async {
    await into(savedItems).insertOnConflictUpdate(
      SavedItemsCompanion.insert(
        id: cat.id,
        itemType: 'category',
        name: cat.name,
        reason: Value(cat.reason),
        productCount: Value(cat.productCount),
        icon: Value(cat.icon),
        status: const Value('valid'),
        savedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<int> deleteSavedItem(String id, String itemType) {
    return (delete(savedItems)
          ..where((tbl) => tbl.id.equals(id) & tbl.itemType.equals(itemType)))
        .go();
  }

  Future<int> clearSavedItems() {
    return delete(savedItems).go();
  }

  Future<String?> getProductStatus(String id) async {
    final query = select(savedItems)
      ..where((tbl) => tbl.id.equals(id) & tbl.itemType.equals('product'));
    final row = await query.getSingleOrNull();
    return row?.status;
  }

  // --- Helpers for History ---

  Future<List<SearchHistoryItem>> getAllHistory() async {
    final query = select(history)
      ..orderBy([(tbl) => OrderingTerm.desc(tbl.createdAt)]);
    final rows = await query.get();
    return rows.map((row) => _rowToHistoryItem(row)).toList();
  }

  Future<SearchHistoryItem?> getHistoryById(String id) async {
    final query = select(history)..where((tbl) => tbl.id.equals(id));
    final row = await query.getSingleOrNull();
    if (row == null) return null;
    return _rowToHistoryItem(row);
  }

  Future<void> insertHistory(SearchHistoryItem item) async {
    await into(history).insertOnConflictUpdate(
      HistoryCompanion.insert(
        id: item.id,
        title: item.title,
        subtitle: item.subtitle,
        requestData: jsonEncode(item.request.toJson()),
        recommendationsJson: jsonEncode(item.recommendations.map((r) => r.toJson()).toList()),
        createdAt: item.createdAt,
      ),
    );
  }

  Future<int> deleteHistory(String id) {
    return (delete(history)..where((tbl) => tbl.id.equals(id))).go();
  }

  Future<int> clearAllHistory() {
    return delete(history).go();
  }

  // --- Converters ---

  static Product _rowToProduct(SavedItem row) {
    if (row.productJson != null && row.productJson!.isNotEmpty) {
      try {
        final map = jsonDecode(row.productJson!) as Map<String, dynamic>;
        return Product.fromJson(map);
      } catch (_) {}
    }

    List<String> tags = [];
    try {
      final decoded = jsonDecode(row.tagsJson);
      if (decoded is List) {
        tags = decoded.map((e) => e.toString()).toList();
      }
    } catch (_) {}

    return Product(
      id: row.id,
      name: row.name,
      description: row.description,
      price: row.price,
      currency: row.currency,
      imageUrl: row.imageUrl,
      storeName: row.storeName,
      storeUrl: row.storeUrl,
      category: row.category,
      tags: tags,
      availability: row.availability,
      source: row.source,
      lastUpdated: row.lastUpdated,
    );
  }

  static GiftCategory _rowToCategory(SavedItem row) {
    return GiftCategory(
      id: row.id,
      name: row.name,
      reason: row.reason ?? '',
      productCount: row.productCount,
      icon: row.icon ?? 'card_giftcard',
    );
  }

  static SearchHistoryItem _rowToHistoryItem(HistoryData row) {
    GiftRequest request;
    try {
      request = GiftRequest.fromJson(jsonDecode(row.requestData) as Map<String, dynamic>);
    } catch (_) {
      request = GiftRequest(
        relationship: 'Friend',
        ageGroup: '25-29',
        occasion: 'Birthday',
        budget: 3500.0,
        interests: const [],
      );
    }

    List<Recommendation> recs = [];
    try {
      final list = jsonDecode(row.recommendationsJson) as List<dynamic>;
      recs = list.map((e) => Recommendation.fromJson(e as Map<String, dynamic>)).toList();
    } catch (_) {}

    return SearchHistoryItem(
      id: row.id,
      title: row.title,
      subtitle: row.subtitle,
      request: request,
      recommendations: recs,
      createdAt: row.createdAt,
    );
  }

  static bool _isLinkOlderThan45Days(String lastUpdated) {
    try {
      final date = DateTime.tryParse(lastUpdated);
      if (date != null) {
        final now = DateTime.now();
        return now.difference(date).inDays > 45;
      }
    } catch (_) {}
    return false;
  }
}
