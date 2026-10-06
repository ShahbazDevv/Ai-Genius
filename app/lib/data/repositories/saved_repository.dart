import '../local/app_database.dart';
import '../models/models.dart';

abstract class SavedRepository {
  Future<List<Product>> getSavedProducts();
  Future<List<GiftCategory>> getSavedCategories();
  Future<bool> isProductSaved(String id);
  Future<bool> isCategorySaved(String id);
  Future<void> toggleSaveProduct(Product product);
  Future<void> saveProduct(Product product, {String? status});
  Future<void> removeProduct(String id);
  Future<void> toggleSaveCategory(GiftCategory category);
  Future<void> saveCategory(GiftCategory category);
  Future<void> removeCategory(String id);
  Future<void> clearAll();
  Future<String?> getProductStatus(String id);
}

class SqliteSavedRepository implements SavedRepository {
  final AppDatabase _database;

  SqliteSavedRepository(this._database);

  @override
  Future<List<Product>> getSavedProducts() {
    return _database.getSavedProducts();
  }

  @override
  Future<List<GiftCategory>> getSavedCategories() {
    return _database.getSavedCategories();
  }

  @override
  Future<bool> isProductSaved(String id) {
    return _database.isProductSaved(id);
  }

  @override
  Future<bool> isCategorySaved(String id) {
    return _database.isCategorySaved(id);
  }

  @override
  Future<void> saveProduct(Product product, {String? status}) {
    return _database.insertOrUpdateProduct(product, status: status);
  }

  @override
  Future<void> toggleSaveProduct(Product product) async {
    final saved = await isProductSaved(product.id);
    if (saved) {
      await removeProduct(product.id);
    } else {
      await saveProduct(product);
    }
  }

  @override
  Future<void> removeProduct(String id) {
    return _database.deleteSavedItem(id, 'product');
  }

  @override
  Future<void> saveCategory(GiftCategory category) {
    return _database.insertOrUpdateCategory(category);
  }

  @override
  Future<void> toggleSaveCategory(GiftCategory category) async {
    final saved = await isCategorySaved(category.id);
    if (saved) {
      await removeCategory(category.id);
    } else {
      await saveCategory(category);
    }
  }

  @override
  Future<void> removeCategory(String id) {
    return _database.deleteSavedItem(id, 'category');
  }

  @override
  Future<void> clearAll() {
    return _database.clearSavedItems();
  }

  @override
  Future<String?> getProductStatus(String id) {
    return _database.getProductStatus(id);
  }
}
