import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/app_utils.dart';
import '../../../core/widgets/widgets.dart';
import '../controllers/loading_controller.dart';

class LoadingView extends StatefulWidget {
  const LoadingView({super.key});

  @override
  State<LoadingView> createState() => _LoadingViewState();
}

class _LoadingViewState extends State<LoadingView> with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.92, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LoadingController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final req = controller.request;

    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: AppSpacing.edgeInsetsScreen,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Animated glowing yellow sparkle orb with pulsing rings
                  AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (context, child) {
                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          // Outer glow ring
                          Container(
                            width: 140 * _pulseAnimation.value,
                            height: 140 * _pulseAnimation.value,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.yellowAccent.withValues(alpha: 0.25),
                                width: 1.5,
                              ),
                            ),
                          ),
                          // Middle glowing ring
                          Container(
                            width: 114 * _pulseAnimation.value,
                            height: 114 * _pulseAnimation.value,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.yellowSoftTint,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.yellowAccent.withValues(alpha: 0.35),
                                  blurRadius: 28,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                          ),
                          // Core yellow sparkle orb
                          Container(
                            width: 80,
                            height: 80,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.yellowAccent,
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.auto_awesome,
                                size: 40,
                                color: AppColors.textOnYellow,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 36),

                  // Changing Status Text
                  Obx(
                    () => AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: Text(
                        controller.currentStatus,
                        key: ValueKey<String>(controller.currentStatus),
                        textAlign: TextAlign.center,
                        style: AppTextStyles.titleMedium(
                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                        ).copyWith(fontSize: 18),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // User's Summary Chip Row
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkCardSurface : AppColors.lightCardSurface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder,
                      ),
                    ),
                    child: Text(
                      '${req.relationship} · ${req.occasion} · ${formatPkr(req.budget.toInt())}',
                      style: AppTextStyles.bodyMedium(
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Completion feedback / placeholder back button
                  Obx(() {
                    if (controller.isComplete.value) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.success.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 18),
                                const SizedBox(width: 6),
                                Text(
                                  '${controller.recommendations.length} categories ready!',
                                  style: AppTextStyles.bodySmall(color: AppColors.success),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          AppButton(
                            title: 'Back to Preferences',
                            fullWidth: false,
                            onPressed: () => Get.back(),
                          ),
                        ],
                      );
                    }
                    return const SizedBox.shrink();
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
