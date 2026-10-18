import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../utils/app_theme_controller.dart';
import '../../l10n/app_localizations.dart';

class ThemeModeMenuButton extends StatelessWidget {
  const ThemeModeMenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final palette = context.appThemePalette;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return PopupMenuButton<ThemeMode>(
      tooltip: l10n.themeAppearance,
      icon: Icon(
        isDark ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
        color: palette.accent,
      ),
      onSelected: (mode) {
        AppThemeController.instance.setThemeMode(mode);
      },
      itemBuilder: (context) => [
        _buildMenuItem(
          mode: ThemeMode.light,
          label: l10n.themeModeLight,
          icon: Icons.light_mode_outlined,
          selected:
              AppThemeController.instance.themeMode == ThemeMode.light,
          accent: palette.accent,
        ),
        _buildMenuItem(
          mode: ThemeMode.dark,
          label: l10n.themeModeDark,
          icon: Icons.dark_mode_outlined,
          selected:
              AppThemeController.instance.themeMode == ThemeMode.dark,
          accent: palette.accent,
        ),
        _buildMenuItem(
          mode: ThemeMode.system,
          label: l10n.themeModeSystem,
          icon: Icons.brightness_auto_outlined,
          selected:
              AppThemeController.instance.themeMode == ThemeMode.system,
          accent: palette.accent,
        ),
      ],
    );
  }

  PopupMenuItem<ThemeMode> _buildMenuItem({
    required ThemeMode mode,
    required String label,
    required IconData icon,
    required bool selected,
    required Color accent,
  }) {
    return PopupMenuItem<ThemeMode>(
      value: mode,
      child: Row(
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 10),
          Expanded(child: Text(label)),
          if (selected) Icon(Icons.check, size: 18, color: accent),
        ],
      ),
    );
  }
}
