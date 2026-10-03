import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/app_utils.dart';
import '../../../core/widgets/widgets.dart';
import '../controllers/product_detail_controller.dart';

class ProductDetailView extends GetView<ProductDetailController> {
  const ProductDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final prod = controller.product;
    final priceColor = AppColors.highlightText(isDark);
    final isAvailable = controller.isAvailable;

    return Scaffold(
      body: AppBackground(
        child: Column(
          children: [
            // Top Image with Overlay Buttons
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Large Product Image with overlaid Back & Heart Buttons
                    Stack(
                      children: [
                        // Image Container with rounded bottom corners
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(28)),
                          child: Container(
                            width: double.infinity,
                            height: 320,
                            color: isDark ? const Color(0xFF220D42) : const Color(0xFFEDE3FD),
                            child: prod.imageUrl.isNotEmpty
                                ? Image.network(
                                    prod.imageUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) => _buildImagePlaceholder(isDark),
                                    loadingBuilder: (context, child, progress) {
                                      if (progress == null) return child;
                                      return _buildImageLoading(isDark);
                                    },
                                  )
                                : _buildImagePlaceholder(isDark),
                          ),
                        ),

                        // Subtle bottom gradient shadow on the image for depth
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            height: 60,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(28)),
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  (isDark ? AppColors.darkBgTop : AppColors.lightBgTop).withValues(alpha: 0.6),
                                ],
                              ),
                            ),
                          ),
                        ),

                        // Overlay Back and Heart Buttons
                        SafeArea(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Circular Back Button
                                _buildCircleButton(
                                  isDark: isDark,
                                  icon: Icons.arrow_back_rounded,
                                  color: Colors.white,
                                  onTap: () => Get.back(),
                                ),

                                // Circular Heart Save Button
                                Obx(() {
                                  final isSaved = controller.isSaved.value;
                                  return _buildCircleButton(
                                    isDark: isDark,
                                    icon: isSaved ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                                    color: isSaved ? AppColors.yellowAccent : Colors.white,
                                    onTap: () => controller.toggleSave(),
                                  );
                                }),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Product Details Content Area
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Store Name & Availability Badge Row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Store Pill
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? AppColors.darkCardSurface
                                      : AppColors.lightCardSurface,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.storefront_rounded,
                                      size: 15,
                                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      prod.storeName,
                                      style: AppTextStyles.bodySmall(
                                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                      ).copyWith(fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ),

                              // Availability Badge (Strict: only claims available if availability field says so)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: (isAvailable ? AppColors.success : AppColors.error).withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: (isAvailable ? AppColors.success : AppColors.error).withValues(alpha: 0.5),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      isAvailable ? Icons.check_circle_rounded : Icons.cancel_rounded,
                                      size: 14,
                                      color: isAvailable ? AppColors.success : AppColors.error,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      isAvailable ? 'In Stock' : prod.availability,
                                      style: AppTextStyles.bodySmall(
                                        color: isAvailable ? AppColors.success : AppColors.error,
                                      ).copyWith(fontWeight: FontWeight.w700),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 14),

                          // Product Name
                          Text(
                            prod.name,
                            style: AppTextStyles.headingMedium(
                              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                            ).copyWith(fontSize: 22, height: 1.3),
                          ),

                          const SizedBox(height: 10),

                          // Price in PKR (Big, Yellow in Dark Mode / Deep Purple in Light Mode)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                formatPkr(prod.price.toInt()),
                                style: AppTextStyles.headingLarge(
                                  color: priceColor,
                                ).copyWith(fontSize: 28, fontWeight: FontWeight.w800),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                prod.currency,
                                style: AppTextStyles.bodySmall(
                                  color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                                ).copyWith(fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),

                          const SizedBox(height: 18),

                          // Description Section
                          AppCard(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.auto_awesome_rounded,
                                      size: 16,
                                      color: AppColors.yellowAccent,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      'About this Gift',
                                      style: AppTextStyles.titleMedium(
                                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                                      ).copyWith(fontWeight: FontWeight.w600, fontSize: 15),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  prod.description,
                                  style: AppTextStyles.bodyMedium(
                                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                  ).copyWith(height: 1.5),
                                ),
                              ],
                            ),
                          ),

                          // Relevant Tags as Chips
                          if (prod.tags.isNotEmpty) ...[
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Icon(
                                  Icons.local_offer_outlined,
                                  size: 15,
                                  color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Tags & Attributes',
                                  style: AppTextStyles.titleSmall(
                                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                  ).copyWith(fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: prod.tags.map((tag) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? AppColors.darkCardSurface
                                        : AppColors.lightCardSurface,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder,
                                      width: 1,
                                    ),
                                  ),
                                  child: Text(
                                    '#$tag',
                                    style: AppTextStyles.bodySmall(
                                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                                    ).copyWith(fontSize: 11.5, fontWeight: FontWeight.w500),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],

                          const SizedBox(height: 18),

                          // Source Label & Update Info
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              color: (isDark ? AppColors.darkCardSurface : AppColors.lightCardSurface)
                                  .withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.verified_outlined,
                                  size: 16,
                                  color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Source: ${prod.source.isNotEmpty ? prod.source : "Curated catalog"} · Updated ${prod.lastUpdated}',
                                    style: AppTextStyles.bodySmall(
                                      color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                                    ).copyWith(fontSize: 11),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Sticky Bottom Section: Large "View on Store" Button + Notice
            Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkBgTop : AppColors.lightBgTop,
                border: Border(
                  top: BorderSide(
                    color: isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder,
                    width: 1,
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.08),
                    blurRadius: 10,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppButton(
                      title: 'View on Store',
                      icon: const Icon(
                        Icons.open_in_new_rounded,
                        color: AppColors.textOnYellow,
                        size: 20,
                      ),
                      onPressed: () => controller.openStoreUrl(),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Price and availability may change on the store.',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodySmall(
                        color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                      ).copyWith(fontSize: 11),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircleButton({
    required bool isDark,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.45),
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.25),
              width: 1,
            ),
          ),
          child: Center(
            child: Icon(
              icon,
              color: color,
              size: 22,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImagePlaceholder(bool isDark) {
    return Container(
      color: isDark ? const Color(0xFF220D42) : const Color(0xFFEDE3FD),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.card_giftcard_rounded,
              size: 64,
              color: AppColors.yellowAccent.withValues(alpha: 0.85),
            ),
            const SizedBox(height: 8),
            Text(
              'AI Genius Curated Gift',
              style: AppTextStyles.titleMedium(
                color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageLoading(bool isDark) {
    return Container(
      color: isDark ? const Color(0xFF220D42) : const Color(0xFFEDE3FD),
      child: const Center(
        child: SizedBox(
          width: 32,
          height: 32,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.yellowAccent),
          ),
        ),
      ),
    );
  }
}
