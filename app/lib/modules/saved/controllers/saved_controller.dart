import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/local/app_database.dart';
import '../../../data/mock/mock_data.dart';
import '../../../data/models/models.dart';
import '../../../data/repositories/saved_repository.dart';
import '../../../routes/app_routes.dart';

class SavedController extends GetxController {
  static SavedController get to => Get.find<SavedController>();

  final SavedRepository _repository;

  final RxList<Product> savedProducts = <Product>[].obs;
  final RxList<GiftCategory> savedCategories = <GiftCategory>[].obs;
  final RxMap<String, String> productStatusMap = <String, String>{}.obs;
  final RxInt selectedTab = 0.obs; // 0: Products, 1: Categories
  final RxBool isLoading = false.obs;
  bool _hasBeenCleared = false;
  int _mutationCount = 0;

  SavedController({SavedRepository? repository})
      : _repository = repository ??
            (Get.isRegistered<SavedRepository>()
                ? Get.find<SavedRepository>()
                : SqliteSavedRepository(Get.isRegistered<AppDatabase>()
                    ? Get.find<AppDatabase>()
                    : AppDatabase())) {
    _populateDefaultMemorySeeds();
  }

  @override
  void onInit() {
    super.onInit();
    init();
  }

  void _populateDefaultMemorySeeds() {
    if (savedProducts.isNotEmpty || _hasBeenCleared) return;
    if (MockData.products.isNotEmpty) {
      savedProducts.add(MockData.products[0]);
    }
    savedProducts.add(
      Product(
        id: 'saved_old_01',
        name: 'Artisanal Brass Desk Clock & Compass',
        description: 'Vintage brass mechanical desk timepiece with compass engraving.',
        price: 3800.0,
        currency: 'PKR',
        imageUrl: 'https://images.unsplash.com/photo-1509042239860-f550ce710b93?auto=format&fit=crop&w=600&q=80',
        storeName: 'Daraz',
        storeUrl: 'https://daraz.pk',
        category: 'cat_tech',
        tags: const ['Vintage', 'Collectible', 'Minimal'],
        availability: 'In stock',
        source: 'Curated catalog',
        lastUpdated: '2026-06-15',
      ),
    );
    productStatusMap['saved_old_01'] = 'link_may_be_invalid';

    if (savedCategories.isEmpty && MockData.categories.isNotEmpty) {
      savedCategories.add(MockData.categories[0]);
    }
  }

