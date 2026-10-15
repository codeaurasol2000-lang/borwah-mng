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
        onPrimary: AppColors.white,
        onSecondary: AppColors.white,
        onSurface: AppColors.textPrimary,
        onError: AppColors.white,
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
          fontFamily: 'Cairo', // Assuming an Arabic font is used, modify if needed
        ),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: AppColors.textPrimary),
        bodyMedium: TextStyle(color: AppColors.textPrimary),
        bodySmall: TextStyle(color: AppColors.textSecondary),
        titleLarge: TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.bold),
        titleMedium: TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.bold),
        titleSmall: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryDark,
          foregroundColor: AppColors.white,
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
        actionTextColor: AppColors.white,
        contentTextStyle: const TextStyle(
          color: AppColors.white,
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
    const colorScheme = ColorScheme.dark(
      primary: AppColors.darkAccent,
      secondary: AppColors.info,
      surface: AppColors.darkSurface,
      error: AppColors.danger,
      onPrimary: AppColors.white,
      onSecondary: AppColors.white,
      onSurface: AppColors.darkTextPrimary,
      onError: AppColors.white,
    );

    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: AppColors.darkAccent,
      scaffoldBackgroundColor: AppColors.darkBackground,
      colorScheme: colorScheme,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.darkSurface,
        foregroundColor: AppColors.darkTextPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.darkTextPrimary),
        actionsIconTheme: IconThemeData(color: AppColors.darkTextPrimary),
        titleTextStyle: TextStyle(
          color: AppColors.darkTextPrimary,
          fontWeight: FontWeight.bold,
          fontSize: 16,
          fontFamily: 'Cairo',
        ),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: AppColors.darkTextPrimary),
        bodyMedium: TextStyle(color: AppColors.darkTextPrimary),
        bodySmall: TextStyle(color: AppColors.darkTextSecondary),
        titleLarge: TextStyle(color: AppColors.darkTextPrimary, fontWeight: FontWeight.bold),
        titleMedium: TextStyle(color: AppColors.darkTextPrimary, fontWeight: FontWeight.bold),
        titleSmall: TextStyle(color: AppColors.darkTextPrimary, fontWeight: FontWeight.bold),
      ),
      cardTheme: const CardThemeData(
        color: AppColors.darkSurface,
        surfaceTintColor: AppColors.darkSurface,
        margin: EdgeInsets.zero,
      ),
      dialogTheme: const DialogThemeData(
        backgroundColor: AppColors.darkSurface,
        surfaceTintColor: AppColors.darkSurface,
        titleTextStyle: TextStyle(color: AppColors.darkTextPrimary),
        contentTextStyle: TextStyle(color: AppColors.darkTextSecondary),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkSurfaceRaised,
        hintStyle: const TextStyle(color: AppColors.darkTextMuted),
        labelStyle: const TextStyle(color: AppColors.darkTextSecondary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.darkBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.darkBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.darkAccent),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.darkAccent,
          foregroundColor: AppColors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.darkTextPrimary,
          side: const BorderSide(color: AppColors.darkBorder),
          backgroundColor: AppColors.darkSurface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.darkBorder,
        thickness: 1,
        space: 20,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.darkSurfaceRaised,
        actionTextColor: AppColors.darkAccent,
        contentTextStyle: const TextStyle(
          color: AppColors.darkTextPrimary,
          fontSize: 13,
          fontWeight: FontWeight.w600,
          fontFamily: 'Cairo',
        ),
        behavior: SnackBarBehavior.floating,
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.darkSurface,
        selectedItemColor: AppColors.darkAccent,
        unselectedItemColor: AppColors.darkTextMuted,
      ),
      iconTheme: const IconThemeData(color: AppColors.darkTextPrimary, size: 20),
    );
  }
}
