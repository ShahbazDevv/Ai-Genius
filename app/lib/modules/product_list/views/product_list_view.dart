import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/app_utils.dart';
import '../../../core/widgets/widgets.dart';
import '../controllers/product_list_controller.dart';

class ProductListView extends GetView<ProductListController> {
  const ProductListView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final rec = controller.recommendation;
    final req = controller.request;

    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Navigation Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back_rounded,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      ),
                      onPressed: () => Get.back(),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'AI Genius Recommendations',
                      style: AppTextStyles.titleMedium(
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      ).copyWith(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),

              // Category Title & Budget Chip Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            rec.category.name,
                            style: AppTextStyles.headingMedium(
                              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.yellowAccent,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.yellowAccent.withValues(alpha: 0.35),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.account_balance_wallet_outlined,
                                size: 14,
                                color: AppColors.textOnYellow,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Up to ${formatPkr(req.budget.toInt())}',
                                style: AppTextStyles.bodySmall(color: AppColors.textOnYellow)
                                    .copyWith(fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      rec.matchReason ?? rec.category.reason,
                      style: AppTextStyles.bodyMedium(
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // Filter & Sort Bar (Horizontal Chips)
              Obx(() {
                final currentSort = controller.selectedSort.value;
                final onlyInStock = controller.onlyInStock.value;

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      // Sort label / icon
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Icon(
                          Icons.swap_vert_rounded,
                          size: 18,
                          color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                        ),
                      ),
                      SelectableChip(
                        label: 'Relevance',
                        isSelected: currentSort == ProductSortOption.relevance,
                        onSelected: (_) => controller.setSort(ProductSortOption.relevance),
                      ),
                      const SizedBox(width: 8),
                      SelectableChip(
                        label: 'Price: Low → High',
                        isSelected: currentSort == ProductSortOption.priceLowToHigh,
                        onSelected: (_) => controller.setSort(ProductSortOption.priceLowToHigh),
                      ),
                      const SizedBox(width: 8),
                      SelectableChip(
                        label: 'Price: High → Low',
                        isSelected: currentSort == ProductSortOption.priceHighToLow,
                        onSelected: (_) => controller.setSort(ProductSortOption.priceHighToLow),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        height: 20,
                        width: 1,
                        color: isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder,
                      ),
                      const SizedBox(width: 12),
                      SelectableChip(
                        label: 'In Stock Only',
                        icon: Icon(
                          Icons.check_circle_outline_rounded,
                          size: 15,
                          color: onlyInStock
                              ? AppColors.textOnYellow
                              : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                        ),
                        isSelected: onlyInStock,
                        onSelected: (_) => controller.toggleInStockFilter(),
                      ),
                    ],
                  ),
                );
              }),

              const SizedBox(height: 12),

              // Product Count & Budget Safety Indicator
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Obx(() {
                  final count = controller.displayedProducts.length;
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '$count ${count == 1 ? "product" : "products"} available',
                        style: AppTextStyles.bodySmall(
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        ).copyWith(fontWeight: FontWeight.w500),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.verified_rounded,
                            size: 13,
                            color: AppColors.success,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Strict budget guaranteed',
                            style: AppTextStyles.bodySmall(
                              color: AppColors.success,
                            ).copyWith(fontSize: 11, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ],
                  );
                }),
              ),

              const SizedBox(height: 8),

              // 2-Column Grid or Empty State
              Expanded(
                child: Obx(() {
                  final products = controller.displayedProducts;

                  if (products.isEmpty) {
                    final hasFilter = controller.onlyInStock.value;
                    return EmptyState(
                      title: 'No products found',
                      description: hasFilter
                          ? 'No in-stock gifts found within your budget. Try turning off "In Stock Only" to view all suggestions.'
                          : 'No products found matching your current criteria within PKR ${formatPkr(req.budget.toInt())}.',
                      buttonText: hasFilter ? 'Reset Filters' : 'Change Budget',
                      onButtonPressed: () {
                        if (hasFilter) {
                          controller.resetFilters();
                        } else {
                          Get.back();
                        }
                      },
                    );
                  }

                  return GridView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(20, 6, 20, 24),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.60,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return Obx(() {
                        final isSaved = controller.isProductSaved(product.id);
                        return ProductCard(
                          product: product,
                          isSaved: isSaved,
                          onTap: () => controller.openProductDetail(product),
                          onSaveToggle: () => controller.toggleSaveProduct(product.id),
                        );
                      });
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
