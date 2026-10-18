import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/supervisor_stats_entity.dart';

class MerchantSearchFilterBar extends StatelessWidget {
  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onClearSearch;
  final int selectedFilterIndex;
  final ValueChanged<int> onFilterSelected;
  final SupervisorStatsEntity? stats;
  final VoidCallback? onFilterIconTap;

  const MerchantSearchFilterBar({
    super.key,
    required this.searchController,
    required this.onSearchChanged,
    required this.onClearSearch,
    required this.selectedFilterIndex,
    required this.onFilterSelected,
    this.stats,
    this.onFilterIconTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final palette = context.appThemePalette;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        // Search Input and Filter Button Row
        Row(
          children: [
            // Filter icon button on the left (in RTL) or right (in LTR)
            Container(
              height: 46,
              width: 46,
              decoration: BoxDecoration(
                color: isDark ? palette.surface : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark ? palette.border : AppColors.cardBorder,
                ),
              ),
              child: IconButton(
                icon: Icon(Icons.tune, size: 20, color: palette.textPrimary),
                onPressed: onFilterIconTap,
              ),
            ),
            const SizedBox(width: 8),

            // Search TextField
            Expanded(
              child: Container(
                height: 46,
                decoration: BoxDecoration(
                  color: isDark ? palette.surface : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDark ? palette.border : AppColors.cardBorder,
                  ),
                ),
                child: TextField(
                  controller: searchController,
                  onChanged: onSearchChanged,
                  style: TextStyle(fontSize: 12, color: palette.textPrimary),
                  decoration: InputDecoration(
                    hintText: l10n.searchMerchantsHint,
                    hintStyle:
                        TextStyle(fontSize: 11, color: palette.textMuted),
                    suffixIcon: searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 16),
                            onPressed: onClearSearch,
                          )
                        : Icon(Icons.search,
                            size: 18, color: palette.textMuted),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 12),
                  ),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // Horizontal Filter Chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildFilterChip(
                context,
                index: 0,
                label: '${l10n.filterAll} (${stats?.totalCount ?? 18})',
                isSelected: selectedFilterIndex == 0,
              ),
              const SizedBox(width: 8),
              _buildFilterChip(
                context,
                index: 1,
                label:
                    '${l10n.filterActiveVerified} (${stats?.activeVerifiedCount ?? 12})',
                isSelected: selectedFilterIndex == 1,
              ),
              const SizedBox(width: 8),
              _buildFilterChip(
                context,
                index: 2,
                label:
                    '${l10n.filterUnderAudit} (${stats?.underAuditCount ?? 3})',
                isSelected: selectedFilterIndex == 2,
              ),
              const SizedBox(width: 8),
              _buildFilterChip(
                context,
                index: 3,
                label:
                    '${l10n.filterUpdateRequired} (${stats?.updateRequiredCount ?? 2})',
                isSelected: selectedFilterIndex == 3,
              ),
              const SizedBox(width: 8),
              _buildFilterChip(
                context,
                index: 4,
                label:
                    '${l10n.filterSuspended} (${stats?.suspendedCount ?? 1})',
                isSelected: selectedFilterIndex == 4,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(
    BuildContext context, {
    required int index,
    required String label,
    required bool isSelected,
  }) {
    final palette = context.appThemePalette;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final selectedColor = isDark ? palette.accent : const Color(0xFF07192F);
    return GestureDetector(
      onTap: () => onFilterSelected(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected
              ? selectedColor
              : isDark
                  ? palette.surface
                  : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? selectedColor
                : isDark
                    ? palette.border
                    : AppColors.cardBorder,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected
                ? Theme.of(context).colorScheme.onPrimary
                : palette.textSecondary,
          ),
        ),
      ),
    );
  }
}
