import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import 'app_button.dart';

class EmptyState extends StatelessWidget {
  final String title;
  final String? description;
  final Widget? icon;
  final String? buttonText;
  final VoidCallback? onButtonPressed;

  const EmptyState({
    super.key,
    required this.title,
    this.description,
    this.icon,
    this.buttonText,
    this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color titleColor = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final Color descColor = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return Center(
      child: Padding(
        padding: AppSpacing.edgeInsetsScreen,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: AppColors.yellowSoftTint,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.yellowAccent.withValues(alpha: 0.3),
                  width: 1.5,
                ),
              ),
              child: Center(
                child: icon ??
                    const Icon(
                      Icons.search_off_rounded,
                      size: 40,
                      color: AppColors.yellowAccent,
                    ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTextStyles.headingSmall(color: titleColor),
            ),
            if (description != null) ...[
              const SizedBox(height: 8),
              Text(
                description!,
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium(color: descColor),
              ),
            ],
            if (buttonText != null && onButtonPressed != null) ...[
              const SizedBox(height: 24),
              AppButton(
                title: buttonText!,
                onPressed: onButtonPressed,
                fullWidth: false,
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
