import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/app_utils.dart';
import '../../../core/widgets/widgets.dart';
import '../../../data/models/models.dart';
import '../../home/controllers/home_controller.dart';
import '../controllers/saved_controller.dart';

class SavedView extends StatelessWidget {
  final bool isEmbedded;

  const SavedView({
    super.key,
    this.isEmbedded = false,
  });

  @override
  Widget build(BuildContext context) {
    // Ensure controller is registered
    final controller = Get.isRegistered<SavedController>()
        ? Get.find<SavedController>()
        : Get.put(SavedController());

    final isDark = Theme.of(context).brightness == Brightness.dark;

    final content = SafeArea(
      top: !isEmbedded,
      bottom: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      if (!isEmbedded) ...[
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: Icon(
                            Icons.arrow_back_rounded,
                            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                          ),
                          onPressed: () => Get.back(),
                        ),
                        const SizedBox(width: 8),
                      ],
                      Flexible(
                        child: Text(
                          'Saved Gifts',
                          style: AppTextStyles.headingLarge(
                            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                          ).copyWith(fontSize: 20),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Icon(
                        Icons.auto_awesome,
                        color: AppColors.yellowAccent,
                        size: 16,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // Offline status badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: AppColors.success.withValues(alpha: 0.4),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.offline_pin_rounded,
                        size: 14,
                        color: AppColors.success,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Available offline',
                        style: AppTextStyles.bodySmall(color: AppColors.success).copyWith(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Tab Selector: Products vs Categories
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
            child: Obx(() {
              final tab = controller.selectedTab.value;
              final productCount = controller.savedProducts.length;
              final categoryCount = controller.savedCategories.length;

              return Row(
                children: [
                  Expanded(
                    child: _buildSegmentButton(
                      context: context,
                      label: 'Products ($productCount)',
                      icon: Icons.card_giftcard_rounded,
                      isSelected: tab == 0,
                      onTap: () => controller.setTab(0),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildSegmentButton(
                      context: context,
                      label: 'Categories ($categoryCount)',
                      icon: Icons.category_rounded,
                      isSelected: tab == 1,
                      onTap: () => controller.setTab(1),
                    ),
                  ),
                ],
              );
            }),
          ),

          const SizedBox(height: 10),

          // Main List View or Empty State
          Expanded(
            child: Obx(() {
              final tab = controller.selectedTab.value;

              if (tab == 0) {
                // Products Tab
                final products = controller.savedProducts;
                if (products.isEmpty) {
                  return _buildEmptyState(
                    context: context,
                    title: 'No Saved Products',
                    description: 'Heart products you love from the recommendations to save them here for offline access.',
                  );
                }

                return ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                  itemCount: products.length,
                  separatorBuilder: (_, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return _buildProductCard(context, product, controller, isDark);
                  },
                );
              } else {
                // Categories Tab
                final categories = controller.savedCategories;
                if (categories.isEmpty) {
                  return _buildEmptyState(
                    context: context,
                    title: 'No Saved Categories',
                    description: 'Save AI gift suggestion categories to view and review them anytime without internet.',
                  );
                }

                return ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                  itemCount: categories.length,
                  separatorBuilder: (_, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    return _buildCategoryCard(context, category, controller, isDark);
                  },
                );
              }
            }),
          ),
        ],
      ),
    );

    if (isEmbedded) {
      return content;
    }

