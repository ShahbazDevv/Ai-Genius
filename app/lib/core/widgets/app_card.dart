import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final Color? surfaceColor;
  final Color? borderColor;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
    this.surfaceColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bgColor = surfaceColor ??
        (isDark ? AppColors.darkCardSurface.withValues(alpha: 0.95) : AppColors.lightCardSurface);

    final Color strokeColor = borderColor ??
        (isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder);

    final List<BoxShadow> shadows = isDark
        ? [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
            BoxShadow(
              color: AppColors.darkCardBorder.withValues(alpha: 0.15),
              blurRadius: 20,
              offset: const Offset(0, 2),
            ),
          ]
        : [
            BoxShadow(
              color: AppColors.lightCardBorder.withValues(alpha: 0.5),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ];

    Widget content = Container(
      margin: margin,
      padding: padding ?? AppSpacing.edgeInsetsCard,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: AppSpacing.borderRadiusCard,
        border: Border.all(color: strokeColor, width: 1.0),
        boxShadow: shadows,
      ),
      child: child,
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: content,
      );
    }

    return content;
  }
}
