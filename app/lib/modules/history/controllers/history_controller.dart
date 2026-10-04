import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/mock/mock_data.dart';
import '../../../data/models/models.dart';
import '../../../routes/app_routes.dart';

class HistoryController extends GetxController {
  static HistoryController get to => Get.find<HistoryController>();

  final RxList<SearchHistoryItem> historyList = <SearchHistoryItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    _seedInitialHistory();
  }

  void _seedInitialHistory() {
    // Seed initial realistic past searches matching design brief Section 8
    final now = DateTime.now();

    // 1. "Birthday Gift Search" ("Mother · Beauty · PKR 3,500")
    final req1 = GiftRequest(
      relationship: 'Mother',
      ageGroup: '40-49',
      gender: 'Female',
      occasion: 'Birthday',
      budget: 3500.0,
      interests: ['Beauty', 'Skincare'],
      giftStyles: ['Elegant', 'Self-Care'],
      additionalDetails: 'Loves calming fragrances and organic skincare.',
    );

    final recs1 = [
      Recommendation(
        id: 'rec_skincare_seed',
        category: MockData.categories[0].copyWith(
          productCount: 3,
          reason: 'Matches beauty & skincare interest for mother on birthday.',
        ),
        products: MockData.products
            .where((p) => p.category == 'cat_skincare' && p.price <= 3500)
            .toList(),
        rank: 1,
        matchReason: 'Matches beauty & skincare interest for mother on birthday.',
      ),
      Recommendation(
        id: 'rec_fragrance_seed',
        category: MockData.categories[4].copyWith(
          productCount: 3,
          reason: 'Sensory self-care luxury with relaxing floral notes.',
        ),
        products: MockData.products
            .where((p) => p.category == 'cat_fragrance' && p.price <= 3500)
            .toList(),
        rank: 2,
        matchReason: 'Sensory self-care luxury with relaxing floral notes.',
      ),
    ];

    historyList.add(
      SearchHistoryItem.create(
        request: req1,
        recommendations: recs1,
        createdAt: now.subtract(const Duration(hours: 2, minutes: 15)),
        customId: 'seed_search_1',
      ),
    );

    // 2. "Anniversary Gift Search" ("Partner · Technology · PKR 10,000")
    final req2 = GiftRequest(
      relationship: 'Partner',
      ageGroup: '25-29',
      gender: 'Male',
      occasion: 'Anniversary',
      budget: 10000.0,
      interests: ['Technology', 'Computer Gadgets'],
      giftStyles: ['Luxury', 'Practical'],
    );

    final recs2 = [
      Recommendation(
        id: 'rec_tech_seed',
        category: MockData.categories[1].copyWith(
          productCount: 4,
          reason: 'Top wireless audio and tech accessories within budget.',
        ),
        products: MockData.products
            .where((p) => p.category == 'cat_tech' && p.price <= 10000)
            .toList(),
        rank: 1,
        matchReason: 'Top wireless audio and tech accessories within budget.',
      ),
    ];

    historyList.add(
      SearchHistoryItem.create(
        request: req2,
        recommendations: recs2,
        createdAt: now.subtract(const Duration(days: 1, hours: 3)),
        customId: 'seed_search_2',
      ),
    );
  }

  /// Adds a completed analysis from the Loading screen to the top of the history list
  void addSearch({
    required GiftRequest request,
    required List<Recommendation> recommendations,
  }) {
    final newItem = SearchHistoryItem.create(
      request: request,
      recommendations: recommendations,
    );
    historyList.insert(0, newItem);
  }

  /// Swipe or manual deletion with snackbar UNDO
  void deleteSearch(String id) {
    final index = historyList.indexWhere((item) => item.id == id);
    if (index >= 0) {
      final removed = historyList.removeAt(index);
      if (Get.context != null) {
        Get.snackbar(
          'Search Removed',
          '${removed.title} has been removed.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.darkCardSurface.withValues(alpha: 0.95),
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
          margin: const EdgeInsets.all(16),
          borderRadius: 14,
          mainButton: TextButton(
            onPressed: () {
              historyList.insert(index, removed);
              if (Get.isSnackbarOpen) {
                Get.back();
              }
            },
            child: const Text(
              'UNDO',
              style: TextStyle(
                color: AppColors.yellowAccent,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        );
      }
    }
  }

  /// Reopens the Results screen with this search's data
  void reopenSearch(SearchHistoryItem item) {
    if (item.recommendations.isNotEmpty) {
      Get.toNamed(
        AppRoutes.results,
        arguments: {
          'request': item.request,
          'recommendations': item.recommendations,
        },
      );
    } else {
      // Re-run analysis if recommendations were empty
      Get.toNamed(
        AppRoutes.loading,
        arguments: item.request,
      );
    }
  }

  /// Clear all searches
  void clearAll() {
    historyList.clear();
    if (Get.context != null) {
      Get.snackbar(
        'History Cleared',
        'All past search history has been deleted.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.darkCardSurface.withValues(alpha: 0.95),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(16),
        borderRadius: 14,
      );
    }
  }

  /// Displays confirmation dialog before clearing all
  void confirmClearAll(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Get.dialog(
      Dialog(
        backgroundColor: isDark ? AppColors.darkCardSurface : AppColors.lightCardSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder,
            width: 1.2,
          ),
        ),
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.delete_sweep_rounded,
                  color: AppColors.error,
                  size: 28,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Clear All History?',
                style: AppTextStyles.headingSmall(
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Are you sure you want to remove all searches from your history? This action cannot be undone.',
                style: AppTextStyles.bodyMedium(
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Get.back(),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: AppTextStyles.button(
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                        clearAll();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.error,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Clear All',
                        style: AppTextStyles.button(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
