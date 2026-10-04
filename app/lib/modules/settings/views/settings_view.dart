import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/theme_controller.dart';
import '../../../core/widgets/widgets.dart';
import '../controllers/settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure controller is registered
    final settingsController = Get.isRegistered<SettingsController>()
        ? Get.find<SettingsController>()
        : Get.put(SettingsController());

    final themeController = ThemeController.to;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Bar with Back Button
              _buildTopBar(context, isDark),

              // Scrollable Settings Content
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.screenPadding,
                    8,
                    AppSpacing.screenPadding,
                    32,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Section 1: Theme Selector
                      const SectionTitle(
                        title: 'Theme',
                        subtitle: 'Changes instantly without restart',
                        icon: Icon(
                          Icons.palette_rounded,
                          color: AppColors.yellowAccent,
                          size: 20,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Obx(() {
                        final currentMode = themeController.themeMode;
                        return Row(
                          children: [
                            _buildThemeOptionCard(
                              context: context,
                              label: 'Dark',
                              subtitle: 'Deep Purple',
                              icon: Icons.dark_mode_rounded,
                              isSelected: currentMode == ThemeMode.dark,
                              onTap: () => settingsController.setThemeMode(ThemeMode.dark),
                            ),
                            const SizedBox(width: 10),
                            _buildThemeOptionCard(
                              context: context,
                              label: 'Light',
                              subtitle: 'Lavender',
                              icon: Icons.light_mode_rounded,
                              isSelected: currentMode == ThemeMode.light,
                              onTap: () => settingsController.setThemeMode(ThemeMode.light),
                            ),
                            const SizedBox(width: 10),
                            _buildThemeOptionCard(
                              context: context,
                              label: 'System',
                              subtitle: 'Auto Match',
                              icon: Icons.settings_brightness_rounded,
                              isSelected: currentMode == ThemeMode.system,
                              onTap: () => settingsController.setThemeMode(ThemeMode.system),
                            ),
                          ],
                        );
                      }),

                      const SizedBox(height: 24),

                      // Section 2: About Section
                      const SectionTitle(
                        title: 'About',
                        subtitle: 'AI-driven gift recommendation assistant',
                        icon: Icon(
                          Icons.auto_awesome,
                          color: AppColors.yellowAccent,
                          size: 20,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildAboutCard(context, settingsController, isDark),

                      const SizedBox(height: 24),

                      // Section 3: App Information & Version
                      const SectionTitle(
                        title: 'App Details',
                        subtitle: 'Version and build specifications',
                        icon: Icon(
                          Icons.info_outline_rounded,
                          color: AppColors.yellowAccent,
                          size: 20,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildAppDetailsCard(context, settingsController, isDark),

                      const SizedBox(height: 24),

                      // Footer
                      Center(
                        child: Text(
                          'AI Genius © 2026 · Gifts, chosen by AI',
                          style: AppTextStyles.caption(
                            color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- TOP BAR ---
  Widget _buildTopBar(BuildContext context, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              Icons.arrow_back_rounded,
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            ),
            tooltip: 'Back',
            onPressed: () => Get.back(),
          ),
          const SizedBox(width: 4),
          Text(
            'Settings',
            style: AppTextStyles.headingSmall(
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            ).copyWith(fontSize: 20),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.yellowSoftTint,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.yellowAccent.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.auto_awesome,
                  color: AppColors.yellowAccent,
                  size: 13,
                ),
                const SizedBox(width: 5),
                Text(
                  'v1.0.0',
                  style: AppTextStyles.caption(
                    color: isDark ? AppColors.yellowAccent : AppColors.lightPrimary,
                  ).copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }

  // --- THEME OPTION CARD ---
  Widget _buildThemeOptionCard({
    required BuildContext context,
    required String label,
    required String subtitle,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final unselectedBg = isDark ? AppColors.darkCardSurface : AppColors.lightCardSurface;
    final unselectedBorder = isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder;
    final unselectedTextColor = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final unselectedIconColor = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final unselectedSubtextColor = isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted;

    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.yellowAccent : unselectedBg,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: isSelected ? AppColors.yellowAccent : unselectedBorder,
                width: isSelected ? 1.8 : 1.0,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: AppColors.yellowAccent.withValues(alpha: 0.35),
                        blurRadius: 14,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Top Check Badge or Space
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected
                          ? AppColors.textOnYellow
                          : Colors.transparent,
                    ),
                    child: isSelected
                        ? const Icon(
                            Icons.check_rounded,
                            size: 13,
                            color: AppColors.yellowAccent,
                          )
                        : null,
                  ),
                ),

                const SizedBox(height: 2),

                // Icon
                Icon(
                  icon,
                  size: 28,
                  color: isSelected ? AppColors.textOnYellow : unselectedIconColor,
                ),

                const SizedBox(height: 10),

                // Title
                Text(
                  label,
                  style: AppTextStyles.titleMedium(
                    color: isSelected ? AppColors.textOnYellow : unselectedTextColor,
                  ).copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 2),

                // Subtitle
                Text(
                  subtitle,
                  style: AppTextStyles.caption(
                    color: isSelected
                        ? AppColors.textOnYellow.withValues(alpha: 0.75)
                        : unselectedSubtextColor,
                  ).copyWith(fontSize: 11),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- ABOUT CARD ---
  Widget _buildAboutCard(
    BuildContext context,
    SettingsController controller,
    bool isDark,
  ) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo and Tagline
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF34155E), Color(0xFF1A0B2E)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.yellowAccent.withValues(alpha: 0.4),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.yellowAccent.withValues(alpha: 0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(
                      Icons.card_giftcard_rounded,
                      color: Colors.white,
                      size: 26,
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Icon(
                        Icons.auto_awesome,
                        color: AppColors.yellowAccent,
                        size: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          controller.appName,
                          style: AppTextStyles.headingSmall(
                            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Icon(
                          Icons.auto_awesome,
                          color: AppColors.yellowAccent,
                          size: 15,
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      controller.appTagline,
                      style: AppTextStyles.bodySmall(
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      ).copyWith(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Description
          Text(
            controller.appDescription,
            style: AppTextStyles.bodyMedium(
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            ).copyWith(height: 1.5),
          ),

          const SizedBox(height: 18),

          Divider(
            color: isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder,
            height: 1,
          ),

          const SizedBox(height: 16),

          // Features List
          ...controller.highlights.map((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.yellowSoftTint,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      item['icon'] as IconData,
                      color: isDark ? AppColors.yellowAccent : AppColors.lightPrimary,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['title'] as String,
                          style: AppTextStyles.titleSmall(
                            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                          ).copyWith(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item['description'] as String,
                          style: AppTextStyles.bodySmall(
                            color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  // --- APP DETAILS CARD ---
  Widget _buildAppDetailsCard(
    BuildContext context,
    SettingsController controller,
    bool isDark,
  ) {
    return AppCard(
      child: Column(
        children: [
          _buildInfoRow(
            label: 'App Version',
            value: controller.appVersion,
            isDark: isDark,
            valueBadge: true,
          ),
          _buildDivider(isDark),
          _buildInfoRow(
            label: 'Build',
            value: '${controller.appVersion}+${controller.buildNumber}',
            isDark: isDark,
          ),
          _buildDivider(isDark),
          _buildInfoRow(
            label: 'Tech Stack',
            value: 'Flutter · GetX · Material 3',
            isDark: isDark,
          ),
          _buildDivider(isDark),
          _buildInfoRow(
            label: 'Recommendation Engine',
            value: 'AI Persona & Catalog Matching',
            isDark: isDark,
          ),
          _buildDivider(isDark),
          const SizedBox(height: 4),
          InkWell(
            onTap: () {
              showLicensePage(
                context: context,
                applicationName: controller.appName,
                applicationVersion: controller.appVersion,
                applicationLegalese: 'AI Genius © 2026 · Thoughtful Gifting Powered by AI',
              );
            },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              child: Row(
                children: [
                  Icon(
                    Icons.description_outlined,
                    size: 20,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Open Source Licenses',
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodyMedium(
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      ).copyWith(fontWeight: FontWeight.w500),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.chevron_right_rounded,
                    size: 20,
                    color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required String label,
    required String value,
    required bool isDark,
    bool valueBadge = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 4,
            child: Text(
              label,
              style: AppTextStyles.bodyMedium(
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              ),
            ),
          ),
          const SizedBox(width: 8),
          if (valueBadge)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.yellowSoftTint,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: AppColors.yellowAccent.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Text(
                value,
                style: AppTextStyles.bodySmall(
                  color: isDark ? AppColors.yellowAccent : AppColors.lightPrimary,
                ).copyWith(fontWeight: FontWeight.w600),
              ),
            )
          else
            Expanded(
              flex: 5,
              child: Text(
                value,
                style: AppTextStyles.bodyMedium(
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ).copyWith(fontWeight: FontWeight.w600),
                textAlign: TextAlign.end,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDivider(bool isDark) {
    return Divider(
      color: isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder,
      height: 1,
    );
  }
}
