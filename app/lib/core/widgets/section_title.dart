import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? icon;
  final Widget? trailing;
  final bool showSparkle;

  const SectionTitle({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.trailing,
    this.showSparkle = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color titleColor = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final Color subtitleColor = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              icon!,
              const SizedBox(width: 8),
            ],
            Expanded(
              child: Row(
                children: [
                  Flexible(
                    child: Text(
                      title,
                      style: AppTextStyles.titleMedium(color: titleColor),
                    ),
                  ),
                  if (showSparkle) ...[
                    const SizedBox(width: 6),
                    const Icon(
                      Icons.auto_awesome,
                      color: AppColors.yellowAccent,
                      size: 18,
                    ),
                  ],
                ],
              ),
            ),
            ?trailing,
          ],
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 4),
          Text(
            subtitle!,
            style: AppTextStyles.bodyMedium(color: subtitleColor),
          ),
        ],
      ],
    );
  }
}
