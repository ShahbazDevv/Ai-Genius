import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/widgets.dart';
import '../../../data/models/models.dart';
import '../../../routes/app_routes.dart';
import '../../home/controllers/home_controller.dart';
import '../controllers/history_controller.dart';

class HistoryView extends StatelessWidget {
  final bool isEmbedded;

  const HistoryView({
    super.key,
    this.isEmbedded = false,
  });

  @override
  Widget build(BuildContext context) {
    // Ensure controller is registered
    final controller = Get.isRegistered<HistoryController>()
        ? Get.find<HistoryController>()
        : Get.put(HistoryController());

    final isDark = Theme.of(context).brightness == Brightness.dark;

    final content = SafeArea(
      top: !isEmbedded,
      bottom: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Bar
          _buildHeader(context, controller, isDark),

          // Search List or Empty State
          Expanded(
            child: Obx(() {
              final items = controller.historyList;

              if (items.isEmpty) {
                return _buildEmptyState(context);
              }

              return ListView.separated(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screenPadding,
                  8,
                  AppSpacing.screenPadding,
                  24,
                ),
                itemCount: items.length,
                separatorBuilder: (_, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final item = items[index];
                  return _buildHistoryCard(context, item, controller, isDark);
                },
              );
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

  // --- HEADER WITH TITLE & CLEAR ALL BUTTON ---
  Widget _buildHeader(
    BuildContext context,
    HistoryController controller,
    bool isDark,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.screenPadding,
        vertical: isEmbedded ? 10 : 8,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                if (!isEmbedded) ...[
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back_rounded,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    ),
                    onPressed: () => Get.back(),
                  ),
                  const SizedBox(width: 4),
                ],
                Flexible(
                  child: Text(
                    'Search History',
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.headingLarge(
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    ).copyWith(fontSize: 20),
                  ),
                ),
                const SizedBox(width: 6),
                const Icon(
                  Icons.auto_awesome,
                  color: AppColors.yellowAccent,
                  size: 18,
                ),
              ],
            ),
          ),

          // "Clear all" button with confirmation
          Obx(() {
            final hasItems = controller.historyList.isNotEmpty;
            if (!hasItems) return const SizedBox.shrink();

            return TextButton.icon(
              onPressed: () => controller.confirmClearAll(context),
              icon: const Icon(
                Icons.delete_outline_rounded,
                size: 18,
                color: AppColors.error,
              ),
              label: Text(
                'Clear all',
                style: AppTextStyles.bodyMedium(
                  color: AppColors.error,
                ).copyWith(fontWeight: FontWeight.w600),
              ),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                backgroundColor: AppColors.error.withValues(alpha: 0.1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  // --- HISTORY CARD WITH SWIPE-TO-DELETE AND TAP-TO-REOPEN ---
  Widget _buildHistoryCard(
    BuildContext context,
    SearchHistoryItem item,
    HistoryController controller,
    bool isDark,
  ) {
    return Dismissible(
      key: Key(item.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        decoration: BoxDecoration(
          color: AppColors.error.withValues(alpha: 0.85),
          borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'Delete',
              style: AppTextStyles.button(color: Colors.white).copyWith(fontSize: 14),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.delete_sweep_rounded,
              color: Colors.white,
              size: 24,
            ),
          ],
        ),
      ),
      onDismissed: (_) {
        controller.deleteSearch(item.id);
      },
      child: AppCard(
        padding: EdgeInsets.zero,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
          onTap: () => controller.reopenSearch(item),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Occasion / Category Icon in Yellow-tinted Circle
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.yellowSoftTint,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.yellowAccent.withValues(alpha: 0.35),
                      width: 1.2,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      _getOccasionIcon(item.request.occasion),
                      color: AppColors.yellowAccent,
                      size: 24,
                    ),
                  ),
                ),
                const SizedBox(width: 14),

                // Title, Subtitle, and Date
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        item.title,
                        style: AppTextStyles.headingSmall(
                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                        ).copyWith(fontSize: 16),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),

                      // Subtitle (e.g. "Mother · Beauty · PKR 3,500")
                      Text(
                        item.subtitle,
                        style: AppTextStyles.bodyMedium(
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        ).copyWith(fontSize: 13),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),

                      // Date & Category count tag
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.access_time_rounded,
                                size: 13,
                                color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                              ),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  item.formattedDate,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyles.bodySmall(
                                    color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                                  ).copyWith(fontSize: 11),
                                ),
                              ),
                            ],
                          ),
                          if (item.recommendations.isNotEmpty)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? AppColors.darkCardBorder.withValues(alpha: 0.5)
                                    : AppColors.lightCardBorder,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                '${item.recommendations.length} categories',
                                style: AppTextStyles.bodySmall(
                                  color: isDark
                                      ? AppColors.yellowAccent
                                      : AppColors.lightPrimary,
                                ).copyWith(fontSize: 10, fontWeight: FontWeight.w600),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 10),

                // Reopen chevron indicator
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.darkCardBorder.withValues(alpha: 0.3)
                        : AppColors.lightCardBorder.withValues(alpha: 0.5),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 13,
                      color: AppColors.yellowAccent,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- EMPTY STATE ---
  Widget _buildEmptyState(BuildContext context) {
    return EmptyState(
      title: 'No Search History',
      description: 'Searches and AI recommendations will be saved here so you can revisit them anytime.',
      icon: const Icon(
        Icons.history_rounded,
        size: 42,
        color: AppColors.yellowAccent,
      ),
      buttonText: 'Start a Search',
      onButtonPressed: () {
        if (isEmbedded && Get.isRegistered<HomeController>()) {
          HomeController.to.changeTab(0);
        } else {
          Get.offAllNamed(AppRoutes.home);
        }
      },
    );
  }

  IconData _getOccasionIcon(String occasion) {
    final lower = occasion.toLowerCase();
    if (lower.contains('birthday')) {
      return Icons.cake_rounded;
    } else if (lower.contains('wedding') || lower.contains('anniversary') || lower.contains('engagement')) {
      return Icons.favorite_rounded;
    } else if (lower.contains('graduation')) {
      return Icons.school_rounded;
    } else if (lower.contains('thank you')) {
      return Icons.volunteer_activism_rounded;
    } else if (lower.contains('valentine')) {
      return Icons.favorite_border_rounded;
    } else if (lower.contains('eid') || lower.contains('christmas')) {
      return Icons.celebration_rounded;
    }
    return Icons.auto_awesome;
  }
}
