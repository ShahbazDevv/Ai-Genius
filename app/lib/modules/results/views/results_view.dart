import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/app_utils.dart';
import '../../../core/widgets/widgets.dart';
import '../../../data/models/models.dart';
import '../controllers/results_controller.dart';

class ResultsView extends StatefulWidget {
  const ResultsView({super.key});

  @override
  State<ResultsView> createState() => _ResultsViewState();
}

class _ResultsViewState extends State<ResultsView> with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  final ResultsController controller = Get.find<ResultsController>();

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  IconData _getCategoryIcon(String iconName) {
    switch (iconName) {
      case 'spa':
        return Icons.spa_rounded;
      case 'devices':
        return Icons.devices_rounded;
      case 'menu_book':
        return Icons.menu_book_rounded;
      case 'checkroom':
        return Icons.checkroom_rounded;
      case 'local_florist':
        return Icons.local_florist_rounded;
      case 'fitness_center':
        return Icons.fitness_center_rounded;
      case 'sports_esports':
        return Icons.sports_esports_rounded;
      case 'coffee':
        return Icons.coffee_rounded;
      case 'diamond':
        return Icons.diamond_rounded;
      default:
        return Icons.card_giftcard_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final req = controller.request;
    final recommendations = controller.recommendations;

    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back_rounded,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      ),
                      onPressed: () => controller.changeBudget(),
                      tooltip: 'Back to Preferences',
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'AI Genius',
                      style: AppTextStyles.headingSmall(
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.auto_awesome,
                      color: AppColors.yellowAccent,
                      size: 16,
                    ),
                  ],
                ),
              ),

              // Title and Summary Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            'Your AI Gift Suggestions',
                            style: AppTextStyles.headingLarge(
                              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                            ).copyWith(fontSize: 22),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.auto_awesome,
                          color: AppColors.yellowAccent,
                          size: 22,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Summary Row of Inputs
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkCardSurface : AppColors.lightCardSurface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.tune_rounded,
                            size: 16,
                            color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              '${req.relationship} · ${req.occasion} · ${formatPkr(req.budget.toInt())}',
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.bodyMedium(
                                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                              ).copyWith(fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),

              // Results Cards or Empty State
              Expanded(
                child: recommendations.isEmpty
                    ? _buildEmptyState()
                    : _buildRecommendationsList(recommendations, isDark),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- EMPTY STATE ---
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: EmptyState(
          title: 'No suitable gifts found within this budget',
          description: 'Try adjusting your budget or selecting different recipient interests.',
          buttonText: 'Change budget',
          onButtonPressed: () => controller.changeBudget(),
        ),
      ),
    );
  }

  // --- STAGGERED ANIMATED RECOMMENDATIONS LIST ---
  Widget _buildRecommendationsList(List<Recommendation> recommendations, bool isDark) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenPadding,
        0,
        AppSpacing.screenPadding,
        24,
      ),
      itemCount: recommendations.length,
      itemBuilder: (context, index) {
        final rec = recommendations[index];

        // Staggered entry animation: intervals between 0.0 and 1.0
        final double start = (index * 0.15).clamp(0.0, 0.7);
        final double end = (start + 0.35).clamp(0.0, 1.0);

        final animation = CurvedAnimation(
          parent: _animController,
          curve: Interval(start, end, curve: Curves.easeOutCubic),
        );

        return AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            return Opacity(
              opacity: animation.value,
              child: Transform.translate(
                offset: Offset(0, 24 * (1 - animation.value)),
                child: child,
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.itemGap),
            child: _buildCategoryCard(rec, isDark),
          ),
        );
      },
    );
  }

  // --- LARGE CATEGORY CARD ---
  Widget _buildCategoryCard(Recommendation rec, bool isDark) {
    final cat = rec.category;
    final highlightColor = AppColors.highlightText(isDark);

    return AppCard(
      padding: const EdgeInsets.all(16),
      onTap: () => controller.openCategory(rec),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Rank Badge (yellow circle with number in deep purple bold text)
              Container(
                width: 28,
                height: 28,
                decoration: const BoxDecoration(
                  color: AppColors.yellowAccent,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${rec.rank}',
                    style: const TextStyle(
                      color: AppColors.textOnYellow,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),

              // Category Icon in a yellow-tinted circle
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.yellowSoftTint,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.yellowAccent.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Icon(
                    _getCategoryIcon(cat.icon),
                    color: AppColors.yellowAccent,
                    size: 22,
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Category Name & Reason
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cat.name,
                      style: AppTextStyles.titleMedium(
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      ).copyWith(fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      rec.matchReason ?? cat.reason,
                      style: AppTextStyles.bodyMedium(
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      ).copyWith(fontSize: 13, height: 1.3),
                    ),
                  ],
                ),
              ),

              // Heart Save Button (toggles saved without opening card)
              Obx(() {
                final isSaved = controller.isCategorySaved(cat.id);
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => controller.toggleSaveCategory(cat.id),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Icon(
                      isSaved ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                      color: isSaved
                          ? AppColors.yellowAccent
                          : (isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                      size: 22,
                    ),
                  ),
                );
              }),
            ],
          ),

          const SizedBox(height: 14),

          // Bottom Bar: Products within budget label + right arrow
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.darkCardBorder.withValues(alpha: 0.5)
                        : AppColors.lightBgBottom,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${rec.products.length} products within budget',
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodySmall(color: highlightColor).copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'View Gifts',
                    style: AppTextStyles.bodySmall(
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 13,
                    color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