  Future<void> init() async {
    final startCount = _mutationCount;
    isLoading.value = true;
    try {
      final products = await _repository.getSavedProducts();
      final categories = await _repository.getSavedCategories();
      if (_mutationCount != startCount) return;

      final prefs = await SharedPreferences.getInstance();
      final isSeeded = prefs.getBool('drift_saved_items_seeded') ?? false;

      if (_hasBeenCleared || _mutationCount != startCount) {
        savedProducts.clear();
        savedCategories.clear();
        productStatusMap.clear();
        return;
      }

      if (!isSeeded && products.isEmpty && categories.isEmpty) {
        await _seedInitialSavedItems();
        await prefs.setBool('drift_saved_items_seeded', true);
      } else {
        if (!_hasBeenCleared && _mutationCount == startCount) {
          savedProducts.assignAll(products);
          savedCategories.assignAll(categories);
          productStatusMap.clear();
          for (final p in products) {
            final status = await _repository.getProductStatus(p.id);
            if (status != null) {
              productStatusMap[p.id] = status;
            }
          }
        }
      }
    } catch (_) {
      if (savedProducts.isEmpty && savedCategories.isEmpty && !_hasBeenCleared && _mutationCount == startCount) {
        _populateDefaultMemorySeeds();
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _seedInitialSavedItems() async {
    if (MockData.products.isNotEmpty) {
      final p1 = MockData.products[0];
      await _repository.saveProduct(p1, status: 'valid');
      productStatusMap[p1.id] = 'valid';
    }

    final oldProduct = Product(
      id: 'saved_old_01',
      name: 'Artisanal Brass Desk Clock & Compass',
      description: 'Vintage brass mechanical desk timepiece with compass engraving.',
      price: 3800.0,
      currency: 'PKR',
      imageUrl: 'https://images.unsplash.com/photo-1509042239860-f550ce710b93?auto=format&fit=crop&w=600&q=80',
      storeName: 'Daraz',
      storeUrl: 'https://daraz.pk',
      category: 'cat_tech',
      tags: const ['Vintage', 'Collectible', 'Minimal'],
      availability: 'In stock',
      source: 'Curated catalog',
      lastUpdated: '2026-06-15',
    );
    await _repository.saveProduct(oldProduct, status: 'link_may_be_invalid');
    productStatusMap[oldProduct.id] = 'link_may_be_invalid';

    if (MockData.categories.isNotEmpty) {
      await _repository.saveCategory(MockData.categories[0]);
    }

    final products = await _repository.getSavedProducts();
    final categories = await _repository.getSavedCategories();
    savedProducts.assignAll(products);
    savedCategories.assignAll(categories);
  }

  bool isProductSaved(String id) => savedProducts.any((p) => p.id == id);

  Future<void> toggleSaveProduct(Product product, {String? status}) async {
    _mutationCount++;
    _hasBeenCleared = false;
    final index = savedProducts.indexWhere((p) => p.id == product.id);
    if (index >= 0) {
      savedProducts.removeAt(index);
      productStatusMap.remove(product.id);
      await _repository.removeProduct(product.id);
    } else {
      savedProducts.add(product);
      final itemStatus = status ?? (isOldItem(product) ? 'link_may_be_invalid' : 'valid');
      productStatusMap[product.id] = itemStatus;
      await _repository.saveProduct(product, status: itemStatus);
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('drift_saved_items_seeded', true);
  }

  Future<void> removeProduct(String id) async {
    _mutationCount++;
    final index = savedProducts.indexWhere((p) => p.id == id);
    if (index >= 0) {
      final removed = savedProducts.removeAt(index);
      final removedStatus = productStatusMap.remove(id);
      await _repository.removeProduct(id);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('drift_saved_items_seeded', true);

      if (Get.context != null) {
        Get.snackbar(
          'Removed from Saved',
          '${removed.name} has been removed.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.darkCardSurface.withValues(alpha: 0.95),
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
          mainButton: TextButton(
            onPressed: () async {
              _mutationCount++;
              _hasBeenCleared = false;
              savedProducts.insert(index, removed);
              if (removedStatus != null) {
                productStatusMap[removed.id] = removedStatus;
              }
              await _repository.saveProduct(removed, status: removedStatus);
              if (Get.isSnackbarOpen) {
                Get.back();
              }
            },
            child: const Text('UNDO', style: TextStyle(color: AppColors.yellowAccent, fontWeight: FontWeight.w700)),
          ),
        );
      }
    }
  }

  bool isCategorySaved(String id) => savedCategories.any((c) => c.id == id);

  Future<void> toggleSaveCategory(GiftCategory category) async {
    _mutationCount++;
    _hasBeenCleared = false;
    final index = savedCategories.indexWhere((c) => c.id == category.id);
    if (index >= 0) {
      savedCategories.removeAt(index);
      await _repository.removeCategory(category.id);
    } else {
      savedCategories.add(category);
      await _repository.saveCategory(category);
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('drift_saved_items_seeded', true);
  }

  Future<void> removeCategory(String id) async {
    _mutationCount++;
    savedCategories.removeWhere((c) => c.id == id);
    await _repository.removeCategory(id);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('drift_saved_items_seeded', true);
  }

  bool isOldItem(Product product) {
    if (productStatusMap[product.id] == 'link_may_be_invalid') {
      return true;
    }
    try {
      final date = DateTime.tryParse(product.lastUpdated);
      if (date != null) {
        final now = DateTime(2026, 10, 3);
        final difference = now.difference(date).inDays;
        return difference > 45;
      }
    } catch (_) {}
    return false;
  }

  Future<void> updateProductStatus(String id, String status) async {
    productStatusMap[id] = status;
    final product = savedProducts.firstWhereOrNull((p) => p.id == id);
    if (product != null) {
      await _repository.saveProduct(product, status: status);
    }
  }

  void setTab(int index) {
    selectedTab.value = index;
  }

  void openProductDetail(Product product) {
    Get.toNamed(
      AppRoutes.productDetail,
      arguments: {
        'product': product,
        'isSaved': true,
      },
    );
  }

  Future<void> clearAll() async {
    _mutationCount++;
    _hasBeenCleared = true;
    savedProducts.clear();
    savedCategories.clear();
    productStatusMap.clear();
    await _repository.clearAll();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('drift_saved_items_seeded', true);
  }
}
