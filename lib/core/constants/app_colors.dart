import 'package:flutter/material.dart';

class AppColors {
  // الألوان الأساسية
  static const Color primaryDark = Color(0xFF071228);   // الكحلي الداكن للأزرار والبطاقات الرئيسية
  static const Color background = Color(0xFFF6F8FB);    // رمادي فاتح جداً لخلفية التطبيق
  static const Color surface = Colors.white;            // أبيض ناصع للكروت
  static const Color cardBorder = Color(0xFFE2E8F0);    // لون حدود الكروت الرفيعة

  // النصوص
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textMuted = Color(0xFF94A3B8);

  // الحالات والتنبيهات
  static const Color success = Color(0xFF10B981);       // الأخضر (اعتماد / نشط / ربط فوري)
  static const Color warning = Color(0xFFF59E0B);       // البرتقالي (معلق / قيد المراجعة)
  static const Color danger = Color(0xFFEF4444);        // الأحمر (تجميد / رفض / احتراز)
  static const Color dangerLight = Color(0xFFFEE2E2);   // خلفية كروت الخطر الخفيفة
  static const Color info = Color(0xFF0284C7);          // الأزرق الإرشادي والتحقق
  static const Color purple = Color(0xFF6366F1);        // لون محفظة stc pay
}