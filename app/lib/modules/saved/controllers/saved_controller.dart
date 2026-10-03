import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/mock/mock_data.dart';
import '../../../data/models/models.dart';
import '../../../routes/app_routes.dart';

class SavedController extends GetxController {
  static SavedController get to => Get.find<SavedController>();

  final RxList<Product> savedProducts = <Product>[].obs;
  final RxList<GiftCategory> savedCategories = <GiftCategory>[].obs;
  final RxInt selectedTab = 0.obs; // 0: Products, 1: Categories

  @override
  void onInit() {
    super.onInit();
    _seedInitialSavedItems();
  }

  void _seedInitialSavedItems() {
    // Seed with realistic mock data to showcase offline label and old link warning
    if (MockData.products.isNotEmpty) {
      savedProducts.add(MockData.products[0]); // Recent item
    }

    // Add an older saved item to demonstrate "Link may no longer be valid"
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
        tags: ['Vintage', 'Collectible', 'Minimal'],
        availability: 'In stock',
        source: 'Curated catalog',
        lastUpdated: '2026-06-15', // Older than 45 days
      ),
    );

    if (MockData.categories.isNotEmpty) {
      savedCategories.add(MockData.categories[0]);
    }
  }

  bool isProductSaved(String id) => savedProducts.any((p) => p.id == id);

  void toggleSaveProduct(Product product) {
    final index = savedProducts.indexWhere((p) => p.id == product.id);
    if (index >= 0) {
      savedProducts.removeAt(index);
    } else {
      savedProducts.add(product);
    }
  }

  void removeProduct(String id) {
    final index = savedProducts.indexWhere((p) => p.id == id);
    if (index >= 0) {
      final removed = savedProducts.removeAt(index);
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
            onPressed: () {
              savedProducts.insert(index, removed);
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

  void toggleSaveCategory(GiftCategory category) {
    final index = savedCategories.indexWhere((c) => c.id == category.id);
    if (index >= 0) {
      savedCategories.removeAt(index);
    } else {
      savedCategories.add(category);
    }
  }

  void removeCategory(String id) {
    savedCategories.removeWhere((c) => c.id == id);
  }

  bool isOldItem(Product product) {
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

  void clearAll() {
    savedProducts.clear();
    savedCategories.clear();
  }
}
