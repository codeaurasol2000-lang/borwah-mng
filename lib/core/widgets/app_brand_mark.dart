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
          colors: [Color(0xFF173457), Color(0xFF071228)],
        ),
        borderRadius: BorderRadius.circular(size * 0.23),
        border: Border.all(color: const Color(0xFF43C6AC).withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF43C6AC).withValues(alpha: 0.18),
            blurRadius: size * 0.3,
            spreadRadius: size * 0.015,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: size * 0.22,
            offset: Offset(0, size * 0.08),
          ),
        ],
        ),
      child: Icon(
        Icons.shield_outlined,
        size: iconSize,
        color: Colors.white,
        ),
    );
  }
}
