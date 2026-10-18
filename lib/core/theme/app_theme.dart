import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: AppColors.primaryDark,
      scaffoldBackgroundColor: AppColors.backgroundLight,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primaryDark,
        secondary: AppColors.info,
        surface: AppColors.surface,
        error: AppColors.danger,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: AppColors.textPrimary,
        onError: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surface,
        elevation: 0.5,
        scrolledUnderElevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.primaryDark),
        actionsIconTheme: IconThemeData(color: AppColors.primaryDark),
        titleTextStyle: TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.bold,
          fontSize: 16,
          fontFamily:
              'Cairo', // Assuming an Arabic font is used, modify if needed
        ),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: AppColors.textPrimary),
        bodyMedium: TextStyle(color: AppColors.textPrimary),
        bodySmall: TextStyle(color: AppColors.textSecondary),
        titleLarge: TextStyle(
            color: AppColors.primaryDark, fontWeight: FontWeight.bold),
        titleMedium: TextStyle(
            color: AppColors.primaryDark, fontWeight: FontWeight.bold),
        titleSmall: TextStyle(
            color: AppColors.textPrimary, fontWeight: FontWeight.bold),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryDark,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryDark,
          side: const BorderSide(color: AppColors.cardBorder),
          backgroundColor: AppColors.surface,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.cardBorder,
        thickness: 1,
        space: 20,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.primaryDark,
        actionTextColor: Colors.white,
        contentTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.w600,
          fontFamily: 'Cairo',
        ),
        behavior: SnackBarBehavior.floating,
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      iconTheme: const IconThemeData(
        color: AppColors.primaryDark,
        size: 20,
      ),
    );
  }

  static ThemeData get darkTheme {
    const palette = AppThemePalette.dark;
    const colorScheme = ColorScheme.dark(
      primary: Color(0xFFA4BEF2),
      onPrimary: Color(0xFF101B2C),
      secondary: Color(0xFF62D0B4),
      onSecondary: Color(0xFF08251E),
      surface: Color(0xFF141F2D),
      onSurface: Color(0xFFEAF0F7),
      error: Color(0xFFFF8585),
      onError: Color(0xFF331011),
      outline: Color(0xFF3A4C61),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: colorScheme.primary,
      scaffoldBackgroundColor: palette.background,
      canvasColor: palette.background,
      colorScheme: colorScheme,
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF141F2D),
        foregroundColor: Color(0xFFEAF0F7),
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Color(0xFFA4BEF2)),
        actionsIconTheme: IconThemeData(color: Color(0xFFA4BEF2)),
        titleTextStyle: TextStyle(
          color: Color(0xFFEAF0F7),
          fontWeight: FontWeight.bold,
          fontSize: 16,
          fontFamily: 'Cairo',
        ),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Color(0xFFEAF0F7), fontFamily: 'Cairo'),
        bodyMedium: TextStyle(color: Color(0xFFEAF0F7), fontFamily: 'Cairo'),
        bodySmall: TextStyle(color: Color(0xFFAFBDCD), fontFamily: 'Cairo'),
        titleLarge: TextStyle(
          color: Color(0xFFEAF0F7),
          fontWeight: FontWeight.bold,
          fontFamily: 'Cairo',
        ),
        titleMedium: TextStyle(
          color: Color(0xFFEAF0F7),
          fontWeight: FontWeight.bold,
          fontFamily: 'Cairo',
        ),
        titleSmall: TextStyle(
          color: Color(0xFFEAF0F7),
          fontWeight: FontWeight.bold,
          fontFamily: 'Cairo',
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
            fontFamily: 'Cairo',
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.primary,
          side: const BorderSide(color: Color(0xFF3A4C61)),
          backgroundColor: colorScheme.surface,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
            fontFamily: 'Cairo',
          ),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xFF334357),
        thickness: 1,
        space: 20,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: const Color(0xFF26364A),
        actionTextColor: colorScheme.secondary,
        contentTextStyle: const TextStyle(
          color: Color(0xFFEAF0F7),
          fontSize: 13,
          fontWeight: FontWeight.w600,
          fontFamily: 'Cairo',
        ),
        behavior: SnackBarBehavior.floating,
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: Color(0xFF1C2A3B),
        hintStyle: TextStyle(color: Color(0xFF8293A8)),
        labelStyle: TextStyle(color: Color(0xFFAFBDCD)),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF3A4C61)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF3A4C61)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFA4BEF2), width: 1.5),
        ),
      ),
      popupMenuTheme: const PopupMenuThemeData(
        color: Color(0xFF1C2A3B),
        textStyle: TextStyle(color: Color(0xFFEAF0F7), fontFamily: 'Cairo'),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Color(0xFF141F2D),
        modalBackgroundColor: Color(0xFF141F2D),
      ),
      iconTheme: const IconThemeData(
        color: Color(0xFFAFBDCD),
        size: 20,
      ),
      extensions: const [AppThemePalette.dark],
    );
  }
}