    return Scaffold(
      body: AppBackground(
        child: content,
      ),
    );
  }

  Widget _buildSegmentButton({
    required BuildContext context,
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.yellowAccent
              : (isDark ? AppColors.darkCardSurface : AppColors.lightCardSurface),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? AppColors.yellowAccent
                : (isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder),
            width: 1.2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.yellowAccent.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected
                  ? AppColors.textOnYellow
                  : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: (isSelected
                        ? AppTextStyles.chipSelected(color: AppColors.textOnYellow)
                        : AppTextStyles.chipUnselected(
                            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                          ))
                    .copyWith(fontSize: 12.5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(
    BuildContext context,
    Product product,
    SavedController controller,
    bool isDark,
  ) {
    final priceColor = AppColors.highlightText(isDark);
    final isOld = controller.isOldItem(product);

    return AppCard(
      padding: const EdgeInsets.all(12),
      onTap: () => controller.openProductDetail(product),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thumbnail Image with placeholder fallback
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Container(
              width: 84,
              height: 84,
              color: isDark ? const Color(0xFF220D42) : const Color(0xFFEDE3FD),
              child: product.imageUrl.isNotEmpty
                  ? Image.network(
                      product.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (ctx, err, stack) => _buildPlaceholderIcon(),
                    )
                  : _buildPlaceholderIcon(),
            ),
          ),
          const SizedBox(width: 12),

          // Details Column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Store and Offline badge
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      product.storeName,
                      style: AppTextStyles.bodySmall(
                        color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                      ).copyWith(fontSize: 11, fontWeight: FontWeight.w500),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.offline_pin_rounded,
                          size: 12,
                          color: AppColors.success,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          'Offline',
                          style: TextStyle(
                            color: AppColors.success,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 3),

                // Name (max 2 lines)
                Text(
                  product.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.titleMedium(
                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  ).copyWith(fontSize: 13, fontWeight: FontWeight.w600, height: 1.25),
                ),
                const SizedBox(height: 4),

                // Warning if item is old: "Link may no longer be valid"
                if (isOld)
                  Container(
                    margin: const EdgeInsets.only(bottom: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.yellowSoftTint,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: AppColors.yellowAccent.withValues(alpha: 0.4),
                        width: 0.8,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.warning_amber_rounded,
                          size: 12,
                          color: AppColors.yellowAccent,
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            'Link may no longer be valid',
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.bodySmall(
                              color: isDark ? AppColors.yellowAccent : AppColors.lightPrimary,
                            ).copyWith(fontSize: 9.5, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),

                // Price and Remove Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        formatPkr(product.price.toInt()),
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.titleMedium(
                          color: priceColor,
                        ).copyWith(fontWeight: FontWeight.w700, fontSize: 14),
                      ),
                    ),
                    const SizedBox(width: 6),
                    // Remove button
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => controller.removeProduct(product.id),
                        borderRadius: BorderRadius.circular(16),
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.delete_outline_rounded,
                                size: 16,
                                color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                'Remove',
                                style: AppTextStyles.bodySmall(
                                  color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                                ).copyWith(fontSize: 10.5),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(
    BuildContext context,
    GiftCategory category,
    SavedController controller,
    bool isDark,
  ) {
    return AppCard(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          // Category Icon Circle
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.yellowSoftTint,
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.yellowAccent.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: const Center(
              child: Icon(
                Icons.card_giftcard_rounded,
                color: AppColors.yellowAccent,
                size: 24,
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Category Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        category.name,
                        style: AppTextStyles.titleMedium(
                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                        ).copyWith(fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.offline_pin_rounded,
                          size: 12,
                          color: AppColors.success,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          'Offline',
                          style: TextStyle(
                            color: AppColors.success,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  category.reason,
                  style: AppTextStyles.bodySmall(
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ).copyWith(height: 1.3),
                ),
              ],
            ),
          ),

          // Remove Button
          IconButton(
            icon: Icon(
              Icons.delete_outline_rounded,
              size: 20,
              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
            ),
            tooltip: 'Remove',
            onPressed: () => controller.removeCategory(category.id),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderIcon() {
    return const Center(
      child: Icon(
        Icons.card_giftcard_rounded,
        size: 32,
        color: AppColors.yellowAccent,
      ),
    );
  }

  Widget _buildEmptyState({
    required BuildContext context,
    required String title,
    required String description,
  }) {
    return EmptyState(
      title: title,
      description: description,
      icon: const Icon(
        Icons.bookmark_border_rounded,
        size: 40,
        color: AppColors.yellowAccent,
      ),
      buttonText: 'Find Gifts',
      onButtonPressed: () {
        if (isEmbedded) {
          if (Get.isRegistered<HomeController>()) {
            Get.find<HomeController>().changeTab(0);
          }
        } else {
          Get.offAllNamed('/home');
        }
      },
    );
  }
}
