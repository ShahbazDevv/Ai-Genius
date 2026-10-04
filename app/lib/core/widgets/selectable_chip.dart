import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

class SelectableChip extends StatefulWidget {
  final String label;
  final bool isSelected;
  final ValueChanged<bool>? onSelected;
  final Widget? icon;

  const SelectableChip({
    super.key,
    required this.label,
    required this.isSelected,
    this.onSelected,
    this.icon,
  });

  @override
  State<SelectableChip> createState() => _SelectableChipState();
}

class _SelectableChipState extends State<SelectableChip> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color selectedBg = _isPressed ? AppColors.yellowPressed : AppColors.yellowAccent;
    final Color unselectedBg = isDark ? AppColors.darkCardSurface : AppColors.lightCardSurface;
    final Color unselectedBorder = isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder;
    final Color selectedBorder = _isPressed ? AppColors.yellowPressed : AppColors.yellowAccent;

    final Color bgColor = widget.isSelected ? selectedBg : (_isPressed ? AppColors.yellowSoftTint : unselectedBg);
    final Color borderColor = widget.isSelected ? selectedBorder : (_isPressed ? AppColors.yellowPressed : unselectedBorder);

    final Color textColor = widget.isSelected
        ? AppColors.textOnYellow
        : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary);

    return AnimatedScale(
      scale: _isPressed ? 0.97 : 1.0,
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOutCubic,
      child: GestureDetector(
        onTapDown: widget.onSelected != null ? (_) => setState(() => _isPressed = true) : null,
        onTapUp: widget.onSelected != null ? (_) => setState(() => _isPressed = false) : null,
        onTapCancel: widget.onSelected != null ? () => setState(() => _isPressed = false) : null,
        onTap: widget.onSelected != null ? () => widget.onSelected!(!widget.isSelected) : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: AppSpacing.edgeInsetsChip,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: AppSpacing.borderRadiusChip,
            border: Border.all(color: borderColor, width: 1.2),
            boxShadow: widget.isSelected
                ? [
                    BoxShadow(
                      color: AppColors.yellowAccent.withValues(alpha: 0.25),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.isSelected) ...[
                Icon(
                  Icons.check_rounded,
                  size: 16,
                  color: AppColors.textOnYellow,
                ),
                const SizedBox(width: 6),
              ] else if (widget.icon != null) ...[
                widget.icon!,
                const SizedBox(width: 6),
              ],
              Flexible(
                child: Text(
                  widget.label,
                  overflow: TextOverflow.ellipsis,
                  style: widget.isSelected
                      ? AppTextStyles.chipSelected(color: textColor)
                      : AppTextStyles.chipUnselected(color: textColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
