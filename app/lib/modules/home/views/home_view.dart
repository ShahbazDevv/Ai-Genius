import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/theme_controller.dart';
import '../../../core/utils/app_utils.dart';
import '../../../core/widgets/widgets.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: Obx(() {
          final tabIndex = controller.currentTabIndex.value;
          return IndexedStack(
            index: tabIndex,
            children: [
              _buildHomeFormTab(context),
              _buildSavedTab(context),
              _buildHistoryTab(context),
            ],
          );
        }),
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  // --- TAB 0: HOME GIFT PREFERENCES FORM ---
  Widget _buildHomeFormTab(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final highlightColor = AppColors.highlightText(isDark);

    return Column(
      children: [
        // Top Bar
        _buildTopBar(context),

        // Scrollable Section Cards
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),

                // Main Heading & Subtext
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Find the Perfect Gift',
                        style: AppTextStyles.headingLarge(
                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                        ).copyWith(fontSize: 24),
                      ),
                    ),
                    const Icon(
                      Icons.auto_awesome,
                      color: AppColors.yellowAccent,
                      size: 22,
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'Tell us about the person and AI Genius will suggest the best gifts.',
                  style: AppTextStyles.bodyMedium(
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                ),
                const SizedBox(height: AppSpacing.sectionGap),

                // 1. Card "Who is it for?"
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SectionTitle(
                        title: 'Who is it for?',
                        subtitle: 'Choose one',
                        icon: Icon(Icons.person_rounded, color: AppColors.yellowAccent, size: 20),
                      ),
                      const SizedBox(height: 12),
                      Obx(() {
                        final selected = controller.relationship.value;
                        return Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: HomeController.relationshipOptions.map((opt) {
                            return SelectableChip(
                              label: opt,
                              isSelected: selected == opt,
                              onSelected: (_) => controller.setRelationship(opt),
                            );
                          }).toList(),
                        );
                      }),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.itemGap),

                // 2. Card "Age group"
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SectionTitle(
                        title: 'Age group',
                        icon: Icon(Icons.cake_rounded, color: AppColors.yellowAccent, size: 20),
                      ),
                      const SizedBox(height: 12),
                      Obx(() {
                        final selected = controller.ageGroup.value;
                        return Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: HomeController.ageGroupOptions.map((opt) {
                            return SelectableChip(
                              label: opt,
                              isSelected: selected == opt,
                              onSelected: (_) => controller.setAgeGroup(opt),
                            );
                          }).toList(),
                        );
                      }),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.itemGap),

                // 3. Card "Gender (optional)"
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SectionTitle(
                        title: 'Gender (optional)',
                        icon: Icon(Icons.wc_rounded, color: AppColors.yellowAccent, size: 20),
                      ),
                      const SizedBox(height: 12),
                      Obx(() {
                        final selected = controller.gender.value;
                        return Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: HomeController.genderOptions.map((opt) {
                            return SelectableChip(
                              label: opt,
                              isSelected: selected == opt,
                              onSelected: (_) => controller.setGender(opt),
                            );
                          }).toList(),
                        );
                      }),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.itemGap),

                // 4. Card "Occasion"
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SectionTitle(
                        title: 'Occasion',
                        subtitle: 'What are you celebrating?',
                        icon: Icon(Icons.celebration_rounded, color: AppColors.yellowAccent, size: 20),
                      ),
                      const SizedBox(height: 12),
                      Obx(() {
                        final selected = controller.occasion.value;
                        return Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: HomeController.occasionOptions.map((opt) {
                            return SelectableChip(
                              label: opt,
                              isSelected: selected == opt,
                              onSelected: (_) => controller.setOccasion(opt),
                            );
                          }).toList(),
                        );
                      }),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.itemGap),

                // 5. Card "Budget"
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SectionTitle(
                        title: 'Budget',
                        icon: Icon(Icons.payments_rounded, color: AppColors.yellowAccent, size: 20),
                      ),
                      const SizedBox(height: 12),
                      Obx(() {
                        final budgetVal = controller.budget.value.toInt();
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Budget: ${formatPkr(budgetVal)}',
                              style: AppTextStyles.headingMedium(
                                color: highlightColor,
                              ).copyWith(fontSize: 20),
                            ),
                            const SizedBox(height: 8),
                            Slider(
                              value: controller.budget.value,
                              min: 500,
                              max: 15000,
                              divisions: 29, // steps of 500: (15000-500)/500 = 29
                              onChanged: (val) => controller.setBudget(val),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  formatPkr(500),
                                  style: AppTextStyles.bodySmall(
                                    color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                                  ),
                                ),
                                Text(
                                  formatPkr(15000),
                                  style: AppTextStyles.bodySmall(
                                    color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.itemGap),

                // 6. Card "Interests"
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SectionTitle(
                        title: 'Interests',
                        subtitle: 'Pick one or more',
                        icon: Icon(Icons.favorite_rounded, color: AppColors.yellowAccent, size: 20),
                      ),
                      const SizedBox(height: 12),
                      Obx(() {
                        final selected = controller.interests;
                        return Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: HomeController.interestOptions.map((item) {
                            final name = item['name'] as String;
                            final iconData = item['icon'] as IconData;
                            final isSel = selected.contains(name);
                            return SelectableChip(
                              label: name,
                              isSelected: isSel,
                              icon: Icon(
                                iconData,
                                size: 16,
                                color: isSel
                                    ? AppColors.textOnYellow
                                    : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                              ),
                              onSelected: (_) => controller.toggleInterest(name),
                            );
                          }).toList(),
                        );
                      }),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.itemGap),

                // 7. Card "Gift style"
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SectionTitle(
                        title: 'Gift style',
                        icon: Icon(Icons.style_rounded, color: AppColors.yellowAccent, size: 20),
                      ),
                      const SizedBox(height: 12),
                      Obx(() {
                        final selected = controller.giftStyles;
                        return Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: HomeController.giftStyleOptions.map((opt) {
                            final isSel = selected.contains(opt);
                            return SelectableChip(
                              label: opt,
                              isSelected: isSel,
                              onSelected: (_) => controller.toggleGiftStyle(opt),
                            );
                          }).toList(),
                        );
                      }),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.itemGap),

                // 8. Card "Anything else about this person?"
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SectionTitle(
                        title: 'Anything else about this person?',
                        subtitle: 'Optional details (max 200 characters)',
                        icon: Icon(Icons.edit_note_rounded, color: AppColors.yellowAccent, size: 20),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: controller.additionalDetailsController,
                        maxLength: 200,
                        maxLines: 3,
                        style: AppTextStyles.bodyMedium(
                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                        ),
                        decoration: InputDecoration(
                          hintText: 'e.g., loves cats, prefers quiet weekends, minimal aesthetics...',
                          hintStyle: AppTextStyles.bodySmall(
                            color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                          ),
                          filled: true,
                          fillColor: isDark
                              ? AppColors.darkBgTop.withValues(alpha: 0.6)
                              : AppColors.lightBgBottom.withValues(alpha: 0.5),
                          counterStyle: AppTextStyles.bodySmall(
                            color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                          ),
                          contentPadding: const EdgeInsets.all(14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: AppColors.yellowAccent,
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ),

        // Sticky Bottom "Analyze Gifts" Button Container
        _buildStickyAnalyzeButton(context),
      ],
    );
  }

  // --- TOP BAR ---
  Widget _buildTopBar(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenPadding,
        vertical: 10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo and App Name
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCardSurface : AppColors.lightCardSurface,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.yellowAccent.withValues(alpha: 0.5),
                    width: 1.2,
                  ),
                ),
                child: const Center(
                  child: Icon(
                    Icons.card_giftcard_rounded,
                    color: AppColors.yellowAccent,
                    size: 18,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'AI Genius',
                style: AppTextStyles.headingSmall(
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ).copyWith(fontSize: 18),
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.auto_awesome,
                color: AppColors.yellowAccent,
                size: 14,
              ),
            ],
          ),

          // Settings Icon
          IconButton(
            icon: Icon(
              Icons.settings_outlined,
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              size: 24,
            ),
            tooltip: 'Settings',
            onPressed: () => _openSettingsSheet(context),
          ),
        ],
      ),
    );
  }

  // --- STICKY ANALYZE BUTTON ---
  Widget _buildStickyAnalyzeButton(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenPadding,
        12,
        AppSpacing.screenPadding,
        12,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardSurface : AppColors.lightCardSurface,
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder,
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.08),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Obx(() {
        final isValid = controller.isValid;
        final isAnalyzing = controller.isAnalyzing.value;

        return AppButton(
          title: isAnalyzing ? 'Analyzing Gifts...' : 'Analyze Gifts',
          icon: const Icon(
            Icons.auto_awesome,
            color: AppColors.textOnYellow,
            size: 20,
          ),
          isLoading: isAnalyzing,
          onPressed: isValid && !isAnalyzing ? () => controller.analyzeGifts() : null,
        );
      }),
    );
  }

  // --- TAB 1: SAVED GIFTS PLACEHOLDER ---
  Widget _buildSavedTab(BuildContext context) {
    return Column(
      children: [
        _buildTopBar(context),
        Expanded(
          child: EmptyState(
            title: 'No Saved Gifts Yet',
            description: 'Saved products and categories will appear here and are available offline.',
            icon: const Icon(Icons.favorite_border_rounded, size: 40, color: AppColors.yellowAccent),
            buttonText: 'Find Gifts',
            onButtonPressed: () => controller.changeTab(0),
          ),
        ),
      ],
    );
  }

  // --- TAB 2: HISTORY PLACEHOLDER ---
  Widget _buildHistoryTab(BuildContext context) {
    return Column(
      children: [
        _buildTopBar(context),
        Expanded(
          child: EmptyState(
            title: 'No Search History',
            description: 'Past gift searches and recommendations will be stored here.',
            icon: const Icon(Icons.history_rounded, size: 40, color: AppColors.yellowAccent),
            buttonText: 'Start a Search',
            onButtonPressed: () => controller.changeTab(0),
          ),
        ),
      ],
    );
  }

  // --- BOTTOM NAVIGATION BAR WITH YELLOW PILL INDICATOR ---
  Widget _buildBottomNav(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardSurface : AppColors.lightCardSurface,
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder,
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 60,
          child: Obx(() {
            final current = controller.currentTabIndex.value;
            return Row(
              children: [
                _buildNavItem(
                  context: context,
                  index: 0,
                  label: 'Home',
                  icon: Icons.home_rounded,
                  isSelected: current == 0,
                ),
                _buildNavItem(
                  context: context,
                  index: 1,
                  label: 'Saved',
                  icon: Icons.favorite_rounded,
                  isSelected: current == 1,
                ),
                _buildNavItem(
                  context: context,
                  index: 2,
                  label: 'History',
                  icon: Icons.history_rounded,
                  isSelected: current == 2,
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required int index,
    required String label,
    required IconData icon,
    required bool isSelected,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final selectedColor = AppColors.yellowAccent;
    final unselectedColor = isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted;

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => controller.changeTab(index),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 22,
              color: isSelected ? selectedColor : unselectedColor,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: isSelected
                  ? AppTextStyles.bodySmall(color: selectedColor).copyWith(fontWeight: FontWeight.w600)
                  : AppTextStyles.bodySmall(color: unselectedColor),
            ),
            const SizedBox(height: 2),
            // Yellow pill indicator for active bottom nav item
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: isSelected ? 16 : 0,
              height: 3,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.yellowAccent : Colors.transparent,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- SETTINGS BOTTOM SHEET ---
  void _openSettingsSheet(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeController = ThemeController.to;

    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.darkCardSurface : AppColors.lightCardSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Settings',
                    style: AppTextStyles.headingMedium(
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const SectionTitle(
                title: 'Theme',
                subtitle: 'Changes instantly without restart',
                icon: Icon(Icons.palette_rounded, color: AppColors.yellowAccent, size: 20),
              ),
              const SizedBox(height: 12),
              Obx(() {
                final currentMode = themeController.themeMode;
                return Row(
                  children: [
                    _buildThemeCard(
                      context: context,
                      label: 'Dark',
                      icon: Icons.dark_mode_rounded,
                      isSelected: currentMode == ThemeMode.dark,
                      onTap: () => themeController.setThemeMode(ThemeMode.dark),
                    ),
                    const SizedBox(width: 10),
                    _buildThemeCard(
                      context: context,
                      label: 'Light',
                      icon: Icons.light_mode_rounded,
                      isSelected: currentMode == ThemeMode.light,
                      onTap: () => themeController.setThemeMode(ThemeMode.light),
                    ),
                    const SizedBox(width: 10),
                    _buildThemeCard(
                      context: context,
                      label: 'System',
                      icon: Icons.settings_brightness_rounded,
                      isSelected: currentMode == ThemeMode.system,
                      onTap: () => themeController.setThemeMode(ThemeMode.system),
                    ),
                  ],
                );
              }),
              const SizedBox(height: 24),
              Divider(
                color: isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder,
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'App Version',
                    style: AppTextStyles.bodyMedium(
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    ),
                  ),
                  Text(
                    '1.0.0',
                    style: AppTextStyles.bodyMedium(
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    ).copyWith(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'AI-powered gift recommendation app (Flutter + FastAPI + ML)',
                style: AppTextStyles.bodySmall(
                  color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildThemeCard({
    required BuildContext context,
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final unselectedBg = isDark ? AppColors.darkBgTop : AppColors.lightBgTop;
    final unselectedBorder = isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder;
    final unselectedText = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.yellowAccent : unselectedBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? AppColors.yellowAccent : unselectedBorder,
              width: 1.2,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.yellowAccent.withValues(alpha: 0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : null,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isSelected ? AppColors.textOnYellow : unselectedText,
                size: 22,
              ),
              const SizedBox(height: 6),
              Text(
                label,
                style: isSelected
                    ? AppTextStyles.chipSelected(color: AppColors.textOnYellow)
                    : AppTextStyles.chipUnselected(color: unselectedText),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
