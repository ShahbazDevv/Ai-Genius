import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

class AppButton extends StatefulWidget {
  final String title;
  final VoidCallback? onPressed;
  final Widget? icon;
  final bool isLoading;
  final bool fullWidth;
  final EdgeInsetsGeometry? padding;

  const AppButton({
    super.key,
    required this.title,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.fullWidth = true,
    this.padding,
  });

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool _isPressed = false;

  bool get _isEnabled => widget.onPressed != null && !widget.isLoading;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color normalBg = AppColors.yellowAccent;
    final Color pressedBg = AppColors.yellowPressed;
    final Color disabledBg = isDark
        ? AppColors.darkCardBorder.withValues(alpha: 0.6)
        : AppColors.lightCardBorder;
    final Color disabledTextColor = isDark
        ? AppColors.darkTextMuted
        : AppColors.lightTextMuted;

    final Color bgColor = !_isEnabled
        ? disabledBg
        : (_isPressed ? pressedBg : normalBg);

    final Color textColor = !_isEnabled
        ? disabledTextColor
        : AppColors.textOnYellow;

    final Widget buttonContent = Row(
      mainAxisSize: widget.fullWidth ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.isLoading)
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor: AlwaysStoppedAnimation<Color>(textColor),
            ),
          )
        else ...[
          if (widget.icon != null) ...[
            widget.icon!,
            const SizedBox(width: 8),
          ],
          Text(
            widget.title,
            style: AppTextStyles.button(color: textColor),
          ),
        ],
      ],
    );

    return AnimatedScale(
      scale: _isPressed && _isEnabled ? 0.97 : 1.0,
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOutCubic,
      child: GestureDetector(
        onTapDown: _isEnabled ? (_) => setState(() => _isPressed = true) : null,
        onTapUp: _isEnabled ? (_) => setState(() => _isPressed = false) : null,
        onTapCancel: _isEnabled ? () => setState(() => _isPressed = false) : null,
        onTap: _isEnabled ? widget.onPressed : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: widget.fullWidth ? double.infinity : null,
          padding: widget.padding ?? AppSpacing.edgeInsetsButton,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: AppSpacing.borderRadiusButton,
            boxShadow: _isEnabled
                ? [
                    BoxShadow(
                      color: AppColors.yellowAccent.withValues(alpha: _isPressed ? 0.45 : 0.3),
                      blurRadius: _isPressed ? 12 : 16,
                      spreadRadius: 0,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: buttonContent,
        ),
      ),
    );
  }
}
