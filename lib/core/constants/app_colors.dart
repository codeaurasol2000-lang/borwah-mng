import 'package:flutter/material.dart';

class AppColors {
  // الألوان الأساسية
  static const Color primaryDark = Color(0xFF071228);   // الكحلي الداكن للأزرار والبطاقات الرئيسية
  static const Color primaryExtraDark = Color(0xFF0F172A); // الكحلي الداكن جدا للبطاقات العلوية
  static const Color background = Color(0xFFF6F8FB);    // رمادي فاتح جداً لخلفية التطبيق
  static const Color backgroundLight = Color(0xFFF9FAFB); // لون خلفية أفتح للشاشات
  static const Color surface = Colors.white;            // أبيض ناصع للكروت
  static const Color surfaceLight = Color(0xFFF1F5F9);  // رمادي مزرق فاتح (للخلفيات الداخلية)
  static const Color surfaceMuted = Color(0xFFFAFAFA);  // لون رمادي خافت جدا للخلفيات الداخلية للبطاقات
  static const Color surfaceHighlight = Color(0xFFEEF2F6); 
  static const Color cardBorder = Color(0xFFE2E8F0);    // لون حدود الكروت الرفيعة
  static const Color borderLight = Color(0xFFEEEEEE);
  static const Color borderMedium = Color(0xFFE0E0E0);

  // النصوص
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textMuted = Color(0xFF94A3B8);
  static const Color textMutedDark = Color(0xFF757575);
  static const Color textSecondaryDark = Color(0xFF616161);

  // الحالات والتنبيهات (الأخضر/النجاح)
  static const Color success = Color(0xFF10B981);       // الأخضر (اعتماد / نشط / ربط فوري)
  static const Color successLight = Color(0xFFECFDF5);
  static const Color successBorder = Color(0xFFA7F3D0);
  static const Color successDark = Color(0xFF047857);
  
  // الحالات والتنبيهات (البرتقالي/التحذير)
  static const Color warning = Color(0xFFF59E0B);       // البرتقالي (معلق / قيد المراجعة)
  static const Color warningLight = Color(0xFFFFFBEB);
  static const Color warningBorder = Color(0xFFFDE68A);
  static const Color warningDark = Color(0xFFB45309);

  // الحالات والتنبيهات (الأحمر/الخطر)
  static const Color danger = Color(0xFFEF4444);        // الأحمر (تجميد / رفض / احتراز)
  static const Color dangerLight = Color(0xFFFEF2F2);   // خلفية كروت الخطر الخفيفة
  static const Color dangerBorder = Color(0xFFFECACA);
  static const Color dangerDark = Color(0xFFB91C1C);

  // الحالات والتنبيهات (الأزرق/المعلومات)
  static const Color info = Color(0xFF0284C7);          // الأزرق الإرشادي والتحقق
  static const Color infoLight = Color(0xFFF0F9FF);
  static const Color infoBorder = Color(0xFFE0F2FE);
  static const Color infoDark = Color(0xFF0369A1);

  static const Color purple = Color(0xFF6366F1);        // لون محفظة stc pay
}