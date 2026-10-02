import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AppBackground extends StatelessWidget {
  final Widget child;
  final bool showGlowBlob;

  const AppBackground({
    super.key,
    required this.child,
    this.showGlowBlob = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDark
              ? [AppColors.darkBgTop, AppColors.darkBgBottom]
              : [AppColors.lightBgTop, AppColors.lightBgBottom],
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (isDark && showGlowBlob)
            Positioned(
              top: -120,
              left: MediaQuery.of(context).size.width / 2 - 160,
              child: IgnorePointer(
                child: Container(
                  width: 320,
                  height: 320,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppColors.darkBlob,
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),
          SafeArea(
            bottom: false,
            child: child,
          ),
        ],
      ),
    );
  }
}
