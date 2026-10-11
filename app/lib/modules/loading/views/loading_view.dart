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

    _pulseAnimation = Tween<double>(begin: 0.90, end: 1.10).animate(
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
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.darkBgTop,
              AppColors.darkBgBottom,
            ],
          ),
        ),
        child: SafeArea(
          child: Obx(() {
            if (controller.hasError.value) {
              return _buildErrorState(context, controller);
            }
            return _buildLoadingState(context, controller, req, isDark);
          }),
        ),
      ),
    );
  }

  Widget _buildLoadingState(
    BuildContext context,
    LoadingController controller,
    dynamic req,
    bool isDark,
  ) {
    return Center(
      child: Padding(
        padding: AppSpacing.edgeInsetsScreen,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated glowing yellow sparkle orb (pulsing rings)
            AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    // Outer pulsing ring
                    Container(
                      width: 144 * _pulseAnimation.value,
                      height: 144 * _pulseAnimation.value,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.yellowAccent.withValues(alpha: 0.2),
                          width: 1.5,
                        ),
                      ),
                    ),
                    // Middle soft glow ring
                    Container(
                      width: 112 * _pulseAnimation.value,
                      height: 112 * _pulseAnimation.value,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.yellowSoftTint,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.yellowAccent.withValues(alpha: 0.35),
                            blurRadius: 32,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                    ),
                    // Core yellow orb with sparkle
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

            const SizedBox(height: 40),

            // Status text changing every 1 second
            Obx(
              () => AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, anim) => FadeTransition(
                  opacity: anim,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.2),
                      end: Offset.zero,
                    ).animate(anim),
                    child: child,
                  ),
                ),
                child: Text(
                  controller.currentStatus,
                  key: ValueKey<String>(controller.currentStatus),
                  textAlign: TextAlign.center,
                  style: AppTextStyles.titleMedium(
                    color: AppColors.darkTextPrimary,
                  ).copyWith(fontSize: 18),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Friendly line displayed after 8s: "Waking up the AI server, this can take a minute."
            Obx(() {
              if (!controller.showServerWakeupNotice.value) {
                return const SizedBox.shrink();
              }
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.yellowSoftTint,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.yellowAccent.withValues(alpha: 0.35),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.hourglass_top_rounded,
                        size: 16,
                        color: AppColors.yellowAccent,
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          'Waking up the AI server, this can take a minute.',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.bodySmall(
                            color: AppColors.yellowAccent,
                          ).copyWith(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),

            // Summary chip row of user's choices
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.darkCardSurface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.darkCardBorder,
                ),
              ),
              child: Text(
                '${req.relationship} · ${req.occasion} · ${formatPkr(req.budget.toInt())}',
                style: AppTextStyles.bodyMedium(
                  color: AppColors.darkTextSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, LoadingController controller) {
    return Center(
      child: Padding(
        padding: AppSpacing.edgeInsetsScreen,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.15),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.error.withValues(alpha: 0.4),
                  width: 1.5,
                ),
              ),
              child: const Center(
                child: Icon(
                  Icons.error_outline_rounded,
                  size: 44,
                  color: AppColors.error,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Unable to Pick Gifts',
              style: AppTextStyles.headingSmall(color: AppColors.darkTextPrimary),
            ),
            const SizedBox(height: 8),
            Text(
              controller.errorMessage.value.isNotEmpty
                  ? controller.errorMessage.value
                  : 'An error occurred while finding recommendations.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium(color: AppColors.darkTextSecondary),
            ),
            const SizedBox(height: 28),
            AppButton(
              title: 'Retry',
              icon: const Icon(Icons.refresh_rounded, color: AppColors.textOnYellow, size: 20),
              fullWidth: false,
              padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 14),
              onPressed: () => controller.retry(),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => Get.back(),
              child: Text(
                'Back to Preferences',
                style: AppTextStyles.bodyMedium(color: AppColors.darkTextSecondary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