@immutable
class AppThemePalette extends ThemeExtension<AppThemePalette> {
  final Color background;
  final Color surface;
  final Color surfaceElevated;
  final Color border;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color accent;
  final Color accentContainer;
  final Color success;
  final Color warning;
  final Color danger;

  const AppThemePalette({
    required this.background,
    required this.surface,
    required this.surfaceElevated,
    required this.border,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.accent,
    required this.accentContainer,
    required this.success,
    required this.warning,
    required this.danger,
  });

  static const dark = AppThemePalette(
    background: Color(0xFF0C131E),
    surface: Color(0xFF141F2D),
    surfaceElevated: Color(0xFF1C2A3B),
    border: Color(0xFF33475E),
    textPrimary: Color(0xFFEAF0F7),
    textSecondary: Color(0xFFAFBDCD),
    textMuted: Color(0xFF8293A8),
    accent: Color(0xFFA4BEF2),
    accentContainer: Color(0xFF253750),
    success: Color(0xFF58D1A4),
    warning: Color(0xFFF2B766),
    danger: Color(0xFFFF8585),
  );

  static const light = AppThemePalette(
    background: AppColors.backgroundLight,
    surface: AppColors.surface,
    surfaceElevated: AppColors.surfaceLight,
    border: AppColors.cardBorder,
    textPrimary: AppColors.textPrimary,
    textSecondary: AppColors.textSecondary,
    textMuted: AppColors.textMuted,
    accent: AppColors.primaryDark,
    accentContainer: AppColors.surfaceHighlight,
    success: AppColors.success,
    warning: AppColors.warning,
    danger: AppColors.danger,
  );

  @override
  AppThemePalette copyWith({
    Color? background,
    Color? surface,
    Color? surfaceElevated,
    Color? border,
    Color? textPrimary,
    Color? textSecondary,
    Color? textMuted,
    Color? accent,
    Color? accentContainer,
    Color? success,
    Color? warning,
    Color? danger,
  }) =>
      AppThemePalette(
        background: background ?? this.background,
        surface: surface ?? this.surface,
        surfaceElevated: surfaceElevated ?? this.surfaceElevated,
        border: border ?? this.border,
        textPrimary: textPrimary ?? this.textPrimary,
        textSecondary: textSecondary ?? this.textSecondary,
        textMuted: textMuted ?? this.textMuted,
        accent: accent ?? this.accent,
        accentContainer: accentContainer ?? this.accentContainer,
        success: success ?? this.success,
        warning: warning ?? this.warning,
        danger: danger ?? this.danger,
      );

  @override
  AppThemePalette lerp(ThemeExtension<AppThemePalette>? other, double t) {
    if (other is! AppThemePalette) return this;
    return AppThemePalette(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceElevated: Color.lerp(surfaceElevated, other.surfaceElevated, t)!,
      border: Color.lerp(border, other.border, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      accentContainer: Color.lerp(accentContainer, other.accentContainer, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
    );
  }
}

extension AppThemePaletteContext on BuildContext {
  AppThemePalette get appThemePalette =>
      Theme.of(this).extension<AppThemePalette>() ?? AppThemePalette.light;
}
