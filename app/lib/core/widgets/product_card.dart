import 'package:flutter/material.dart';
import '../../data/models/product.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../utils/app_utils.dart';

class ProductCard extends StatefulWidget {
  final Product product;
  final bool isSaved;
  final VoidCallback? onTap;
  final VoidCallback? onSaveToggle;

  const ProductCard({
    super.key,
    required this.product,
    this.isSaved = false,
    this.onTap,
    this.onSaveToggle,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final priceColor = AppColors.highlightText(isDark);
    final isAvailable = widget.product.availability.toLowerCase().contains('in stock');

    return AnimatedScale(
      scale: _isPressed ? 0.97 : 1.0,
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOutCubic,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: widget.onTap,
        child: Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCardSurface : AppColors.lightCardSurface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder,
              width: 1.2,
            ),
            boxShadow: isDark
                ? [
                    BoxShadow(
                      color: AppColors.darkBlob.withValues(alpha: 0.15),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: AppColors.lightPrimary.withValues(alpha: 0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image with Heart button overlay
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(17)),
                    child: SizedBox(
                      width: double.infinity,
                      height: 125,
                      child: widget.product.imageUrl.isNotEmpty
                          ? Image.network(
                              widget.product.imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => _buildPlaceholder(isDark),
                              loadingBuilder: (context, child, progress) {
                                if (progress == null) return child;
                                return _buildLoadingPlaceholder(isDark);
                              },
                            )
                          : _buildPlaceholder(isDark),
                    ),
                  ),

                  // Floating Heart Button
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: widget.onSaveToggle,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.darkBgTop.withValues(alpha: 0.65)
                                : Colors.black.withValues(alpha: 0.4),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.2),
                              width: 0.8,
                            ),
                          ),
                          child: Icon(
                            widget.isSaved ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                            size: 18,
                            color: widget.isSaved ? AppColors.yellowAccent : Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // Product Info
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Store & Availability Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            widget.product.storeName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.bodySmall(
                              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                            ).copyWith(fontSize: 10.5, fontWeight: FontWeight.w500),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 5,
                              height: 5,
                              decoration: BoxDecoration(
                                color: isAvailable ? AppColors.success : AppColors.error,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 3),
                            Text(
                              isAvailable ? 'In stock' : 'Out of stock',
                              style: TextStyle(
                                color: isAvailable ? AppColors.success : AppColors.error,
                                fontSize: 9.5,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),

                    // Product Name (2 lines max)
                    SizedBox(
                      height: 32,
                      child: Text(
                        widget.product.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.titleMedium(
                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                        ).copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          height: 1.25,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),

                    // 2 Small Tag Chips
                    if (widget.product.tags.isNotEmpty)
                      SizedBox(
                        height: 20,
                        child: Row(
                          children: widget.product.tags.take(2).map((tag) {
                            return Flexible(
                              child: Container(
                                margin: const EdgeInsets.only(right: 4),
                                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? AppColors.darkBgTop.withValues(alpha: 0.6)
                                      : AppColors.lightBgBottom.withValues(alpha: 0.8),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: isDark
                                        ? AppColors.darkCardBorder.withValues(alpha: 0.7)
                                        : AppColors.lightCardBorder,
                                    width: 0.8,
                                  ),
                                ),
                                child: Text(
                                  tag,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyles.bodySmall(
                                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                  ).copyWith(fontSize: 9, fontWeight: FontWeight.w500),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      )
                    else
                      const SizedBox(height: 20),

                    const SizedBox(height: 6),

                    // Price (formatted PKR)
                    Text(
                      formatPkr(widget.product.price.toInt()),
                      style: AppTextStyles.titleMedium(
                        color: priceColor,
                      ).copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 13.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholder(bool isDark) {
    return Container(
      color: isDark ? const Color(0xFF220D42) : const Color(0xFFEDE3FD),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.card_giftcard_rounded,
              size: 32,
              color: AppColors.yellowAccent.withValues(alpha: 0.8),
            ),
            const SizedBox(height: 4),
            Text(
              'AI Genius',
              style: AppTextStyles.bodySmall(
                color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
              ).copyWith(fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingPlaceholder(bool isDark) {
    return Container(
      color: isDark ? const Color(0xFF220D42) : const Color(0xFFEDE3FD),
      child: Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(
              AppColors.yellowAccent.withValues(alpha: 0.8),
            ),
          ),
        ),
      ),
    );
  }
}
