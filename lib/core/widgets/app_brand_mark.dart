import 'package:barwah_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class AppBrandMark extends StatelessWidget {
  const AppBrandMark({
    required this.size,
    required this.iconSize,
    super.key,
  });

  final double size;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.hexFF173457, AppColors.hexFF071228],
        ),
        borderRadius: BorderRadius.circular(size * 0.23),
        border: Border.all(color:  AppColors.hexFF43C6AC.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color:  AppColors.hexFF43C6AC.withValues(alpha: 0.18),
            blurRadius: size * 0.3,
            spreadRadius: size * 0.015,
          ),
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.25),
            blurRadius: size * 0.22,
            offset: Offset(0, size * 0.08),
          ),
        ],
        ),
      child: Icon(
        Icons.shield_outlined,
        size: iconSize,
        color: AppColors.white,
        ),
    );
  }
}
